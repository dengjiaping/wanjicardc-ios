//
//  ViewController.m
//  PayEcoPluginJointDemo
//
//  Created by 詹海岛 on 15/1/19.
//  Copyright (c) 2015年 PayEco. All rights reserved.
//

#import "PayPpiDemoInput.h"
#import "PayPpiDemoResult.h"
#import "libPayecoPayPlugin.h"
#import "PPIHudView.h"

//商户服务器下单地址，此地址为商户平台测试环境下单地址，商户接入需改为商户自己的服务器下单地址
#define URL_PAY_ORDER @"http://10.123.54.7:8080/order.do"

//模拟通知商户地址，建议在接收到支付成功结果时，通知商户服务器
#define URL_PAY_NOTIFY @"http://10.123.54.7:8080/Notify.do"

@interface PayPpiDemoInput ()<PayEcoPpiDelegate>
{
    UIBarButtonItem *barButtonItem;  //导航栏返回按钮
    PPIHudView *hud;                 //加载控件   （商户根据自己的情况，使用自己的加载控件）
    SKYFormRequest *formRequest;     //网络请求类 （商户根据自己的情况，使用自己的网络请求类）
    PayEcoPpi *payEcoPpi;            //易联支付类
    NSString *respJson;              //易联支付SDK返回的json信息
    NSString *tradeCode;             //只是用于区分下单过程和通知商户服务器过程
}

@property (strong, nonatomic) IBOutlet UITextField *orderDescField;    //商品描述输入框
@property (strong, nonatomic) IBOutlet UITextField *orderAmountField;  //商品金额输入框

- (IBAction)orderSubmit:(id)sender;  //订单提交按钮点击事件

@end

@implementation PayPpiDemoInput

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置标题
    self.navigationItem.title = @"对接Demo";
    
    //修改navBar的回退按键标题,下一个UI有效
    self.navigationItem.backBarButtonItem = nil;
    barButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Order

//提交订单按钮点击事件
- (IBAction)orderSubmit:(id)sender {
    
    //隐藏键盘
    [self.orderDescField resignFirstResponder];
    [self.orderAmountField resignFirstResponder];
    
    //标记为下单过程
    tradeCode = @"order";
    
    //请求超时时间
    NSTimeInterval timeOut = 30;
    //请求商户服务器下单地址
    NSString *url = URL_PAY_ORDER;
    
    //生成http form请求
    formRequest = [[SKYFormRequest alloc]init:url timeOut:timeOut];
    formRequest.requestDelegate = self;
    
    //组织通讯报文: 下单接口
    [self packFormParams];
    
    //通讯处理,显示提示框: 加载中...
    hud = [[PPIHudView alloc] initWithTitle:@"支付中..." parent:self.view];
    [hud show];
    
    //执行异步请求
    [formRequest httpPostAsyn];
    
}

//组织报文参数
-(void)packFormParams{
    
    if ([tradeCode isEqualToString:@"order"]) {  //下单过程执行
        
        //组织参数，用于向商户服务器下单的参数
        [formRequest addParam:@"OrderDesc" value:self.orderDescField.text];
        [formRequest addParam:@"Amount" value:self.orderAmountField.text];
        //以上参数根据实际需要来组织
        
    }else if ([tradeCode isEqualToString:@"notify"]) {  //通知商户服务器过程执行
        
        NSDictionary *dict = [self toJsonObjectWithJsonString:respJson];
        
        //组织参数，用于通知商户服务器
        for (NSString *key in [dict allKeys]) {
            [formRequest addParam:key value:[dict objectForKey:key]];
        }
        
    }
}

#pragma mark - SKYFormRequestDelegate

//提交订单请求失败后回调
- (void)onRequestFail:(NSString *)errCode errMsg:(NSString *)errMsg{
    NSArray *array = [NSArray arrayWithObjects:errCode,errMsg,nil];
    [self performSelectorOnMainThread:@selector(alertError:) withObject:array waitUntilDone:NO];
    return;
}

//提交订单请求成功后回调
- (void)onRequestSucc:(NSString *)strReponse{
    
    //解析响应数据，将json字符串转成NSDictionary
    NSDictionary *dict = [self toJsonObjectWithJsonString:strReponse];
    if (!dict) {
        return;
    }
    
    //响应示例如下，其中RetCode、RetMsg用于告诉客户端请求是否成功，其它参数可直接传递给易联支付插件
    //{
    //	"RetCode": "0000",
    //	"RetMsg": "",
    //	"Version": "2.0.0",
    //	"MerchOrderId": "1408006824547",
    //	"MerchantId": "302020000058",
    //	"Amount": "5.00",
    //	"TradeTime": "20140814170024",
    //	"OrderId": "302014081400038872",
    //	"Sign": "QBOiI4xl1CgWNHt+8KTyVR2c9bAGNMMkXTHsYhJrmr9QPuHhRe1CiPGu+beOiayQTGGigTJEzUm23q0lAnDoXcnmwt7bsyG+UOwl3m9OKUd8o+SP741OOJxXHK884OXWuygMXkczK+TvYhNv/RLYKgAVSG6qN0lmsc2lek+cxqo="
    //}
    
    //校验返回结果
    NSString *retCode = [dict objectForKey:@"RetCode"];
    NSString *retMsg = [dict objectForKey:@"RetMsg"];
    //业务错,显示错误
    if (![retCode isEqualToString:@"0000"]) {
        NSArray *array = [NSArray arrayWithObjects:retCode,retMsg,nil];
        [self performSelectorOnMainThread:@selector(alertError:) withObject:array waitUntilDone:NO];
        return;
    }
    
    
    if ([tradeCode isEqualToString:@"order"]) { //下单过程执行
        
        //组织参数用于跳转至易联支付插件，示例如下
        //{
        //	"Version": "2.0.0",
        //	"MerchOrderId": "1408006824547",
        //	"MerchantId": "302020000058",
        //	"Amount": "5.00",
        //	"TradeTime": "20140814170024",
        //	"OrderId": "302014081400038872",
        //	"Sign": "QBOiI4xl1CgWNHt+8KTyVR2c9bAGNMMkXTHsYhJrmr9QPuHhRe1CiPGu+beOiayQTGGigTJEzUm23q0lAnDoXcnmwt7bsyG+UOwl3m9OKUd8o+SP741OOJxXHK884OXWuygMXkczK+TvYhNv/RLYKgAVSG6qN0lmsc2lek+cxqo="
        //}
        
        //报文返回成功（商户需要提交给支付插件的订单内容）
        NSMutableDictionary *orderData = [NSMutableDictionary dictionaryWithDictionary:dict];
        [orderData removeObjectForKey:@"RetCode"];//RetCode参数不需要传递给易联支付插件
        [orderData removeObjectForKey:@"RetMsg"]; //RetMsg参数不需要传递给易联支付插件
        
        [self performSelectorOnMainThread:@selector(goNext:) withObject:orderData waitUntilDone:NO];
        
    }else if ([tradeCode isEqualToString:@"notify"]) { //通知商户服务器过程执行
        
        [self notificationCompletion];
        
    }
}

#pragma mark -
#pragma mark 易联支付

/*
 *  下单成功，开始调用易联支付插件进行支付
 */
- (void)goNext:(NSDictionary *)orderData{
    
    //使加载控件消失
    [hud dismiss];
    
    //orderData为商户下单返回的数据，将下单返回的数据转换成json字符串
    NSString *reqJson = [self toJsonStringWithJsonObject:orderData];
    
    NSLog(@"PayEcoPpi startPay: %@\n\n",reqJson);
    
    //初始化易联支付类对象
    payEcoPpi = [[PayEcoPpi alloc] init];
    
    
    /*
     *  跳转到易联支付SDK
     *  delegate: 用于接收支付结果回调
     *  env:环境参数 00: 测试环境  01: 生产环境
     *  orientation: 支付界面显示的方向 00：横屏  01: 竖屏
     */
    [payEcoPpi startPay:reqJson delegate:self env:@"00" orientation:@"01"];
    
    //释放内存
    hud = nil;
    formRequest = nil;
    tradeCode = nil;
}

#pragma mark -
#pragma mark PayEcoPpiDelegate（易联支付插件通过代理方式回调，通知商户支付结果）

/*
 *   易联支付完成后执行回调，返回数据，通知商户。
 */
- (void)payResponse:(NSString *)respJsonStr{
    NSLog(@"\nPayEco PpiDelegate payResponse:%@",respJsonStr);
    respJson = respJsonStr;
    
    //支付结果异步通知商户服务器
    [self notifyMerchantServer];
    
    [self performSelectorOnMainThread:@selector(goResult) withObject:nil waitUntilDone:NO];
    
}

#pragma mark - PayPpiDemoResult

//跳转到 PayPpiDemoResult 视图控制器
- (void)goResult{
    [self performSegueWithIdentifier:@"mySegue" sender:nil];
}

//把respJson传递给 PayPpiDemoResult 视图控制器 （respJson为易联支付SDK返回的json字符串）
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier compare:@"mySegue"] == NO)
    {
        id page2 = segue.destinationViewController;
        [page2 setValue:respJson forKey:@"respJson"];
    }
}

#pragma mark - Notify

//支付结果通知商户服务器
- (void)notifyMerchantServer{
    
    //标记为通知商户服务器过程
    tradeCode = @"notify";
    
    //请求超时时间
    NSTimeInterval timeOut = 30;
    //通知商户服务器接受支付结果地址
    NSString *url = URL_PAY_NOTIFY;
    
    //生成http form请求
    formRequest = [[SKYFormRequest alloc]init:url timeOut:timeOut];
    formRequest.requestDelegate = self;
    
    //组织参数
    [self packFormParams];
    
    //执行异步请求
    [formRequest httpPostAsyn];
    
}

//通知商户服务器完成
- (void)notificationCompletion
{
    formRequest = nil;
    tradeCode = nil;
}

//json字符串装换成json对象
- (id)toJsonObjectWithJsonString:(NSString *)jsonStr
{
    NSData* data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions
                                                  error:&error];
    //如果解析过程出错，显示错误
    if (error != nil) {
        NSString *errCode = [NSString stringWithFormat:@"%ld",(long)error.code];
        NSString *errMsg = [NSString stringWithFormat:@"解析出错，检查json格式: %@",error.localizedDescription];
        NSArray *array = [NSArray arrayWithObjects:errCode,errMsg,nil];
        [self performSelectorOnMainThread:@selector(alertError:) withObject:array waitUntilDone:NO];
        return nil;
    }
    return result;
}

//json对象转换成json字符串
- (NSString *)toJsonStringWithJsonObject:(id)jsonObject{
    NSData *result = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                     options:kNilOptions
                                                       error:nil];
    return [[NSString alloc] initWithData:result
                                 encoding:NSUTF8StringEncoding];
}

//订单出错，弹出错误提示框
- (void)alertError:(NSArray *)array{
    [hud dismiss];
    hud = nil;
    formRequest = nil;
    
    NSString *errCode = [NSString stringWithFormat:@"错误代码: %@",array[0]];
    UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:errCode message:array[1] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [uiAlert show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
