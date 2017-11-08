//
//  WJLoadingView.h
//  WanJiCard
//
//  Created by 孙明月 on 16/1/13.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJLoadingView : UIView
{
    UIImageView *imageView;
    UILabel *Infolabel;
}

@property (nonatomic, assign) NSString *loadtext;
@property (nonatomic, readonly) BOOL isAnimating;


//use this to init
- (id)initWithFrame:(CGRect)frame;
-(void)setLoadText:(NSString *)text;

- (void)startAnimation;
- (void)stopAnimationWithLoadText:(NSString *)text withType:(BOOL)type;

@end
