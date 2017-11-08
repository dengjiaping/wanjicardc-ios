//
//  ViewController.h
//  PayEcoPluginJointDemo
//
//  Created by 詹海岛 on 15/1/19.
//  Copyright (c) 2015年 PayEco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKYFormRequest.h"


/**
 * @ClassName PayPpiDemoInput
 * @Description 示例DEMO，
 * 1.模拟客户端请求服务器进行下单
 * 2.跳转支付插件支付，并接收支付结果
 * 3.通知服务器支付结果
 * 如果是生产环境，[payEcoPpi startPay:reqJson delegate:self env:@"01"]; // 01: 生产环境
 *
 */
@interface PayPpiDemoInput : UIViewController <SKYFormRequestDelegate, UITextFieldDelegate>



@end

