//
//  WJMaxCardViewController.m
//  WanJiCard
//
//  Created by Lynn on 15/9/8.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJMaxCardViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "APIInfoByCodeManager.h"
#import "WJMerchantDetailController.h"

#import "WJSystemAlertView.h"
//设备宽/高/坐标
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height
#define KDeviceFrame [UIScreen mainScreen].bounds

#define kCameraWidth        (kScreenWidth - ALD(kCameraLeft * 2))
#define kCameraHeight       kCameraWidth
#define kCameraLeft         ALD((50))
#define kCameraTop          ALD((100))

static const char *kScanQRCodeQueueName = "ScanQRCodeQueue";

@interface WJMaxCardViewController ()<AVCaptureMetadataOutputObjectsDelegate,WJSystemAlertViewDelegate>
{
    int num;
    BOOL upOrdown;
    BOOL hasGetQRCode;
    BOOL lastResult;
    
    NSTimer * timer;
}

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, strong) UIImageView * line;

@property (nonatomic, strong) APIInfoByCodeManager  * codeManager;
@end

@implementation WJMaxCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"扫一扫";
    self.eventID = @"iOS_act_qrscan";
    self.view.backgroundColor = [UIColor blackColor];
    
    NSString *errorString = [self createCaptureSetting];
    if (!errorString) {
        ALERT(errorString);
    };
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(kCameraLeft, ALD(40), kCameraWidth, ALD(50))];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.font = [UIFont systemFontOfSize:16.0];
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.text=@"将二维码图像置于矩形方框内，系统会自动识别。";
    [self.view addSubview:labIntroudction];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCameraLeft, kCameraTop, kCameraWidth, kCameraHeight)];
    imageView.layer.borderColor = [WJColorWhite CGColor];
    imageView.layer.borderWidth = 1;
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [imageView addSubview:_line];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasGoneInForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasGoneBcakground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self
                                           selector:@selector(animation1)
                                           userInfo:nil
                                            repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

}

-(void)viewWillAppear:(BOOL)animated
{
    hasGetQRCode = NO;
    
    [super viewWillAppear:animated];
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
//        [self showHUDWithText:@"您当前未开启相机权限，请前去设置中开启"];
        
        WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil
                                                                    message:@"提示\n您当前未开启相机权限，请前去设置中开启"
                                                                   delegate:self
                                                          cancelButtonTitle:@"知道了"
                                                          otherButtonTitles:IOS8_LATER?@"去设置":nil
                                                              textAlignment:NSTextAlignmentCenter];
        [alert showIn];
 
    }else
    {
        [self.captureSession startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.captureSession stopRunning];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
}

-(void)backBarButton:(UIButton *)btn
{
    [timer invalidate];
    timer = nil;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];

    NSDictionary  * dic = [manager fetchDataWithReformer:nil];
    NSString * merID = ToString([dic objectForKey:@"Id"]);
    
    WJMerchantDetailController * storeDetailVC = [[WJMerchantDetailController alloc] init];
    storeDetailVC.merId = merID;
    storeDetailVC.isMaxCode = YES;
    [self.navigationController pushViewController:storeDetailVC animated:YES];
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    ALERT(@"无效二维码");
    [self startReading];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        [self stopReading];

        [self performSelectorOnMainThread:@selector(reportScanResult:)
                               withObject:[[metadataObjects firstObject] stringValue]
                            waitUntilDone:NO];
        
    }
}


- (void)reportScanResult:(NSString *)code{
    
    [self showLoadingView];
//    self.codeManager.qrCode = code;
//    [self.codeManager loadData];
    if (ToString(code)) {
        WJMerchantDetailController * storeDetailVC = [[WJMerchantDetailController alloc] init];
        storeDetailVC.merId = code;
        storeDetailVC.isMaxCode = YES;
        [self.navigationController pushViewController:storeDetailVC animated:YES];
    }
    
}


#pragma mark - 扫描设置

- (NSString *)createCaptureSetting{
    // 获取 AVCaptureDevice 实例
    NSError * error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 初始化输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        return [error localizedDescription];
    }
    
    // 创建会话
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];

    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [captureMetadataOutput setRectOfInterest:[self getReaderViewBoundsWithSize:CGSizeMake(kCameraWidth, kCameraHeight)]];
    [_captureSession addOutput:captureMetadataOutput];
    
    // 创建dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create(kScanQRCodeQueueName, NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    // 设置元数据类型 AVMetadataObjectTypeQRCode
    [captureMetadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,
                                                    AVMetadataObjectTypeEAN13Code,
                                                    AVMetadataObjectTypeEAN8Code,
                                                    AVMetadataObjectTypeCode128Code]];
    
    // 创建输出对象
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.view.bounds];
    
    [self.view.layer insertSublayer:_videoPreviewLayer atIndex:0];
    [self addAlphaViewWithAlpha:0.5];
    return nil;
}

- (void)stopReading
{
    [self.captureSession stopRunning];
}


- (void)startReading
{
    [self.captureSession startRunning];
}

#pragma mark- Private Methods
- (void)appHasGoneInForeground
{
    [self viewWillAppear:YES];
}

- (void)appHasGoneBcakground
{
    [self viewWillDisappear:YES];
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(ALD(2), ALD(0) + 2*num,kScreenWidth - ALD(100), 2);
        if (2*num > kCameraWidth) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(ALD(2), ALD(0) + 2*num, kScreenWidth - ALD(100), 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

//- (void)setupCamera
//{
//    _session = nil;
//    _preview = nil;
//    _output = nil;
//    _input = nil;
//    // Device
//    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    
//    // Input
//    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
//    
//    // Output
//    _output = [[AVCaptureMetadataOutput alloc] init];
//    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    //0 ~ 1
////    [_output setRectOfInterest:[self getReaderViewBoundsWithSize:CGSizeMake(kCameraWidth, kCameraHeight)]];
//    //y的起点/屏幕的高，x的起点/屏幕的宽，扫描的区域的高/屏幕的高，扫描的区域的宽/屏幕的宽）
//    [_output setRectOfInterest:[self getReaderViewBoundsWithSize:CGSizeMake(kCameraWidth, kCameraHeight)]];
//    // Session
//    _session = [[AVCaptureSession alloc] init];
//    [_session setSessionPreset:AVCaptureSessionPresetHigh];
//    if ([_session canAddInput:self.input])
//    {
//        [_session addInput:self.input];
//    }
//    
//    if ([_session canAddOutput:self.output])
//    {
//        [_session addOutput:self.output];
//    }
//    
//    //条码类型 AVMetadataObjectTypeQRCode
//    //_output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
//    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
//                                   AVMetadataObjectTypeEAN13Code,
//                                   AVMetadataObjectTypeEAN8Code,
//                                   AVMetadataObjectTypeCode128Code];
//
//    // Preview
//    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
//    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    //    _preview.frame =CGRectMake(ALD(20),ALD(110),ALD(280),ALD(280));
//    
//    //    [_preview setFrame:CGRectMake(20, ALD(110), kScreenWidth - 40, kScreenWidth - 40)];
//    _preview.frame = self.view.bounds;
//    
//    [self.view.layer insertSublayer:self.preview atIndex:0];
//    if (!self.haveViews) {
//        [self addAlphaViewWithAlpha:0.5];
//        self.haveViews = YES;
//    }
//    //    // Start
//    [_session startRunning];
//}

- (void)addAlphaViewWithAlpha:(float) alpha
{
    [self.view addSubview:[self createViewWithFrame:CGRectMake(0, 0, kScreenWidth, kCameraTop) alpha:alpha]];
    [self.view addSubview:[self createViewWithFrame:CGRectMake(0, kCameraTop, kCameraLeft, kCameraHeight) alpha:alpha]];
    [self.view addSubview:[self createViewWithFrame:CGRectMake(kCameraLeft + kCameraWidth, kCameraTop, kScreenWidth - (kCameraWidth + kCameraLeft), kCameraHeight) alpha:alpha]];
    [self.view addSubview:[self createViewWithFrame:CGRectMake(0, kCameraHeight + kCameraTop, kScreenWidth, kScreenHeight - (kCameraTop + kCameraHeight)) alpha:alpha]];
}

- (UIView *)createViewWithFrame:(CGRect)frame  alpha:(float)alpha
{
    UIView * aView = [[UIView alloc] initWithFrame:frame];
    aView.userInteractionEnabled = NO;
    aView.backgroundColor = [UIColor blackColor];
    aView.alpha = alpha;
    
    return aView;
}

- (CGRect)getReaderViewBoundsWithSize:(CGSize)asize
{
    return CGRectMake(kCameraTop / KDeviceHeight, ((kDeviceWidth - asize.width) / 2.0) / kDeviceWidth, asize.height / KDeviceHeight, asize.width / kDeviceWidth);
}

#pragma mark - WJSystemAlertViewDelegate
- (void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",(long)buttonIndex);
    switch (buttonIndex) {
        case 1:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark- Getter and Setter
// TODO:所有属性的初始化，都写在这

- (APIInfoByCodeManager *)codeManager
{
    if (nil == _codeManager) {
        _codeManager = [[APIInfoByCodeManager alloc] init];
        _codeManager.delegate = self;
    }
    return _codeManager;
}

@end
