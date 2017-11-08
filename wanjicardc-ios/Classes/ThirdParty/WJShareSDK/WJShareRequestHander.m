//
//  WJShareRequestHander.m
//  WanJiCard
//
//  Created by XT Xiong on 16/8/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJShareRequestHander.h"

@implementation WJShareRequestHander

+ (BOOL)WXSendLinkURL:(NSString *)urlString
              TagName:(NSString *)tagName
                Title:(NSString *)title
          Description:(NSString *)description
           ThumbImage:(UIImage *)thumbImage
              InScene:(enum WXScene)scene
{
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
    WXMediaMessage *message = [WXMediaMessage message];
    
    message.title = title;
    message.description = description;
    message.mediaObject = ext;
    message.messageExt = nil;
    message.messageAction = nil;
    message.mediaTagName = tagName;
    [message setThumbImage:thumbImage];
    
    SendMessageToWXReq* req = [self requestWithText:nil
                                     OrMediaMessage:message
                                              bText:NO
                                            InScene:scene];
    BOOL ifsuceess = [WXApi sendReq:req];
    NSLog(@"微信分享是否成功：%d",ifsuceess);
    return ifsuceess;
}

+ (SendMessageToWXReq *)requestWithText:(NSString *)text
                         OrMediaMessage:(WXMediaMessage *)message
                                  bText:(BOOL)bText
                                InScene:(enum WXScene)scene {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = bText;
    req.scene = scene;
    if (bText)
        req.text = text;
    else
        req.message = message;
    return req;
}

+ (BOOL)QQSendLinkURL:(NSString *)urlString
                Title:(NSString *)title
          Description:(NSString *)description
           ThumbImage:(NSString *)thumbImage
{
    NSURL *previewURL = [NSURL URLWithString:thumbImage];
    NSURL *uRL = [NSURL URLWithString:urlString];
    
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:uRL
                                title:title
                                description:description
                                previewImageURL:previewURL];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
    return [QQApiInterface sendReq:req];
}

+ (BOOL)WBSendLinkURL:(NSString *)urlString
             ObjectID:(NSString *)objectID
                Title:(NSString *)title
          Description:(NSString *)description
           ThumbImage:(NSData *)thumbImage
     ShareMessageFrom:(NSString *)shareMessageFrom{
    
    WBMessageObject *message = [WBMessageObject message];
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = objectID;
    webpage.title = title;
    webpage.description = description;
    //    多媒体内容缩略图,大小小于32k
    webpage.thumbnailData = thumbImage;
    webpage.webpageUrl = urlString;
    message.mediaObject = webpage;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    request.userInfo = @{@"ShareMessageFrom": shareMessageFrom,
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    return [WeiboSDK sendRequest:request];//v这句就可以发送消息了，不需要先授权
}

+ (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        default:
        {
            break;
        }
    }
}

@end
