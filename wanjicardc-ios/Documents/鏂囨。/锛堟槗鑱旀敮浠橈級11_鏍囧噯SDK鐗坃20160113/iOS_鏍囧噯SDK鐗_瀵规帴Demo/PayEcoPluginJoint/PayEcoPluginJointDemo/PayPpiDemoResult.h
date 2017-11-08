//
//  PayPpiDemoResult.h
//  PayEcoPluginJointDemo
//
//  Created by 詹海岛 on 15/1/19.
//  Copyright (c) 2015年 PayEco. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @ClassName PayPpiDemoResult
 * @Description 支付结果页面，显示支付返回的信息
 *
 */
@interface PayPpiDemoResult : UIViewController

//支付完成返回的json字符串
@property (nonatomic, strong) NSString *respJson;

@end
