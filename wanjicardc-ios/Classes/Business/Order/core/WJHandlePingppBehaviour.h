//
//  WJHandlePingppBehaviour.h
//  WanJiCard
//
//  Created by Angie on 15/11/6.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Pingpp/Pingpp.h>

@interface WJHandlePingppBehaviour : NSObject

- (void)handleResult:(NSString *)str error:(PingppError *)error currentViewController:(UIViewController *)viewController;




@end
