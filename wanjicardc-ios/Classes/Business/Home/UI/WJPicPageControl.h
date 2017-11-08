//
//  WJPicPageControl.h
//  WanJiCard
//
//  Created by silinman on 16/7/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJPicPageControl : UIPageControl
{
//    UIImage *activeImage;
//    UIImage *inactiveImage;
}
@property (nonatomic,strong) UIImage *activeImage;
@property (nonatomic,strong) UIImage *inactiveImage;

- (id)initWithFrame:(CGRect)frame;


@end
