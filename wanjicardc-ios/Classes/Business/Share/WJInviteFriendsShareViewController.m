//
//  WJInviteFriendsShareViewController.m
//  WanJiCard
//
//  Created by reborn on 16/5/30.
//  Copyright © 2016年 zOne. All rights reserved.
//
#import "WJInviteFriendsShareViewController.h"
#import "WJShareModel.h"
#import "APIShareManager.h"
#import "WJShareReformer.h"
#import <MessageUI/MessageUI.h>
#import "ShareManager.h"
#import "WJShareModel.h"
#import "WJSystemAlertView.h"

@interface WJInviteFriendsShareViewController ()<MFMessageComposeViewControllerDelegate, APIManagerCallBackDelegate, WJSystemAlertViewDelegate>
{
    UIImageView *imageView;
    UIImage     *shareImage;
    UIButton    *recommendFriendButton;

}
@property(nonatomic,strong) APIShareManager *shareManager;
@property(nonatomic,strong) NSMutableArray  *dataArray;
@property(nonatomic,strong) WJShareModel    *shareModel;
@end

@implementation WJInviteFriendsShareViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"邀请好友";
    self.eventID = @"iOS_act_pinvite";
    
    [self setUpUI];
    [self.shareManager loadData];
}

- (void)setUpUI
{
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - ALD(138))/2, ALD(68), ALD(138), ALD(138))];
    imageView.image = PlaceholderImage;
    [self.view addSubview:imageView];
    
    UILabel *shareL = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom + ALD(10), kScreenWidth, ALD(20))];
    shareL.text = @"分享领优惠券";
    shareL.textAlignment = NSTextAlignmentCenter;
    shareL.textColor = WJColorNavigationBar;
    shareL.font = WJFont15;
    [self.view addSubview:shareL];
    
    UILabel *shareContentL = [[UILabel alloc] initWithFrame:CGRectMake(0, shareL.bottom + ALD(10), kScreenWidth, ALD(30))];
    shareContentL.numberOfLines = 0;
    shareContentL.textAlignment = NSTextAlignmentCenter;
    shareContentL.text = @"您每天可以分享给好友五张10元优惠券\n每个好友只能领取一次哦";
    shareContentL.textColor = WJColorLightGray;
    shareContentL.font = WJFont12;
    [self.view addSubview:shareContentL];
    
    recommendFriendButton = [[UIButton alloc]initWithFrame:CGRectMake(25, shareContentL.bottom + ALD(100), kScreenWidth-50, 40)];
    recommendFriendButton.layer.cornerRadius=10;
    recommendFriendButton.backgroundColor=WJColorNavigationBar;
    [recommendFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [recommendFriendButton setTitle:@"邀请好友" forState:UIControlStateNormal];
    recommendFriendButton.titleLabel.font = [UIFont systemFontOfSize:14];
    recommendFriendButton.userInteractionEnabled = NO;
    [recommendFriendButton addTarget:self action:@selector(showShareActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recommendFriendButton];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    self.dataArray = [manager fetchDataWithReformer:[[WJShareReformer alloc] init]];
    self.shareModel = [self.dataArray firstObject];
    //    __weak typeof(self) weakSelf = self;
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.shareModel.imgUrl?:@""]
                 placeholderImage:PlaceholderImage
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if (image == nil) {
                                imageView.image = PlaceholderImage;
                            }
                            recommendFriendButton.userInteractionEnabled = YES;
//                            NSLog(@"图片成功");
                        }];
    
    //对图片进行拆检
    NSString *imageUrl = ClippingCenterImageUrl(self.shareModel.shareImgUrl, 140, 140);
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    shareImage = [[UIImage alloc] initWithData:imageData];
    NSLog(@"length == %lu",imageData.length/1024);
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    recommendFriendButton.userInteractionEnabled = NO;
    if (manager.errorMessage && manager.errorMessage.length >0) {
        
        [[TKAlertCenter defaultCenter]  postAlertWithMessage:manager.errorMessage];
    }
}

#pragma mark - sms短信
-(void)showSMSPicker {
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if ([messageClass canSendText]) {
        [self displaySMSComposerSheet];
    }
    else {
        
    
        WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil
                                                                    message:@"提示\n该设备没有短信功能"
                                                                   delegate:self
                                                          cancelButtonTitle:@"关闭"
                                                          otherButtonTitles:nil
                                                              textAlignment:NSTextAlignmentCenter];
        [alert showIn];
    }
}

-(void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    
    //    NSMutableString* absUrl = [[NSMutableString alloc] initWithString:web.request.URL.absoluteString];
    //    [absUrl replaceOccurrencesOfString:@"http://i.aizheke.com" withString:@"http://m.aizheke.com" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [absUrl length])];
    
    picker.body=@"Hi，最近好吗？我发现一款不错的app，已经得了50元优惠券 你也来试试吧？不要白不要你说呢？http://app.wjika.com/";
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

#pragma mark - sms delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:NO completion:nil];
    switch ( result ) {
            
        case MessageComposeResultCancelled:
            ALERT(@"发送取消");
            break;
        case MessageComposeResultFailed:
            ALERT(@"发送成功");
            break;
        case MessageComposeResultSent:
            ALERT(@"发送失败");
            break;
        default:
            break;
    }
}

#pragma mark - 分享
- (void)showShareActionSheet{

#pragma mark - ShareSDK

//    //1、创建分享参数（必要）
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    
//    if (self.shareModel.imgUrl) {
    
//        [shareParams SSDKSetupShareParamsByText:[self.shareModel.shareContent stringByAppendingString:self.shareModel.shareURL]
//                                         images:@[shareImage?:PlaceholderImage]
//                                            url:[NSURL URLWithString:self.shareModel.shareURL]
//                                          title:self.shareModel.title
//                                           type:SSDKContentTypeAuto];
//        //1.2、自定义分享平台（非必要）
//        NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
//        
//        
//        //2、分享
//        [ShareSDK showShareActionSheet:self.view
//                                 items:activePlatforms
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                       
//                       switch (state) {
//                               
//                           case SSDKResponseStateBegin:
//                               break;
//                               
//                           case SSDKResponseStateSuccess:
//                           {
//                               WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil
//                                                                                           message:@"分享成功"
//                                                                                          delegate:self
//                                                                                 cancelButtonTitle:@"确定"
//                                                                                 otherButtonTitles:nil
//                                                                                     textAlignment:NSTextAlignmentCenter];
//                               [alert showIn];
//                               
//                               
//                               break;
//                           }
//                               
//                           case SSDKResponseStateFail:
//                           {
//                               if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
//                               {
//                                   
//                                   WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil
//                                                                                               message:@"分享失败\n失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
//                                                                                              delegate:self
//                                                                                     cancelButtonTitle:@"确定"
//                                                                                     otherButtonTitles:nil
//                                                                                         textAlignment:NSTextAlignmentCenter];
//                                   [alert showIn];
//                                   
//                                   break;
//                               }
//                               
//                               else if(platformType == SSDKPlatformTypeMail && [error code] == 201) {
//                                   
//                                   WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil
//                                                                                               message:@"分享失败\n失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用。"
//                                                                                              delegate:self
//                                                                                     cancelButtonTitle:@"确定"
//                                                                                     otherButtonTitles:nil
//                                                                                         textAlignment:NSTextAlignmentCenter];
//                                   [alert showIn];
//                                   
//                                   break;
//                               }
//                               
//                               else {
//                                   
//                                   
//                                   WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil
//                                                                                               message:[NSString stringWithFormat:@"分享失败\n%@",error]
//                                                                                              delegate:self
//                                                                                     cancelButtonTitle:@"确定"
//                                                                                     otherButtonTitles:nil
//                                                                                         textAlignment:NSTextAlignmentCenter];
//                                   [alert showIn];
//                                   break;
//                               }
//                               break;
//                           }
//                               
//                           case SSDKResponseStateCancel:
//                               break;
//                               
//                           default:
//                               break;
//                       }
//                       
//                   }];
//        
//    }
    
}

-(void)recommendBySMS
{
    [self showSMSPicker];
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

#pragma mark getter,setter
-(APIShareManager *)shareManager
{
    if (nil==_shareManager) {
        _shareManager = [[APIShareManager alloc]init];
        _shareManager.delegate=self;
    }
    return _shareManager;
}

- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (WJShareModel *)shareModel
{
    if (nil == _shareModel) {
        _shareModel = [[WJShareModel alloc] init];
    }
    return _shareModel;
}
@end
