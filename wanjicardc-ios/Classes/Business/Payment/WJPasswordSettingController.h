//
//  WJPasswordSettingController.h
//  WanJiCard
//
//  Created by 孙明月 on 16/6/1.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJViewController.h"

@class WJPersonModel;
@interface WJPasswordSettingController : WJViewController

@property (nonatomic, assign) ComeFrom from;
@property (nonatomic, strong) WJPersonModel *currentPerson;

@end
