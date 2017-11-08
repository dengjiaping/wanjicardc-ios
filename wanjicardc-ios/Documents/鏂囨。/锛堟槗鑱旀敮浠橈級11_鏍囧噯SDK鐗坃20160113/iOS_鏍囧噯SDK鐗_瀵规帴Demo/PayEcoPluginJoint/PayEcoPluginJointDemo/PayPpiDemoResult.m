//
//  PayPpiDemoResult.m
//  PayEcoPluginJointDemo
//
//  Created by 詹海岛 on 15/1/19.
//  Copyright (c) 2015年 PayEco. All rights reserved.
//

#import "PayPpiDemoResult.h"

@interface PayPpiDemoResult ()

@property (strong, nonatomic) IBOutlet UITextField *orderIdField;        //订单号
@property (strong, nonatomic) IBOutlet UITextField *merchanOrderIdField; //商户订单号
@property (strong, nonatomic) IBOutlet UITextField *amountField;         //金额
@property (strong, nonatomic) IBOutlet UITextField *payTimeField;        //交易时间
@property (strong, nonatomic) IBOutlet UITextField *payStatusField;      //交易状态
@property (strong, nonatomic) IBOutlet UITextField *respCodeField;       //返回码
@property (strong, nonatomic) IBOutlet UITextField *respDescField;       //返回信息

- (IBAction)payBack:(id)sender; //关闭按钮点击事件

@end

@implementation PayPpiDemoResult

@synthesize respJson;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //json字符串转为dictionary
    NSDictionary *dict  = [self toJsonObjectWithJsonString:respJson];
    
    NSString *respCode  = [dict objectForKey:@"respCode"];
    NSString *respTitle = @"支付出错";
    
    if ([respCode isEqualToString:@"0000"]) {
        respTitle = @"支付成功";
    }
    
    NSString *respDesc = [dict objectForKey:@"respDesc"];
    if (!respDesc) {
        if ([respCode isEqualToString:@"0000"]) {
            respDesc  = @"支付成功";
        }else{
            respTitle = @"未知错误支付信息";
        }
    }
    
    //设置标题
    self.navigationItem.title = respTitle;
    
    //赋值
    self.orderIdField.text   = [dict objectForKey:@"OrderId"];
    self.merchanOrderIdField.text = [dict objectForKey:@"MerchOrderId"];
    self.amountField.text    = [dict objectForKey:@"Amount"];
    self.payTimeField.text   = [dict objectForKey:@"PayTime"];
    self.payStatusField.text = [self getPayStatus:dict];
    self.respCodeField.text  = respCode;
    self.respDescField.text  = respDesc;
    
}

//json字符串装换成json对象
- (id)toJsonObjectWithJsonString:(NSString *)jsonStr
{
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions
                                                  error:nil];
    return result;
}

//交易状态 01:未支付，02:已支付，03:已退款，04:已过期，05:已作废
- (NSString *)getPayStatus:(NSDictionary *)dict{
    NSString *status = [dict objectForKey:@"Status"];
    NSString *ret = @"未知状态";
    if ([status isEqualToString:@"01"]) {
        ret = @"未支付";
    }else if ([status isEqualToString:@"02"]) {
        ret = @"已支付";
    }else if ([status isEqualToString:@"03"]) {
        ret = @"已退款";
    }else if ([status isEqualToString:@"04"]) {
        ret = @"已过期";
    }else if ([status isEqualToString:@"05"]) {
        ret = @"已作废";
    }
    return ret;
}

- (IBAction)payBack:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}

@end
