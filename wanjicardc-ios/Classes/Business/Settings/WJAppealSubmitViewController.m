//
//  WJAppealSubmitViewController.m
//  WanJiCard
//
//  Created by 孙明月 on 15/12/2.
//  Copyright © 2015年 zOne. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>
#import "WJAppealSubmitViewController.h"
#import "TKAlertCenter.h"
#import "WJPaySettingController.h"
#import "SecurityService.h"
#import "APIAppealInfoManager.h"
#import "WJOriginalViewController.h"
#import "WJSignCreateManager.h"
#import "AFHTTPSessionManager.h"
#import "WJSystemAlertView.h"
#import "WJCardPackageViewController.h"

#import "APIBaseService.h"
#import "APIServiceFactory.h"
#import "WJEleCardDeteilViewController.h"
#import "WJMyOrderController.h"
#import "WJOrderDetailController.h"

#define kButtonWidth   22

@interface WJAppealSubmitViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,WJSystemAlertViewDelegate>
{
    UIImageView *_sampleView;   //示例图
    UIImageView *_backGray; //添加底图
    UIImageView *_picView;  //添加图片
    UIView      *_blackView;    //黑色底
    UIImageView *_bigPic;   //大图片
    UIButton    *deleteButton;  //删除图标
    NSData      *_imgData;   //图片流
    
    UIButton    *_submitButton;//提交按钮
}

@property(strong,nonatomic) APIAppealInfoManager *appealManager;
@end

@implementation WJAppealSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申诉信息";
    
    [self initSubviews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initSubviews
{
    UIScrollView *backScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backScroll.backgroundColor = WJColorViewBg;
    if (kScreenHeight <= ALD(15+250+38+150+73+10)) {
        backScroll.contentSize = CGSizeMake(kScreenWidth, ALD(15+250+38+150+73+10));
    }else{
        backScroll.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    }
   
    [self.view addSubview:backScroll];
    
    _sampleView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(15), ALD(15), kScreenWidth - ALD(30), ALD(250))];
    _sampleView.image = [UIImage imageNamed:@"sample_ID_pic"];
    [backScroll addSubview:_sampleView];
    
    
    UILabel *noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(ALD(15), _sampleView.frame.origin.y + _sampleView.frame.size.height + ALD(15), kScreenWidth - ALD(30), ALD(13))];
    noteLabel.text = @"请根据上图示例拍摄一张手持身份证照片";
    noteLabel.font = WJFont14;
    noteLabel.textColor = WJColorDardGray3;
    [backScroll addSubview:noteLabel];
    
    _backGray = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(15), CGRectGetMaxY(noteLabel.frame) + ALD(10), kScreenWidth - ALD(30), ALD(150))];
    _backGray.userInteractionEnabled = YES;
    _backGray.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"#f7f7f7"];
    [backScroll addSubview:_backGray];
    
    
    //底图画虚线
    UIGraphicsBeginImageContext(_backGray.frame.size);   //开始画线
    [_backGray.image drawInRect:CGRectMake(0, 0, _backGray.frame.size.width, _backGray.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    CGContextRef line = UIGraphicsGetCurrentContext();//获取绘图用的图形上下文
    CGContextSetStrokeColorWithColor(line,  [WJUtilityMethod colorWithHexColorString:@"#dbdbdb"].CGColor);//设置线的颜色
//    CGContextSetLineWidth(line, 1.0);//设置线的宽度
    
    CGFloat lengths[] = {5,3};//间隔长度
    CGContextSetLineDash(line, 0, lengths, 2);  //第一个参数是绘制使用的上下文，第二个参数表示绘制第一个线段的时候跳过多少距离，第三个参数是绘制的间隔距离数组，第四个参数是第三个参数lengths数组的长度
    
    CGContextMoveToPoint(line, 0.0, 0.0);    //画线的起始点位置
    CGContextAddLineToPoint(line, ALD(345), 0.0);//画第一条线的终点位置,此时画笔位置在(ALD(345)，0.0)
    CGContextAddLineToPoint(line, ALD(345), ALD(150));//画第一条线的终点位置,此时画笔位置在(ALD(345)，0.0)
    CGContextAddLineToPoint(line, 0.0, ALD(150));//画第一条线的终点位置,此时画笔位置在(ALD(345)，0.0)
    CGContextAddLineToPoint(line, 0.0, 0.0);//画第一条线的终点位置,此时画笔位置在(ALD(345)，0.0)
    CGContextStrokePath(line);//把线在界面上绘制出来

    _backGray.image = UIGraphicsGetImageFromCurrentImageContext();
    
    //图片
    _picView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(11), ALD(11), ALD(345)-ALD(11)*2, ALD(150)-ALD(11)*2)];
    _picView.userInteractionEnabled = YES;
    _picView.hidden = YES;
    _picView.contentMode = UIViewContentModeScaleAspectFit;
    [_backGray addSubview:_picView];
    
    //点击手势，放大图片
    UITapGestureRecognizer * picTapGusture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomInImage:)];
    [_picView addGestureRecognizer:picTapGusture];
    
    
    UIButton *addButton = [[UIButton alloc]initForAutoLayout];
    [addButton setImage:[UIImage imageNamed:@"add_pic_icon"] forState:UIControlStateNormal];
    addButton.tag = 200;
    [addButton addTarget:self action:@selector(addPicAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backGray addSubview:addButton];
    [_backGray addConstraints:[addButton constraintsTopInContainer:ALD(42)]];
    [_backGray addConstraints:[addButton constraintsSize:CGSizeMake(ALD(45), ALD(45))]];
    [_backGray addConstraint:[addButton constraintCenterXEqualToView:_backGray]];
    
    UILabel *noteLabel2 = [[UILabel alloc] initForAutoLayout];
    noteLabel2.text = @"请确保照片真实性及照片清晰度";
    noteLabel2.tag = 201;
    noteLabel2.textAlignment = NSTextAlignmentCenter;
    noteLabel2.font = WJFont14;
    noteLabel2.textColor = WJColorDardGray9;
    [_backGray addSubview:noteLabel2];
    [_backGray addConstraints:[noteLabel2 constraintsBottomInContainer:ALD(24)]];
//    [backGray addConstraints:[noteLabel2 constraintsSize:CGSizeMake(ALD(45), ALD(45))]];
    [_backGray addConstraint:[noteLabel2 constraintCenterXEqualToView:_backGray]];
    

    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.frame = CGRectMake(ALD(15), _backGray.frame.origin.y + _backGray.frame.size.height + ALD(33), kScreenWidth - ALD(30), ALD(40));
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = ALD(6);
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_submitButton.titleLabel setFont:WJFont14];
    [_submitButton setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorViewNotEditable] forState:UIControlStateDisabled];
    [_submitButton setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorNavigationBar] forState:UIControlStateNormal];
    _submitButton.enabled = NO;
    [backScroll addSubview:_submitButton];
    [_submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _blackView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _blackView.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:_blackView];
    _blackView.hidden = YES;
    
    //点击手势，退出大图
    UITapGestureRecognizer * blackTapGusture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomOut:)];
    [_blackView addGestureRecognizer:blackTapGusture];
    
    _bigPic = [[UIImageView alloc] initWithFrame:_blackView.bounds];
    _bigPic.userInteractionEnabled = YES;
    _bigPic.contentMode = UIViewContentModeScaleAspectFit;
    [_blackView addSubview:_bigPic];
    
    deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.tag = 202;
    [deleteButton setImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
    [_backGray addSubview:deleteButton];
    [deleteButton addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //捏合手势
    UIPinchGestureRecognizer * pinchGesture=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPinchGesture:)];
    [_bigPic addGestureRecognizer:pinchGesture];
    
}


#pragma mark- WJSystemAlertViewDelegate

- (void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIView * grayView = [self.view viewWithTag:55555];
        [grayView removeFromSuperview];
        [self submitSuccess];
    }
}


#pragma mark- Event Response
//添加图片
- (void)addPicAction:(UIButton *)button
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
   
    //设置选择后的图片可被编辑
    //picker.allowsEditing = YES;
    [self presentViewController:picker animated:NO completion:nil];
}


//放大图片
- (void)zoomInImage:(UITapGestureRecognizer *)gesture
{
    _blackView.hidden = NO;
    if (_picView.image) {
        _bigPic.image = _picView.image;
    }
}


//退出大图
- (void)zoomOut:(UITapGestureRecognizer *)gesture
{
    _blackView.hidden = YES;
}


//捏合
- (void)imageViewPinchGesture:(UIPinchGestureRecognizer *)gesture
{
    gesture.view.transform = CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
    gesture.scale = 1;
}


//删除图片
- (void)deletePic:(UIButton *)button
{
    [[_backGray viewWithTag:200] setHidden:NO];
    [[_backGray viewWithTag:201] setHidden:NO];
    [[_backGray viewWithTag:202] setHidden:YES];
    _picView.frame = CGRectMake(ALD(11), ALD(11), ALD(345)-ALD(11)*2, ALD(150)-ALD(11)*2);
    _picView.hidden = YES;
    _imgData = nil;
    _submitButton.enabled = NO;
}


#pragma Delegate method UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    [[_backGray viewWithTag:200] setHidden:YES];
    [[_backGray viewWithTag:201] setHidden:YES];
    [[_backGray viewWithTag:202] setHidden:NO];
    _picView.hidden = NO;
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
        
    {
        //照片原图
        UIImage* orImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

        if (orImage) {
            
            _picView.image = orImage;
            
//            NSLog(@"图片的宽和高为：%f %f", _backGray.image.size.width, _backGray.image.size.height);
            
            CGFloat backGrayWH = _picView.width * 1.0 / _picView.height;
            CGFloat imageWH = orImage.size.width * 1.0 / orImage.size.height;
            
            if ( backGrayWH - imageWH > 0)
            {
                // 宽高比 高度大 高度顶头
                CGFloat width = imageWH *_picView.height;
                
                CGRect frame = CGRectMake(_picView.width / 2.0 + width / 2.0 , CGRectGetMinY(_picView.frame) - kButtonWidth/ 2.0, kButtonWidth, kButtonWidth);
                [deleteButton setFrame:frame];
                
                CGRect picFrame = CGRectMake(_picView.width / 2.0 - width /2.0 + ALD(11), CGRectGetMinY(_picView.frame), width, CGRectGetHeight(_picView.frame));
                _picView.frame = picFrame;
                
            } else{
                
                //宽度大
                CGFloat height = orImage.size.height * 1.0 * _picView.width / orImage.size.width;
                
                CGRect frame = CGRectMake(_picView.frame.size.width, CGRectGetMinY(_picView.frame) + _picView.height /2.0 - height / 2.0 - kButtonWidth/2.0 , kButtonWidth, kButtonWidth);
                
                [deleteButton setFrame:frame];
                
                
                _picView.frame = CGRectMake(ALD(11), ALD(11), ALD(345)-ALD(11)*2, ALD(150)-ALD(11)*2);
                CGRect picFrame = CGRectMake(ALD(11), CGRectGetMinY(_picView.frame) + _picView.height / 2.0 - height / 2.0, ALD(345)-ALD(11)*2, height);
                _picView.frame = picFrame;
            }
            
            _imgData = UIImageJPEGRepresentation(orImage, 1.0);
//            NSLog(@"origin data len ===========%lu",[_imgData length]/1024/1024);
            
            while ([_imgData length]/1024/1024 > 10) {
                
                _imgData = UIImageJPEGRepresentation(orImage, 0.5);
            }
            
            _submitButton.enabled = YES;
            
            [picker dismissViewControllerAnimated:YES completion:nil];

        }else {
            _submitButton.enabled = NO;

            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"图片无效"];
        }
    }
}


//提交
- (void)submitAction:(UIButton *)button
{
  
    if(_imgData){
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{}];
        
        UIDevice *currentDevice = [UIDevice currentDevice];
        WJModelPerson * person = [WJGlobalVariable sharedInstance].defaultPerson;
        if (nil != person && nil != person.token) {
            [parameters addEntriesFromDictionary:@{@"token":person.token}];
        }else{
            [parameters addEntriesFromDictionary:@{@"token":@""}];
        }
        
        parameters[@"appType"] = kAppJAVAID;
        parameters[@"buildModel"] = [NSString stringWithFormat:@"%@", currentDevice.model];
        parameters[@"deviceId"] = [[WJUtilityMethod keyChainValue:NO] stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
        parameters[@"deviceVersion"] = currentDevice.systemVersion;
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        parameters[@"appVersion"] = infoDictionary[@"CFBundleShortVersionString"];
        parameters[@"name"] = self.appealInfo[@"name"];
        parameters[@"identity"] = self.appealInfo[@"idno"];
        parameters[@"years"] = [NSString stringWithFormat:@"%@%@",
                                self.appealInfo[@"year"],self.appealInfo[@"month"]];
        parameters[@"phone"] = self.appealInfo[@"Phone"];
        
        NSString * sign = [WJSignCreateManager createSingByDictionary:parameters];
        parameters[@"sign"] = sign;
        parameters[@"sysVersion"] = [NSString stringWithFormat:@"%@",kSystemVersion];
        
        WJAppealSubmitViewController * weakSelf = self;
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
        
        
        APIBaseService *service = [[APIServiceFactory sharedInstance] serviceWithIdentifier:kAPIServiceWanJiKa];
        NSString *baseImageUrl = service.apiBaseUrl;
        
        [manager POST:[NSString stringWithFormat:@"%@/userAppeal/individuals",baseImageUrl]
                parameters:parameters
        constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            [formData appendPartWithFileData :_imgData name:@"file" fileName:@"1.png" mimeType:@"image/jpeg"];
                [weakSelf showLoadingView];
            _submitButton.enabled = NO;
    
        } progress:nil
         
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

               [weakSelf hiddenLoadingView];
               
               if (responseObject) {

                   id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                options:NSJSONReadingAllowFragments
                                                                  error:nil];
                  
                   if (jsonObj) {
                       
                       NSLog(@"%@",jsonObj);
                       
                       NSString *errMsg = nil;
                       if([jsonObj objectForKey:@"rspMsg"]){
                           errMsg = [jsonObj objectForKey:@"rspMsg"];
                       }
                       
                       if ([[jsonObj objectForKey:@"rspCode"] integerValue] > 0) {
                           
                           //补充错误码和错误信息；
                          
                           if ( [ToString([jsonObj objectForKey:@"rspCode"]) isEqualToString:@"50009003"] || [ToString([jsonObj objectForKey:@"rspCode"]) isEqualToString:@"50008082"]) {
                              
                               [kDefaultCenter postNotificationName:kNoLogin object:errMsg];
                           }
                       }
                       
                       //成功
                       if ([[jsonObj objectForKey:@"rspCode"] integerValue] == 0) {
                           
                           [weakSelf showSuccessTip];
                       }
                       
                   }
                   
               }
               
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               
               [weakSelf hiddenLoadingView];
               [[TKAlertCenter defaultCenter] postAlertWithMessage:error.description];

           }];
        
    }else{
    
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请选择图片"];
    }
    
}

- (void)showSuccessTip
{
    WJSystemAlertView *av = [[WJSystemAlertView alloc] initWithTitle:@"提交成功" message:@"申诉结果将在48小时内通过短信的形式发送到您的手机，请耐心等待" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil textAlignment:NSTextAlignmentCenter];
    
    [av showIn];
    
    UIView * grayView = [[UIView alloc] initWithFrame:self.view.bounds];
    grayView.backgroundColor = [UIColor blackColor];
    grayView.alpha = 0.1;
    grayView.tag = 55555;
    
    [self.view addSubview:grayView];
}


- (void)submitSuccess
{    
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
    //如果已登录
    if (person) {
        person.appealStatus = AppealProcessing;
        [[WJDBPersonManager new] updatePerson:person];
        
    }else{
        
//        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:kTokenForChangePhone];
//        NSMutableDictionary *mutaDic = [NSMutableDictionary dictionaryWithDictionary:dic];
//        [mutaDic setValue:[NSString stringWithFormat:@"%d",10] forKey:@"appealStatus"];
//        [[NSUserDefaults standardUserDefaults] setObject:mutaDic forKey:kTokenForChangePhone];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTokenForChangePhone];
    }


    WJViewController *findFromVC = [WJGlobalVariable sharedInstance].findPwdFromController;
    if([findFromVC isKindOfClass:[WJEleCardDeteilViewController class]]){
       
       [kDefaultCenter postNotificationName:@"FindPasswordFromECardDetail" object:nil];
       [self.navigationController popToViewController:findFromVC animated:YES];
        
   
    }else if([findFromVC isKindOfClass:[WJMyOrderController class]]||
            [findFromVC isKindOfClass:[WJOrderDetailController class]]){
       
       [[NSNotificationCenter defaultCenter] postNotificationName:@"FindPasswordFromECardOrder"
                                                           object:nil];
       [self.navigationController popToViewController:findFromVC animated:YES];
       
   
    }
//    else if ([findFromVC isKindOfClass:[WJElectronicCardController class]]){
//    
//       [self.navigationController popToViewController:findFromVC animated:YES];
//       
//    }
    else{
       
       WJViewController *vc = [[WJGlobalVariable sharedInstance] fromController] ;
       if([vc isKindOfClass:[WJPaySettingController class]]){
           
           [self.navigationController popToViewController:vc animated:YES];
           
       }else if ([vc isKindOfClass:[WJCardPackageViewController class]]) {
           
           [self.navigationController popToRootViewControllerAnimated:NO];
           [[NSNotificationCenter defaultCenter] postNotificationName:@"PayCodeDismiss" object:nil userInfo:nil];
           
       }else{
           
           [self.navigationController popToRootViewControllerAnimated:YES];
       }
    }

}


#pragma mark- Getter and Setter

//- (APIAppealInfoManager *)appealManager
//{
//    
//    if (nil == _appealManager) {
//        _appealManager = [[APIAppealInfoManager  alloc]init];
//        _appealManager.delegate = self;
//    }
//    
//    return _appealManager;
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
