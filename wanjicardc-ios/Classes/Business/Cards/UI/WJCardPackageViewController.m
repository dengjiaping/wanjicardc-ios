//
//  WJCardPackageViewController.m
//  WanJiCard
//
//  Created by 孙明月 on 16/5/17.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJCardPackageViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WJCardsDetailViewController.h"
#import "WJPayCompleteController.h"
#import "SM3Generation.h"
#import <ZXingObjC/ZXingObjC.h>
#import "CreatQRCodeAndBarCodeFromLeon.h"
#import "APICardPackageManager.h"
#import "WJDBCardManager.h"
#import "WJCardReformer.h"
#import "WJContactReformer.h"
//#import "APIUserContactsManager.h"
#import "WJVerifyPasswordController.h"
#import "WJCardsTableViewCell.h"
#import "WJPayCompleteController.h"
#import "WJRealNameAuthenticationViewController.h"
#import "WJWebViewController.h"
#import "WJSystemAlertView.h"
#import "WJMyCardPackageModel.h"
#import "WJCardPackageTipVeiw.h"
#import "WJTabBarViewController.h"
#import "WJStatisticsManager.h"
#import "WJVerificationReceiptMoneyController.h"

#define NoCardViewTag 66666

@interface WJCardPackageViewController ()<AVCaptureMetadataOutputObjectsDelegate, WJSystemAlertViewDelegate>
{
    UILabel     *cardTitleLabel;
    UILabel     *balanceMoney;
    UIImageView *cardImageView;
    WJCardPackageTipVeiw * tipView;
    UIButton    *cancelBtn;
}


@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, strong) UIImageView * line;

@property (nonatomic, strong)APICardPackageManager      *cardPackageManager;
@property (nonatomic, strong)NSMutableArray             *dataArray;
@property (nonatomic, strong)WJMyCardPackageModel       *myCardPackageModel;


//@property (nonatomic, strong) APIInfoByCodeManager  * codeManager;

@end

//设备宽/高/坐标
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height
#define KDeviceFrame [UIScreen mainScreen].bounds
#define kCameraWidth      ALD(300)
#define kCameraHeight       kCameraWidth
#define kCameraLeft         (kScreenWidth-ALD(300))/2
#define kCameraTop          ALD(46)+64

static const char *kScanQRCodeQueueName = "ScanQRCodeQueue";

@implementation WJCardPackageViewController
{
    UIImageView *barCodeImage;          //条形码图片
    UIImageView *qrCodeImage;           //二维码图片
    
    //扫描动画
    int num;
    BOOL upOrdown;
    UIImageView * scanQrImage;
    NSTimer * timer;
    
    UIView *payBgView;
    UIView *scanBgView;
    UILabel *barCodeLabel;
    
    //扫一扫，付款码图片，label
    UIImageView * payCodeImageSel;
    UIImageView * payCodeImageNor;
    UIImageView * scanImageViewSel;
    UIImageView * scanImageViewNor;
    UILabel     *payCodeLabel;
    UILabel     *scanLabel;
    
    //旋转frame
    CGRect oldframe;
    CGPoint beginPoint;
    
    //二维码，扫一扫
    UIButton *myPayCodeBtn;
    UIButton *scanCodeBtn;
    UILabel *myAssetsLabel;
    UIButton *rightPayBtn;
    UIButton *rightScanBtn;
    bool isCardShow;
    
    BOOL showCodeFlag;      //flag有密支付密码验证返回后标记已验证
    
    UIView *barCodeBgView;
    
    UIImageView *testView;
    
    //卡包
    UIImageView *firstImageView;
    UIImageView *secondImageView;
    UIImageView *thirdImageView;
    
    UIScrollView *myScrollView;
    
    float           currentPoint;
    UILabel         *myAllMoneyTop;
    UILabel         *myAllMoneyBotton;
    BOOL            cardRequestComplete;
    NSDictionary    *colorDic;
    UIView          *bgWhiteView;
}


- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    [self hiddenBackBarButtonItem];
    showCodeFlag = NO;
    
    cardRequestComplete = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardPackageBagRequest) name:kRefreshCards object:nil];
    
    
    
    colorDic = @{@"0":@"cardpackage_card_gray",
                 @"1":@"cardpackage_card_red",
                 @"2":@"cardpackage_card_oragne",
                 @"3":@"cardpackage_card_blue",
                 @"4":@"cardpackage_card_green"};
    
    self.eventID = @"iOS_vie_CardBag";
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    //初始化scrollView
    [self initTopView];
    [self initScrollView];
    
    //初始化我的付款码视图
    [self initMyPayCodeViews];
    
    //初始化卡包
    [self initCardAnimation];
    
    //初始化tableView
    [self initTableViews];
    
    //初始化扫描二维码视图
    [self initScanQrCodeViews];
    
    //开启二维码
    [self beginingScanCode];
    
    //付款码请求
}

- (void)initTopView{
    //    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, TopDem(20), kScreenWidth, TopDem(44))];
    //    topView.backgroundColor = WJColorViewBg;
    //    [self.view addSubview:topView];
    
    //左上角取消按钮
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(ALD(10), ALD(26), ALD(32), ALD(32));
    [self showCloseImageByButton];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    //右上角按钮000
    rightScanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightScanBtn.alpha = 0;
    rightScanBtn.frame = CGRectMake(kScreenWidth-ALD(47), ALD(26), ALD(32), ALD(32));
    [rightScanBtn setImage:[UIImage imageNamed:@"cardpackage_scan_icon"] forState:UIControlStateNormal];
    [rightScanBtn addTarget:self action:@selector(scanCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightScanBtn];
    
    rightPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightPayBtn.alpha = 0;
    rightPayBtn.frame = CGRectMake(rightScanBtn.x-ALD(57), ALD(26), ALD(32), ALD(32));
    [rightPayBtn addTarget:self action:@selector(myPayCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightPayBtn setImage:[UIImage imageNamed:@"cardpackage_pay_icon"] forState:UIControlStateNormal];
    [self.view addSubview:rightPayBtn];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self monitorPayCodeView];
    
    [self requestPayCode];
    
    
    self.navigationController.navigationBarHidden = YES;
    self.tabBarView.hidden = YES;
    
    self.cardPackageManager.firstPageNo = 1;
    
    //卡包请求
    
    [self cardPackageBagRequest];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)monitorPayCodeView
{
    NSString *forceTouchType = [[NSUserDefaults standardUserDefaults] objectForKey:KTap3DTouchIndex];
    if (forceTouchType) {
        if ([forceTouchType intValue] == 2) {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KTap3DTouchIndex];
            showCodeFlag = NO;
            UIViewController *currentVC = [self.navigationController visibleViewController];
            if (![currentVC isKindOfClass:[WJCardPackageViewController class]]) {
                
                [self.navigationController popToRootViewControllerAnimated:NO];
                [self enterPayCodeFromTouch];
            }else{
                [self enterPayCodeFromTouch];
            }
        }
    }else{
        //如果是付款
        if(myPayCodeBtn.selected && !isCardShow){
            
            [self checkView];
        }
    }
}


- (void)enterPayCodeFromTouch
{
    //如果是付款
    if(myPayCodeBtn.selected && !isCardShow){
        [self checkView];
    }else{
        if (myPayCodeBtn.selected) {
            [self cardHideAnimation];
            
        }else if (!isCardShow){
            [self myPayCodeClick:nil];
            
        }else{
            [self cardHideAnimation];
            [self myPayCodeClick:nil];
        }
        
        [self checkView];
    }
}


- (void)checkView
{
    BOOL openNoPsdPay = [[NSUserDefaults standardUserDefaults] boolForKey:KPasswordSwitch];
    
    if (!openNoPsdPay && !showCodeFlag) {
        
        self.navigationController.navigationBarHidden = NO;
        
        WJVerifyPasswordController *verifyVC = [[WJVerifyPasswordController alloc] init];
        verifyVC.from = ComeFromPayCode;
        [WJGlobalVariable sharedInstance].fromController = self;
        [self.navigationController pushViewController:verifyVC animated:NO];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPayCode:) name:@"PayCodeDismiss" object:nil];
        
    }else{
        
        showCodeFlag = NO;
        [self checkAuthentication];
    }
}


- (void)checkAuthentication
{
    WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
    
    if (defaultPerson.authentication == AuthenticationNo) {
        
        NSString *msg = @"为保障您的帐户安全，\n请尽快完成实名认证！";
        
        WJSystemAlertView *alertView = [[WJSystemAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"立即实名" textAlignment:NSTextAlignmentCenter];
        
        [alertView showIn];
        
    }
}


#pragma mark - WJSystemAlertViewDelegate

- (void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 1) {
        
        NSString *record = [[NSUserDefaults standardUserDefaults] valueForKey:@"RealNameReciveMoneyRecord"];
        
        if (!record) {
            
            WJRealNameAuthenticationViewController *realNameAuthenticationVC = [[WJRealNameAuthenticationViewController alloc] init];
            realNameAuthenticationVC.comefrom = ComeFromCardPackageView;
            realNameAuthenticationVC.isjumpOrderConfirmController = NO;
            [WJGlobalVariable sharedInstance].realAuthenfromController = self;
            [self.navigationController pushViewController:realNameAuthenticationVC animated:YES];
            
        } else {
            
            //收款金额验证
            WJVerificationReceiptMoneyController *verificationReceiptMoneyController = [[WJVerificationReceiptMoneyController alloc] init];
            [WJGlobalVariable sharedInstance].realAuthenfromController = self;
            verificationReceiptMoneyController.comefrom = ComeFromCardPackageView;
            verificationReceiptMoneyController.isjumpOrderConfirmController = NO;
            verificationReceiptMoneyController.BankCard = record;
            [self.navigationController pushViewController:verificationReceiptMoneyController animated:YES];
            
        }
        
    }
}


#pragma mark - 开启二维码
- (void)beginingScanCode
{
    //开启扫描二维码
    NSString *errorString = [self createCaptureSetting];
    if (!errorString) {
        ALERT(errorString);
    };
    self.videoPreviewLayer.opacity = 0;
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self
                                           selector:@selector(animation1)
                                           userInfo:nil
                                            repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
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
        //  [self.captureSession startRunning];
    }
    
}

#pragma mark - 初始化scrollView
- (void)initScrollView
{
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ALD(64),self.view.width, ALD(418))];
    myScrollView.tag = 11001;
    myScrollView.contentSize = CGSizeMake(self.view.width * 2, 0);
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.pagingEnabled = YES;
    myScrollView.backgroundColor = [UIColor clearColor];
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    myScrollView.decelerationRate = 0;
    myScrollView.clipsToBounds = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - 初始化底部卡包
- (void)initCardAnimation
{
    //第三个卡片
    thirdImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width-ALD(332))/2, self.view.height-ALD(56), ALD(332), ALD(77))];
    thirdImageView.alpha = 0.4;
    [self.view addSubview:thirdImageView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:thirdImageView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8,8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = thirdImageView.bounds;
    maskLayer.path = maskPath.CGPath;
    thirdImageView.layer.mask = maskLayer;
    
    //第二个卡片
    secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width-ALD(342))/2, self.view.height-ALD(51), ALD(342), ALD(77))];
    secondImageView.alpha = 0.6;
    [self.view addSubview:secondImageView];
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:secondImageView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8,8)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = secondImageView.bounds;
    maskLayer1.path = maskPath1.CGPath;
    secondImageView.layer.mask = maskLayer1;
    
    //第一个卡片
    firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width-ALD(352))/2, self.view.height-ALD(47), ALD(352), ALD(77))];
    firstImageView.userInteractionEnabled = YES;
    
    //设置不同的卡片颜色
    UIImage* stretchableImage3 =[UIImage imageNamed:@"cardpackage_card_blue"];
    stretchableImage3 = [stretchableImage3 resizableImageWithCapInsets:UIEdgeInsetsMake(stretchableImage3.size.height/2, stretchableImage3.size.width/2, stretchableImage3.size.height/2, stretchableImage3.size.width/2) resizingMode:UIImageResizingModeStretch];
    firstImageView.image = stretchableImage3;
    [self.view addSubview:firstImageView];
    thirdImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardShowAnimation)];
    [firstImageView addGestureRecognizer:ges];
    
    //我的总资产
    myAllMoneyBotton = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(-38), _mTb.width, ALD(14))];
    myAllMoneyBotton.backgroundColor = [UIColor clearColor];
    myAllMoneyBotton.font = WJFont12;
    myAllMoneyBotton.textColor = WJColorAlert;
    myAllMoneyBotton.textAlignment = NSTextAlignmentLeft;
    //    [firstImageView addSubview:myAllMoneyBotton];
    
    [self relaodCardPackage];
}


- (void) relaodCardPackage
{
    //如果无卡
    if(self.dataArray.count == 0)
    {
        [self initNoCardViews];
    }
    else
    {
        [self initHaveCardViews];
        
    }
}

#pragma mark - 加载无卡Views
- (void)initNoCardViews
{
    [firstImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //    myAllMoneyBotton.text = @"我的总资产：0.00";
    cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(15), ALD(15), ALD(17), ALD(15))];
    cardImageView.image = [UIImage imageNamed:@"cardpackage_no_card"];
    cardImageView.layer.masksToBounds = YES;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(cardImageView.right+ALD(10), ALD(15), 0.5, cardImageView.height)];
    lineView.backgroundColor = WJColorViewBg;
    
    cardTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineView.right+ALD(10), ALD(15), firstImageView.width-ALD(100), ALD(15))];
    cardTitleLabel.font = WJFont14;
    cardTitleLabel.text = @"我的卡包";
    cardTitleLabel.textColor = [UIColor whiteColor];
    cardTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    [firstImageView addSubview:cardImageView];
    [firstImageView addSubview:lineView];
    [firstImageView addSubview:cardTitleLabel];
    secondImageView.backgroundColor = WJColorCardGray;
    thirdImageView.backgroundColor = WJColorCardGray;
    UIImage* stretchableImage3 =[UIImage imageNamed:@"cardpackage_card_gray"];
    stretchableImage3 = [stretchableImage3 resizableImageWithCapInsets:UIEdgeInsetsMake(stretchableImage3.size.height/2, stretchableImage3.size.width/2, stretchableImage3.size.height/2, stretchableImage3.size.width/2) resizingMode:UIImageResizingModeStretch];
    firstImageView.image = stretchableImage3;
    
    firstImageView.alpha = 1;
    secondImageView.alpha = 0.6;
    thirdImageView.alpha = 0.4;
}

- (NSString *)imageNameByColorType:(NSInteger)colorType
{
    NSString * strKey = [NSString stringWithFormat:@"%ld",(long)colorType];
    return [colorDic objectForKey:strKey];
}


#pragma mark - 加载有卡Views
- (void)initHaveCardViews
{
    
    [firstImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(15), ALD(10), ALD(51), ALD(51))];
    cardImageView.image = [UIImage imageNamed:@""];
    cardImageView.backgroundColor = [UIColor whiteColor];
    cardImageView.alpha = 0.2;
    [cardImageView.layer setCornerRadius:CGRectGetHeight([cardImageView bounds]) / 2];
    cardImageView.layer.masksToBounds = YES;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(cardImageView.right+ALD(15), ALD(12), 0.5, cardImageView.height)];
    lineView.backgroundColor = WJColorViewBg;
    lineView.alpha = 0.5;
    cardTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineView.right+ALD(15), ALD(17), firstImageView.width-ALD(100), 16)];
    cardTitleLabel.font = WJFont14;
    //    cardTitleLabel.text = @"盛世异彩美容美发化妆品店";
    cardTitleLabel.textColor = [UIColor whiteColor];
    cardTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    //卡片余额
    balanceMoney = [[UILabel alloc] initWithFrame:CGRectMake(lineView.right+ALD(15), ALD(47), firstImageView.width-ALD(15), ALD(19))];
    //    balanceMoney.text = @"金额  ￥500.00";
    balanceMoney.font = WJFont17;
    balanceMoney.textColor = [UIColor whiteColor];
    balanceMoney.textAlignment = NSTextAlignmentLeft;
    
    
    
    
    [firstImageView addSubview:cardImageView];
    [firstImageView addSubview:lineView];
    [firstImageView addSubview:cardTitleLabel];
    [firstImageView addSubview:balanceMoney];
    //    [UIView animateWithDuration:.35 animations:^{
    //        secondImageView.alpha = .2;
    //        thirdImageView.alpha = .1;
    //        firstImageView.alpha = .5;
    //    } completion:^(BOOL finished) {
    //        [UIView animateWithDuration:.35 animations:^{
    //        secondImageView.backgroundColor = WJColorCardRed;
    //        thirdImageView.backgroundColor = WJColorCardRed;
    //        UIImage* stretchableImage3 =[UIImage imageNamed:@"cardpackage_card_red"];
    //        stretchableImage3 = [stretchableImage3 resizableImageWithCapInsets:UIEdgeInsetsMake(stretchableImage3.size.height/2, stretchableImage3.size.width/2, stretchableImage3.size.height/2, stretchableImage3.size.width/2) resizingMode:UIImageResizingModeStretch];
    //        firstImageView.image = stretchableImage3;
    //        secondImageView.alpha = .6;
    //        thirdImageView.alpha = .4;
    //        firstImageView.alpha = 1;
    //        }];
    //
    //    }];
    NSInteger colorT;
    if ([self.dataArray count] > 0) {
        WJModelCard * card = [self.dataArray objectAtIndex:0];
        [cardImageView sd_setImageWithURL:[NSURL URLWithString:card.coverURL]];
        cardTitleLabel.text = card.name;
        colorT = card.colorType;
        balanceMoney.text = [NSString stringWithFormat:@"金额： %@",[WJUtilityMethod floatNumberForMoneyFomatter:card.balance]];
    }
    
    if (balanceMoney != nil && balanceMoney.text.length > 2) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:balanceMoney.text];
        [str addAttribute:NSFontAttributeName value:WJFont12 range:NSMakeRange(0,2)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(2,str.length-2)];
        balanceMoney.attributedText = str;
    }
    
    //    [self refreshFooterCardsWithColor: colorT];
    
    [UIView animateWithDuration:.15 animations:^{
        [self refreshFooterCardsWithColor: colorT];
        //
        //        UIImage* stretchableImage3 =[UIImage imageNamed:[self imageNameByColorType:colorT]];
        //        stretchableImage3 = [stretchableImage3 resizableImageWithCapInsets:UIEdgeInsetsMake(stretchableImage3.size.height/2, stretchableImage3.size.width/2, stretchableImage3.size.height/2, stretchableImage3.size.width/2) resizingMode:UIImageResizingModeStretch];
        //        firstImageView.image = stretchableImage3;
        //        secondImageView.alpha = .6;
        
    }];
    //    firstImageView.alpha = 0;
    //    secondImageView.alpha = 0;
    //    thirdImageView.alpha = 0;
}

- (void)refreshFooterCardsWithColor:(NSInteger )colorType
{
    
    UIColor * color = [self colorWithColorType:colorType];
    
    
    //    firstImageView.backgroundColor = color;
    secondImageView.backgroundColor = color;
    thirdImageView.backgroundColor = color;
    
    UIImage* stretchableImage3 =[UIImage imageNamed:[self imageNameByColorType:colorType]];
    stretchableImage3 = [stretchableImage3 resizableImageWithCapInsets:UIEdgeInsetsMake(stretchableImage3.size.height/2, stretchableImage3.size.width/2, stretchableImage3.size.height/2, stretchableImage3.size.width/2) resizingMode:UIImageResizingModeStretch];
    firstImageView.image = stretchableImage3;
    
    
}





- (UIColor *)colorWithColorType:(NSUInteger)colorType
{
    switch (colorType) {
            
        case 1:
        {
            return WJColorCardRed;
        }
            break;
        case 2:
        {
            return WJColorCardOrange;
        }
            break;
        case 3:
        {
            return WJColorCardBlue;
        }
            break;
        case 4:
        {
            return WJColorCardGreen;
        }
            break;
        default:
            return WJColorCardGray;
            break;
    }
    
}
#pragma mark - 点击卡片展开事件
- (void)cardShowAnimation
{
    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_MycardBag"];
    [[_mTb viewWithTag:NoCardViewTag] removeFromSuperview];
    
    if(self.dataArray.count <= 0)
    {
        [self initNoCardTableViewImage];
    }
    
    myScrollView.userInteractionEnabled = NO;
    //卡片滑动最大滑动距离
    float movePoint = 50;
    [UIView animateWithDuration:.5 animations:^{
        
        _mTb.frame = CGRectMake(0, TopDem(54), kScreenWidth, kScreenHeight-TopDem(54));
        _mTb.alpha = 0.2;
        myPayCodeBtn.alpha = 0;
        scanCodeBtn.alpha = 0;
        myAssetsLabel.alpha = 0;
        rightPayBtn.alpha = 1;
        rightScanBtn.alpha = 1;
        myScrollView.alpha = 0;
        firstImageView.alpha = 0;
        secondImageView.alpha = 0;
        thirdImageView.alpha = 0;
        firstImageView.frame = CGRectMake((self.view.width-ALD(352))/2, self.view.height-ALD(47)-movePoint/1.8, ALD(352), ALD(77));
        secondImageView.frame = CGRectMake((self.view.width-ALD(342))/2, self.view.height-ALD(51)-movePoint/1.4, ALD(342), ALD(77));
        thirdImageView.frame = CGRectMake((self.view.width-ALD(332))/2, self.view.height-ALD(56)-movePoint, ALD(332), ALD(77));
        
        self.videoPreviewLayer.opacity = 0;
    } completion:^(BOOL finished) {
        isCardShow = YES;
        _mTb.alpha = 1;
        //如果网络卡包请求未完成，显示请求
        [self showBackImageByButton];
        if(!cardRequestComplete)
        {
            [self showLoadingView];
        }
    }];
}

#pragma mark - 隐藏卡片动画
- (void)cardHideAnimation
{
    if(!cardRequestComplete)
    {
        [self hiddenLoadingView];
    }
    myScrollView.userInteractionEnabled = YES;
    [UIView animateWithDuration:.5 animations:^{
        _mTb.frame = CGRectMake(0, kScreenHeight-ALD(56)-64, kScreenWidth, kScreenHeight-ALD(64));
        //        payBgView.alpha = 1;
        //        scanBgView.alpha = 0.4;
        myPayCodeBtn.alpha = 1;
        scanCodeBtn.alpha = 1;
        myAssetsLabel.alpha = 1;
        rightScanBtn.alpha = 0;
        rightPayBtn.alpha = 0;
        //        qrCodeImage.alpha = 1;
        //        testView.alpha = 1;
        _mTb.alpha = 0;
        myScrollView.alpha = 1;
        firstImageView.alpha = 1;
        secondImageView.alpha = 0.6;
        thirdImageView.alpha = 0.4;
        firstImageView.frame = CGRectMake((self.view.width-ALD(352))/2, self.view.height-ALD(47), ALD(352), ALD(77));
        secondImageView.frame = CGRectMake((self.view.width-ALD(342))/2, self.view.height-ALD(51), ALD(342), ALD(77));
        thirdImageView.frame = CGRectMake((self.view.width-ALD(332))/2, self.view.height-ALD(56), ALD(332), ALD(77));
        
        if(myPayCodeBtn.selected)
        {
            self.videoPreviewLayer.opacity = 0;
            
        }
        else
        {
            self.videoPreviewLayer.opacity = 1;
            
        }
    } completion:^(BOOL finished) {
        isCardShow = NO;
        
        if (myScrollView.contentOffset.x == 0) {
            [self showCloseImageByButton];
        } else {
            [self showWhiteCloseImageByButton];
        }
        
    }];
}

#pragma mark - 初始化tableView
- (void)initTableViews
{
    _mTb = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenHeight-TopDem(56), kScreenWidth, kScreenHeight-TopDem(64)) style:UITableViewStylePlain];
    _mTb.delegate = self;
    _mTb.dataSource = self;
    _mTb.tag = 11002;
    _mTb.tableFooterView = [UIView new];
    _mTb.backgroundColor = [UIColor clearColor];
    _mTb.separatorInset = UIEdgeInsetsZero;
    //    _mTb.tableHeaderView = [self tableViewHeadView];
    _mTb.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTb.alpha = 0;
    isCardShow = NO;
    [self.view addSubview:_mTb];
    
    
    tipView = [[WJCardPackageTipVeiw alloc]initWithFrame:CGRectMake(0, TopDem(64), kScreenWidth, kScreenHeight-TopDem(64))];
    [tipView.reloadRequestBtn addTarget:self action:@selector(cardPackageBagRequest) forControlEvents:UIControlEventTouchUpInside];
    tipView.backgroundColor = [UIColor whiteColor];
    tipView.hidden = YES;
    
    [self.view addSubview:tipView];
    
}

-(void)showCloseImageByButton
{
    [cancelBtn setImage:[UIImage imageNamed:@"cardpackage_close"] forState:UIControlStateNormal];
}

-(void)showWhiteCloseImageByButton
{
    [cancelBtn setImage:[UIImage imageNamed:@"cardpackage_close_white"] forState:UIControlStateNormal];
}

-(void)showBackImageByButton
{
    [cancelBtn setImage:[UIImage imageNamed:@"nav_btn_back_nor_gray"] forState:UIControlStateNormal];
}

-(void)showCardPakagePayImage
{
    payCodeImageNor.image = [UIImage imageNamed:@"cardpackage_pay_icon"];
    payCodeLabel.textColor = kBlueColor;
}

-(void)showWhiteCardPakagePayImage
{
    [payCodeImageNor setImage:[UIImage imageNamed:@"cardpackage_pay_icon_white"]];
    payCodeLabel.textColor = [UIColor whiteColor];
}

#pragma mark - 用户无卡tableView默认图
- (void)initNoCardTableViewImage
{
    UIView *noCardView = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(44), _mTb.width, _mTb.height)];
    noCardView.backgroundColor = WJColorViewBg;
    noCardView.tag = NoCardViewTag;
    [_mTb addSubview:noCardView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((_mTb.width - ALD(100))/2, ALD(106), ALD(100), ALD(100))];
    imageView.image = [UIImage imageNamed:@"mycards_recharge_nodata"];
    [noCardView addSubview:imageView];
    
    UILabel *noCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom+ALD(20), noCardView.width, ALD(16))];
    noCardLabel.text = @"您的卡包空空如也";
    noCardLabel.font = WJFont15;
    noCardLabel.textColor = WJColorNavigationBar;
    noCardLabel.textAlignment = NSTextAlignmentCenter;
    [noCardView addSubview:noCardLabel];
    
    UILabel *noCardSubLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, noCardLabel.bottom+ALD(15), noCardView.width, ALD(16))];
    noCardSubLabel.text = @"赶快行动去丰富你的卡包吧~";
    noCardSubLabel.font = WJFont12;
    noCardSubLabel.textColor = WJColorLightGray;
    noCardSubLabel.textAlignment = NSTextAlignmentCenter;
    [noCardView addSubview:noCardSubLabel];
    
}

#pragma mark - UITableView delegate & datasouce
- (UIView *)tableViewHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _mTb.width, ALD(44))];
    headView.backgroundColor = [UIColor clearColor];
    //我的总资产
    myAllMoneyTop = [[UILabel alloc] initWithFrame:CGRectMake(10, ALD(10), _mTb.width-20, ALD(24))];
    myAllMoneyTop.backgroundColor = [UIColor clearColor];
    myAllMoneyTop.font = WJFont20;
    myAllMoneyTop.textColor = WJColorDarkGray;
    myAllMoneyTop.textAlignment = NSTextAlignmentLeft;
    //    [headView addSubview:myAllMoneyTop];
    
    if (myAllMoneyTop.text.length > 2) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:myAllMoneyTop.text];
        [str addAttribute:NSFontAttributeName value:WJFont12 range:NSMakeRange(0,6)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(6,str.length-6)];
        myAllMoneyTop.attributedText = str;
    }
    
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cardPackageList";
    
    WJCardsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell)
    {
        cell = [[WJCardsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if([self.dataArray count] > indexPath.section)
    {
        [cell refreshCellByCard:self.dataArray[indexPath.section]];
    }
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;//section == 0 ? 0 : 10;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor clearColor];
    return  headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(77);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([self.dataArray count] > indexPath.section)
    {
        [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_Card"];
        WJCardsDetailViewController *detailVC = [[WJCardsDetailViewController alloc] init];
        detailVC.card = self.dataArray[indexPath.section];
        [self.navigationController pushViewController:detailVC animated:YES whetherJump:NO];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 初始化我的付款码界面
- (void)initMyPayCodeViews
{
    //灰色背景
    payBgView = [[UIView alloc] initWithFrame:CGRectMake((self.view.width-ALD(351))/2,ALD(13),ALD(351),ALD(395))];
    payBgView.backgroundColor = WJColorViewBg;
    payBgView.layer.cornerRadius = 8;
    
    [myScrollView addSubview:payBgView];
    payBgView.layer.shadowOpacity = 0.2;
    payBgView.layer.shadowOffset = CGSizeMake(0.1, 1);
    payBgView.layer.shadowRadius = 2;
    
    //4,3,0.2,(1,1)
    //白色背景
    UIView *whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0,0,payBgView.width,ALD(351))];
    whiteBgView.backgroundColor = [UIColor whiteColor];
    
    [payBgView addSubview:whiteBgView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:whiteBgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8,8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = whiteBgView.bounds;
    maskLayer.path = maskPath.CGPath;
    whiteBgView.layer.mask = maskLayer;
    
    //刷新二维码图片
    UIImageView *refImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(133.5), whiteBgView.bottom+ALD(15),ALD(13), ALD(12))];
    refImageView.image = [UIImage imageNamed:@"cardpackage_btn_refresh"];
    [payBgView addSubview:refImageView];
    
    //刷新付款码按钮
    UIButton *refPayCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refPayCodeBtn.frame = CGRectMake(refImageView.right+ALD(5),whiteBgView.bottom+ALD(13), ALD(90), ALD(16));
    [refPayCodeBtn setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
    [refPayCodeBtn setTitle:@"刷新付款码" forState:UIControlStateNormal];
    refPayCodeBtn.titleLabel.font = WJFont14;
    refPayCodeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [refPayCodeBtn addTarget:self action:@selector(refreshPayCodeClick) forControlEvents:UIControlEventTouchUpInside];
    [payBgView addSubview:refPayCodeBtn];
    
    //我的付款码按钮
    myPayCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myPayCodeBtn.selected = YES;
    myPayCodeBtn.frame = CGRectMake(ALD(116), myScrollView.bottom-ALD(10)+ALD(30), ALD(29), ALD(50));
    [myPayCodeBtn addTarget:self action:@selector(myPayCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myPayCodeBtn];
    
    payCodeImageSel= [[UIImageView alloc] initWithFrame:CGRectMake(0,0, myPayCodeBtn.width, ALD(28))];
    payCodeImageSel.image =[UIImage imageNamed:@"cardpackage_pay_sel"];
    payCodeImageSel.hidden = NO;
    [myPayCodeBtn addSubview:payCodeImageSel];
    
    payCodeImageNor= [[UIImageView alloc] initWithFrame:CGRectMake(0,0, myPayCodeBtn.width, ALD(28))];
    payCodeImageNor.image =[UIImage imageNamed:@"cardpackage_pay_normal"];
    payCodeImageNor.hidden = YES;
    [myPayCodeBtn addSubview:payCodeImageNor];
    
    payCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(-3.5, payCodeImageSel.bottom+ALD(10), myPayCodeBtn.width+7, ALD(12))];
    payCodeLabel.text = @"付款码";
    payCodeLabel.font = WJFont10;
    payCodeLabel.textColor = WJColorNavigationBar;
    payCodeLabel.textAlignment = NSTextAlignmentCenter;
    [myPayCodeBtn addSubview:payCodeLabel];
    
    //扫一扫按钮
    scanCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scanCodeBtn.selected = NO;
    scanCodeBtn.frame = CGRectMake(kScreenWidth-ALD(116)-ALD(29), myScrollView.bottom-ALD(10)+ALD(30), ALD(29), ALD(50));
    [scanCodeBtn addTarget:self action:@selector(scanCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanCodeBtn];
    
    scanImageViewSel= [[UIImageView alloc] initWithFrame:CGRectMake(0,0, scanCodeBtn.width, ALD(28))];
    scanImageViewSel.hidden = YES;
    scanImageViewSel.image = [UIImage imageNamed:@"cardpackage_scan_sel"];
    [scanCodeBtn addSubview:scanImageViewSel];
    
    scanImageViewNor= [[UIImageView alloc] initWithFrame:CGRectMake(0,0, scanCodeBtn.width, ALD(28))];
    scanImageViewNor.hidden = NO;
    scanImageViewNor.image = [UIImage imageNamed:@"cardpackage_scan_normal"];
    [scanCodeBtn addSubview:scanImageViewNor];
    
    scanLabel = [[UILabel alloc] initWithFrame:CGRectMake(-3.5, scanImageViewNor.bottom+ALD(10), scanCodeBtn.width+7, ALD(12))];
    scanLabel.text = @"扫一扫";
    scanLabel.textColor = WJColorLightGray;
    scanLabel.font = WJFont10;
    scanLabel.textAlignment = NSTextAlignmentCenter;
    [scanCodeBtn addSubview:scanLabel];
    
    //放大动画白色背景
    barCodeBgView = [[UIView alloc] initWithFrame:CGRectMake(-(self.view.width-ALD(347))/2, ALD(77), self.view.width, self.view.height+ALD(13))];
    barCodeBgView.backgroundColor = [UIColor whiteColor];
    barCodeBgView.tag = 10001;
    barCodeBgView.alpha = 0;
    barCodeBgView.userInteractionEnabled = YES;
    [payBgView addSubview:barCodeBgView];
    
    testView = [[UIImageView alloc] initWithFrame:CGRectMake((payBgView.width-ALD(267.5))/2, ALD(30), ALD(267.5), ALD(72+16))];
    testView.userInteractionEnabled = YES;
    testView.tag = 10001;
    [payBgView addSubview:testView];
    UITapGestureRecognizer *barCodeGes  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
    [testView addGestureRecognizer:barCodeGes];
    
    //条形码
    barCodeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, ALD(267.5), ALD(62))];
    [testView addSubview:barCodeImage];
    barCodeImage.tag = 10001;
    
    //条形码数字
    barCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,barCodeImage.bottom+ALD(10), ALD(267.5), ALD(16))];
    barCodeLabel.font = WJFont14;
    barCodeLabel.textAlignment =  NSTextAlignmentCenter;
    [testView addSubview:barCodeLabel];
    barCodeImage.userInteractionEnabled = YES;
    
    //二维码
    qrCodeImage = [[UIImageView alloc] initWithFrame:CGRectMake((payBgView.width-ALD(170.5))/2, testView.bottom+ALD(34), ALD(170.5), ALD(168))];
    qrCodeImage.userInteractionEnabled = YES;
    qrCodeImage.tag = 10002;
    [payBgView addSubview:qrCodeImage];
    
    UITapGestureRecognizer *ges  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
    [qrCodeImage addGestureRecognizer:ges];
    
}

#pragma mark - 二维码条形码放大事件
-(void)magnifyImage:(UITapGestureRecognizer *)gesture
{
    [self showImage:(UIImageView *)[gesture view]];//调用方法
}

#pragma mark -  初始化扫描二维码界面View
- (void)initScanQrCodeViews
{
    //扫一扫灰色背景
    scanBgView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width + ALD(15),ALD(13),kScreenWidth-ALD(15)*2,ALD(395))];
    scanBgView.backgroundColor = [UIColor blackColor];
    scanBgView.alpha = 0.4;
    scanBgView.hidden = NO;
    scanBgView.layer.cornerRadius = 8;
    [myScrollView addSubview:scanBgView];
    scanBgView.layer.shadowOpacity = 0.2;
    scanBgView.layer.shadowOffset = CGSizeMake(0.1, 1);
    scanBgView.layer.shadowRadius = 2;
    
    //二维码边框
    scanQrImage = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(26), ALD(46),scanBgView.width-ALD(26)*2, scanBgView.width-ALD(26)*2)];
    scanQrImage.image = [UIImage imageNamed:@"cardpackage_qr_border"];
    scanQrImage.hidden = NO;
    UIView * borderView = [[UIView alloc] initWithFrame:CGRectMake(ALD(30), ALD(50),scanBgView.width-ALD(30)*2, scanBgView.width-ALD(30)*2)];
    borderView.layer.borderColor = [[UIColor whiteColor] CGColor];
    borderView.layer.borderWidth = 1;
    borderView.backgroundColor = [UIColor clearColor];
    [scanBgView addSubview:scanQrImage];
    [scanBgView addSubview:borderView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(50), 0, kCameraWidth, ALD(2))];
    _line.hidden = NO;
    _line.image = [UIImage imageNamed:@"cardpackage_qr_line"];
    [scanQrImage addSubview:_line];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasGoneInForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasGoneBcakground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

#pragma mark - app成为活跃状态
- (void)appHasGoneInForeground
{
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
        if(myPayCodeBtn.selected)
            self.videoPreviewLayer.opacity = 0;
        else
            self.videoPreviewLayer.opacity = 1;
        
    }
    
}

#pragma mark - app进入后台
- (void)appHasGoneBcakground
{
    //  [self.captureSession stopRunning];
}

//
//#pragma mark -  我的卡事件
//- (void)myCardClick:(id)sender
//{
//    _mTb.alpha = 0.1;
//    [UIView animateWithDuration:.5 animations:^{
//
//        _mTb.frame = CGRectMake(ALD(15), 64, kScreenWidth-ALD(30), ALD(400));
//        _mTb.alpha = 0.2;
//        myPayCodeBtn.alpha = 0;
//        scanCodeBtn.alpha = 0;
//        myAssetsLabel.alpha = 0;
//        rightScanBtn.alpha = 1;
//        rightPayBtn.alpha = 1;
//        myScrollView.alpha = 0;
//    } completion:^(BOOL finished) {
//        isCardShow = YES;
//        _mTb.alpha = 1;
//    }];
//}

#pragma mark - 我的付款码event
- (void)myPayCodeClick:(id)sender
{
    [self scanCodeToMyPayCode];
    
    [UIView animateWithDuration:.35 animations:^{
        myScrollView.contentOffset=CGPointMake(0, 0);
        
        payBgView.alpha =1;
        self.videoPreviewLayer.opacity = 0;
    }];
}

#pragma mark - 扫码event
- (void)scanCodeClick:(id)sender
{
    [self myPayCodeToScanCode];
    [UIView animateWithDuration:.35 animations:^{
        myScrollView.contentOffset=CGPointMake(self.view.width, 0);
        payBgView.alpha =0;
        self.videoPreviewLayer.opacity =1;
    }];
}

#pragma mark - 扫描二维码到付款码切换

- (void)scanCodeToMyPayCode
{
    if(isCardShow)
    {
        [self cardHideAnimation];
    }
    if(myPayCodeBtn.selected)
    {
        return;
    }
    
    [self showCardPakagePayImage];
    [self showCloseImageByButton];
    
    scanCodeBtn.selected = !scanCodeBtn.selected;
    myPayCodeBtn.selected = !myPayCodeBtn.selected;
    payCodeImageSel.hidden = NO;
    payCodeImageNor.hidden = YES;
    scanImageViewSel.hidden = YES;
    scanImageViewNor.hidden = NO;
    payCodeLabel.textColor = WJColorNavigationBar;
    scanLabel.textColor = WJColorLightGray;
}


#pragma mark - 付款码到扫描二维码切换
- (void)myPayCodeToScanCode
{
    if(isCardShow)
    {
        [self cardHideAnimation];
    }
    if(scanCodeBtn.selected)
    {
        return;
    }
    
    [self showWhiteCardPakagePayImage];
    [self showWhiteCloseImageByButton];
    
    scanCodeBtn.selected = !scanCodeBtn.selected;
    myPayCodeBtn.selected = !myPayCodeBtn.selected;
    payCodeImageSel.hidden = YES;
    payCodeImageNor.hidden = NO;
    scanImageViewSel.hidden = NO;
    scanImageViewNor.hidden = YES;
    scanLabel.textColor = WJColorNavigationBar;
}

#pragma mark - 扫描设置

- (NSString *)createCaptureSetting {
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
    [captureMetadataOutput setRectOfInterest:[self getReaderViewBoundsWithSize:CGSizeMake(kCameraWidth , kCameraWidth)]];
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
    
    [self.captureSession startRunning];
    
    return nil;
}

- (void)addAlphaViewWithAlpha:(float) alpha
{
    [self.view addSubview:[self createViewWithFrame:CGRectMake(0, 0, kScreenWidth, kCameraTop) alpha:alpha]];
    [self.view addSubview:[self createViewWithFrame:CGRectMake(0, kCameraTop, kCameraLeft, kCameraHeight) alpha:alpha]];
    [self.view addSubview:[self createViewWithFrame:CGRectMake(kCameraLeft + kCameraWidth, kCameraTop, kScreenWidth - (kCameraWidth + kCameraLeft), kCameraHeight) alpha:alpha]];
    [self.view addSubview:[self createViewWithFrame:CGRectMake(0, kCameraHeight + kCameraTop, kScreenWidth, kScreenHeight - (kCameraTop + kCameraHeight)) alpha:alpha]];
}

- (CGRect)getReaderViewBoundsWithSize:(CGSize)asize
{
    return CGRectMake((kCameraTop) / KDeviceHeight, ((kDeviceWidth - asize.width) / 2.0) / kDeviceWidth, asize.height / KDeviceHeight, asize.width / kDeviceWidth);
    
}

- (UIView *)createViewWithFrame:(CGRect)frame  alpha:(float)alpha
{
    UIView * aView = [[UIView alloc] initWithFrame:frame];
    aView.userInteractionEnabled = NO;
    aView.backgroundColor = [UIColor blackColor];
    aView.alpha = alpha;
    
    return nil;
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        
        [self performSelectorOnMainThread:@selector(reportScanResult:)
                               withObject:[[metadataObjects firstObject] stringValue]
                            waitUntilDone:NO];
        
    }
}

- (void)reportScanResult:(NSString *)code{
    
}

#pragma mark - 二维码动画
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(ALD(6), ALD(0) + 2*num,kScreenWidth - ALD(100), 2);
        if (2*num > kCameraWidth-ALD(5)) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(ALD(6), ALD(0) + 2*num, kScreenWidth - ALD(100), 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

#pragma mark - 左上角删除按钮

- (void)showPayCode:(NSNotification *)notice
{
    if ([notice userInfo]) {
        showCodeFlag = YES;
    }else{
        
        [self cancelClick];
    }
}


- (void)cancelClick
{
    if (isCardShow)
    {
        [self cardHideAnimation];
    } else {
        showCodeFlag = NO;
        self.tabBarView.hidden = NO;
        
        [self myPayCodeClick:nil];
        
        //        WJTabBarViewController *tab = (WJTabBarViewController *)self.tabBarController;
        //        if([WJGlobalVariable sharedInstance].tabBarIndex != 2){
        //            [tab changeTabIndex:[WJGlobalVariable sharedInstance].tabBarIndex];
        //        }else{
        //
        //            [tab changeTabIndex:0];
        //        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

#pragma mark - 刷新付款码
- (void)refreshPayCodeClick
{
    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_QRRefresh"];
    //刷新二维码
    [self requestPayCode];
}

#pragma mark - 付款码放大动画
-(void)showImage:(UIImageView *)avatarImageView {
    UITapGestureRecognizer
    *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    
    cancelBtn.hidden = YES;
    
    [barCodeBgView  addGestureRecognizer: tap];
    barCodeBgView.tag = avatarImageView.tag;
    
    if(avatarImageView.tag == 10001)
    {
        //[UIView animateWithDuration:.35 animations:^{
        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:7 initialSpringVelocity:4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            qrCodeImage.alpha = 0;
            myAssetsLabel.alpha = 0;
            barCodeBgView.alpha = 1;
            firstImageView.alpha = 0;
            secondImageView.alpha = 0;
            thirdImageView.alpha = 0;
            myPayCodeBtn.alpha = 0;
            scanCodeBtn.alpha = 0;
            testView.transform = CGAffineTransformRotate(testView.transform, M_PI_2);
            testView.frame = CGRectMake(ALD(112), ALD(110-64), ALD(150), ALD(447));
            barCodeImage.frame = CGRectMake(0, 0, ALD(447), ALD(102));
            barCodeLabel.frame = CGRectMake(ALD(47), ALD(142), ALD(447)-ALD(80), ALD(18));
            barCodeLabel.transform = CGAffineTransformMake(1.1, 0, 0, 1.1, 0, 0);
            
            barCodeLabel.font = WJFont16;
            // testView.transform =  CGAffineTransformMake(2, 0, 0, 2, 0, 0);
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:barCodeLabel.text attributes:@{NSKernAttributeName : @(4.5f)}];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, barCodeLabel.text.length)];
            barCodeLabel.attributedText = attributedString;
            barCodeLabel.textAlignment = NSTextAlignmentCenter;
            
            payBgView.layer.shadowOpacity = 0;
            
            self.view.backgroundColor = [UIColor whiteColor];
            
        } completion:^(BOOL finished) {
            scanQrImage.hidden = YES;
            UITapGestureRecognizer
            *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
            [testView
             addGestureRecognizer: tap];
        }];
        
    }
    else
    {
        [UIView animateWithDuration:.35 animations:^{
            testView.alpha = 0;
            myAssetsLabel.alpha = 0;
            barCodeBgView.alpha = 1;
            firstImageView.alpha = 0;
            secondImageView.alpha = 0;
            thirdImageView.alpha = 0;
            myPayCodeBtn.alpha = 0;
            scanCodeBtn.alpha = 0;
            payBgView.layer.shadowOpacity = 0;
            
            self.view.backgroundColor = [UIColor whiteColor];
            avatarImageView.frame = CGRectMake((payBgView.width-ALD(243))/2, ALD(212-64), ALD(243), ALD(243));;
            
        } completion:^(BOOL finished) {
            UITapGestureRecognizer
            *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
            [avatarImageView
             addGestureRecognizer: tap];
        }];
    }
}

#pragma mark - 付款码隐藏动画
-(void)hideImage:(UITapGestureRecognizer*)tap {
    cancelBtn.hidden = NO;
    if(barCodeBgView.tag == 10001)
    {
        //  [UIView animateWithDuration:.35 animations:^{
        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:7 initialSpringVelocity:4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            firstImageView.alpha = 1;
            secondImageView.alpha = 0.6;
            thirdImageView.alpha = 0.4;
            myAssetsLabel.alpha = 1;
            qrCodeImage.alpha = 1;
            barCodeBgView.alpha = 0;
            myPayCodeBtn.alpha = 1;
            scanCodeBtn.alpha = 1;
            testView.transform = CGAffineTransformRotate(testView.transform, -M_PI_2);
            testView.frame = CGRectMake((payBgView.width-ALD(267.5))/2, ALD(30), ALD(267.5), ALD(72+16));
            barCodeImage.frame = CGRectMake(0,0, ALD(267.5), ALD(60));
            barCodeLabel.frame = CGRectMake(ALD(0), ALD(72), ALD(267.5), ALD(16));
            barCodeLabel.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
            
            barCodeLabel.font = WJFont14;
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:barCodeLabel.text attributes:@{NSKernAttributeName : @(2.0f)}];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, barCodeLabel.text.length)];
            barCodeLabel.attributedText = attributedString;
            barCodeLabel.textAlignment = NSTextAlignmentCenter;
            payBgView.layer.shadowOpacity = 0.2;
            self.view.backgroundColor = WJColorViewBg;
        } completion:^(BOOL finished) {
            scanQrImage.hidden = NO;
            [barCodeBgView removeGestureRecognizer:tap];
            UITapGestureRecognizer *barCodeGes  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
            [testView addGestureRecognizer:barCodeGes];
        }];
    }
    else
    {
        [UIView animateWithDuration:.35 animations:^{
            firstImageView.alpha = 1;
            secondImageView.alpha = 0.6;
            thirdImageView.alpha = 0.4;
            myAssetsLabel.alpha = 1;
            testView.alpha = 1;
            barCodeBgView.alpha = 0;
            myPayCodeBtn.alpha = 1;
            scanCodeBtn.alpha = 1;
            payBgView.layer.shadowOpacity = 0.2;
            self.view.backgroundColor = WJColorViewBg;
            qrCodeImage.frame = CGRectMake((payBgView.width-ALD(170.5))/2, testView.bottom+ALD(34), ALD(170.5), ALD(168));
            
        } completion:^(BOOL finished) {
            [barCodeBgView removeGestureRecognizer:tap];
            UITapGestureRecognizer *barCodeGes  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
            [qrCodeImage addGestureRecognizer:barCodeGes];
        }];
        
    }
}

#pragma mark - Request

- (void)requestPayCode{
    
    
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
    
    if (person.token.length == 32 && person.payPassword.length > 18) {
        
        NSString *key = [person.token stringByAppendingString:person.payPassword];
        
        NSTimeInterval serverTimeSubLocal = [[[NSUserDefaults standardUserDefaults] objectForKey:kServerTimeSubLocal] doubleValue];
        
        int time = [[NSDate date] timeIntervalSince1970] + serverTimeSubLocal;
        
        NSString *qrToken = [SM3Generation getTokenWithSM3TOTP:time tokenChangeDuring:5 priKey:[key substringWithRange:NSMakeRange(18, 32)] tokenLength:6];
        
        NSString *qrString = [NSString stringWithFormat:@"86%@%@", [person.phone substringFromIndex:1], qrToken];
        
        [self generatedQR:qrString];
    }else{
        if (person.payPassword.length<=18) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"错误18，请重新设置支付密码"];
        }else {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"错误32，请重新登录"];
        }
    }
}

#pragma mark - Logic

- (void)generatedQR:(NSString *)qrCode{
    
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:qrCode
                                  format:kBarcodeFormatCode128
                                   width:300
                                  height:70
                                   error:&error];
    if (result) {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        barCodeImage.image = [UIImage imageWithCGImage:image];
    }
    
    barCodeLabel.text = [qrCode macCodeFormaterWithString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:barCodeLabel.text attributes:@{NSKernAttributeName : @(2.0f)}];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, barCodeLabel.text.length)];
    barCodeLabel.attributedText = attributedString;
    barCodeLabel.textAlignment = NSTextAlignmentCenter;
    qrCodeImage.image = [CreatQRCodeAndBarCodeFromLeon qrImageWithString:qrCode size:qrCodeImage.size color:WJColorBlack backGroundColor:WJColorWhite correctionLevel:ErrorCorrectionLevelMedium];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    beginPoint = [[touches anyObject] locationInView:self.view];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint movePoint = [[touches anyObject] locationInView:self.view];
    //向上滑&&开始滑动点在指定区域
    if( beginPoint.y-movePoint.y>5 && !isCardShow && beginPoint.y < kScreenHeight&&beginPoint.y>kScreenHeight-60)
    {
        isCardShow = !isCardShow;
        [self cardShowAnimation];
    }
}


#pragma mark- Event Response
// TODO:所有 button、gestureRecognizer、notification 的事件相应方法，与跳转到其他 controller 的出口方法都写在这里。
- (void)cardPackageBagRequest
{
    [self showLoadingView];
    
    self.cardPackageManager.shouldCleanData = YES;
    [self.dataArray removeAllObjects];
    [self.cardPackageManager loadData];
}

#pragma mark- Getter and Setter
// TODO:所有属性的初始化，都写在这
- (APICardPackageManager *)cardPackageManager
{
    if (nil == _cardPackageManager) {
        _cardPackageManager = [[APICardPackageManager alloc] init];
        //        _cardPackageManager.shouldParse = YES;
        _cardPackageManager.delegate = self;
        //        _cardPackageManager.pageCount = 10;
        _cardPackageManager.firstPageNo = 1;
        
    }
    return _cardPackageManager;
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[self.cardPackageManager class]]) {
        
        tipView.hidden = YES;
        NSDictionary * dic = [manager fetchDataWithReformer:nil];
        self.myCardPackageModel = [[WJMyCardPackageModel alloc] initWithDic:dic];
        
        [self.dataArray addObjectsFromArray:self.myCardPackageModel.cardListArray];
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            WJDBCardManager *cardM = [[WJDBCardManager alloc] initWithOwnedUserId:[WJGlobalVariable sharedInstance].defaultPerson.userID];
            
            [cardM removeCards];
            if (weakSelf.dataArray.count > 0) {
                [cardM insertCards:weakSelf.dataArray];
            }
        });
        
        if ([self.dataArray count] > 0) {
            [[_mTb viewWithTag:NoCardViewTag] removeFromSuperview];
            
            WJModelCard * card = [self.dataArray objectAtIndex:0];
            [cardImageView sd_setImageWithURL:[NSURL URLWithString:card.coverURL]];
            cardTitleLabel.text = card.name;
            [self refreshFooterCardsWithColor:card.colorType];
            balanceMoney.text = [NSString stringWithFormat:@"金额： %@",[WJUtilityMethod floatNumberForMoneyFomatter:card.balance]];
        }
        
        cardRequestComplete = YES;
        
        [self hiddenLoadingView];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self relaodCardPackage];
            [self.mTb reloadData];
            myAllMoneyTop.text = [NSString stringWithFormat:@"我的总资产：%@",[WJUtilityMethod floatNumberForMoneyFomatter:self.myCardPackageModel.totalAssets]];
        });
        
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APICardPackageManager class]] ){
        
        tipView.hidden = NO;
        //  cardRequestComplete = YES;
        [self hiddenLoadingView];
        if (manager.errorType == APIManagerErrorTypeNoData) {
            if (self.cardPackageManager.shouldCleanData) {
                [self.dataArray removeAllObjects];
            }
        }else if(self.dataArray.count == 0){
            WJDBCardManager *cardM = [[WJDBCardManager alloc] initWithOwnedUserId:[WJGlobalVariable sharedInstance].defaultPerson.userID];
            // self.eventID = @"iOS_act_cardbag";
            
            [self.dataArray addObjectsFromArray:[cardM getCards]];
        }else{
            ALERT(@"请求失败");
        }
    }
}

#pragma mark - 释放通知
- (void) dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kRefreshCards
                                                  object:nil];
    
}


#pragma mark -scrollView滑动代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    currentPoint = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y<-30 && scrollView.tag == 11002)
    {
        [self cardHideAnimation];
    }
    if(scrollView.tag == 11001)
    {
        if(scrollView.contentOffset.x>currentPoint)
        {
            if(scrollView.contentOffset.x>0)
            {
                payBgView.alpha =1-scrollView.contentOffset.x/(self.view.width-100);
                self.videoPreviewLayer.opacity =scrollView.contentOffset.x/(self.view.width-100);
            }
            
        }
        else
        {
            if(scrollView.contentOffset.x>0)
            {
                payBgView.alpha =1-scrollView.contentOffset.x/(self.view.width-100);
                self.videoPreviewLayer.opacity =scrollView.contentOffset.x/(self.view.width-100);
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.tag == 11001)
    {
        if(scrollView.contentOffset.x== self.view.width)
        {
            [self myPayCodeToScanCode];
        }
        else
        {
            [self scanCodeToMyPayCode];
            
        }
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
