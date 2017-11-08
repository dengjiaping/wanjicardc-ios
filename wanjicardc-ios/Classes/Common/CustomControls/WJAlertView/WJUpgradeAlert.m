//
//  WJUpgradeAlert.m
//  WanJiCard
//
//  Created by 孙明月 on 16/1/18.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJUpgradeAlert.h"
#define BetweenText   ALD(15)
#define TextY   ALD(30)

#define TitleFont     24
#define MessageFont   14
#define ButtonFont    14

//#define TitleColor  [WJUtilityMethod colorWithHexColorString:@"#028be6"]
//#define MessageColor [WJUtilityMethod colorWithHexColorString:@"#646464"]

@interface WJUpgradeAlert()
{
    UIImageView *alertViewBackgroundImageView;
}

@end

@implementation WJUpgradeAlert
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<WJUpgradeAlertDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitles
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self = [super initWithFrame:window.bounds];
    
    if (self) {
//        self.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.5f];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.delegate = delegate;
        self.title = title;
        self.message = message;
        
        alertViewBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert_upgrade_pic"]];
        alertViewBackgroundImageView.userInteractionEnabled = YES;
        alertViewBackgroundImageView.clipsToBounds = NO;
        alertViewBackgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        alertViewBackgroundImageView.width = ALD(alertViewBackgroundImageView.width);
        alertViewBackgroundImageView.height = ALD(alertViewBackgroundImageView.height);
        
        NSLog(@"width ============%f",alertViewBackgroundImageView.width);
        
        //除了text部分的高度
//        CGFloat noTextHeight = ALD((TextY+46+48)*0.5)+30;
        CGFloat titleHeight = 0;
        CGFloat messageHeight = 0;
//        CGFloat messageWidth = 0;
        //title和message和中间的间隙的总高度
        CGFloat textH = titleHeight + BetweenText + messageHeight;
        
        //title
       
        UILabel *titleLabel = [self labelWithFrame:CGRectZero  text:title textColor:[UIColor whiteColor]];
        titleLabel.font = [UIFont boldSystemFontOfSize:TitleFont];
        
        //message
        UILabel *alertTextLabel = [self labelWithFrame:CGRectZero text:message textColor:[UIColor whiteColor]];
        alertTextLabel.font = [UIFont systemFontOfSize:MessageFont];
        
        
        if (title) {
            if ([title length] > 0) {
                //title的适应高度
                CGRect titleSize = [title boundingRectWithSize:CGSizeMake(alertViewBackgroundImageView.width, 100000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:TitleFont]} context:nil];
                
                titleHeight = titleSize.size.height;

            }
        }
        
        if (message) {
            if ([message length]>0) {

                CGRect messageSize = [message boundingRectWithSize:CGSizeMake(alertViewBackgroundImageView.width, 100000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:MessageFont]} context:nil];
               
                messageHeight = messageSize.size.width;

            }
        }
        
        if(titleHeight > 0){
            
            titleLabel.frame = CGRectMake(0, TextY, alertViewBackgroundImageView.width, titleHeight);
 
            alertTextLabel.frame = CGRectMake(0, titleLabel.bottom + BetweenText, alertViewBackgroundImageView.width, messageHeight);
           
            //title和message和中间的间隙的总高度
            textH = titleHeight + BetweenText + messageHeight;
            
        }else{
            
            alertTextLabel.frame = CGRectMake(0, BetweenText , alertViewBackgroundImageView.width, messageHeight);
            textH = messageHeight;
        }
        
        
//        if ((textH + noTextHeight) > ALD(583*0.5)) {
//          
//            alertViewBackgroundImageView.frame = CGRectMake((self.width - alertViewBackgroundImageView.width)*0.5, ALD(280*0.5),alertViewBackgroundImageView.width, textH + noTextHeight);
//
//        }else{
//          
            alertViewBackgroundImageView.frame = CGRectMake((self.width - alertViewBackgroundImageView.width)*0.5, (self.height - alertViewBackgroundImageView.height)/2, alertViewBackgroundImageView.width, alertViewBackgroundImageView.height);
//
//        }

        
        [self addButtonWithCancel:cancelTitle otherText:otherTitles];
        [alertViewBackgroundImageView addSubview:titleLabel];
        [alertViewBackgroundImageView addSubview:alertTextLabel];
    
        [self addSubview:alertViewBackgroundImageView];
        
    }
    
    return self;
}


/**
 *  @brief 创建button
 *
 *  @param cancelTxt  左按钮text
 *  @param otherTxt  右按钮text
 *
 *  @return 标签
 */
- (void)addButtonWithCancel:(NSString *)cancelTxt otherText:(NSString *)otherTxt
{
    
    UIImageView *buttonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert_button_normal"]];
    buttonImageView.clipsToBounds = NO;
    buttonImageView.contentMode = UIViewContentModeScaleAspectFill;
    CGFloat buttonHeight = buttonImageView.width;
    
    if (cancelTxt && otherTxt) {
    
        //左侧按钮
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(ALD(15), alertViewBackgroundImageView.height- ALD(30) - buttonHeight, (alertViewBackgroundImageView.width - ALD(40))/2, buttonHeight);
        cancelButton.tag = 2000;
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:ButtonFont]];
        [cancelButton setTitle:cancelTxt forState:UIControlStateNormal];
        [cancelButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [cancelButton addTarget:self action:@selector(alertButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cancelButton setBackgroundImage:[[UIImage imageNamed:@"alert_button_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, buttonHeight/2, 0, buttonHeight/2)] forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[[UIImage imageNamed:@"alert_button_highlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, buttonHeight/2, 0, buttonHeight/2)] forState:UIControlStateHighlighted];
        
        [alertViewBackgroundImageView addSubview:cancelButton];
        
        
        //右侧按钮
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(alertViewBackgroundImageView.width-ALD(15)-cancelButton.width, cancelButton.y, cancelButton.width, cancelButton.height);
        confirmButton.tag = 2001;
        [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:ButtonFont]];
        [confirmButton setTitle:otherTxt forState:UIControlStateNormal];
        [confirmButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [confirmButton addTarget:self action:@selector(alertButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [confirmButton setBackgroundImage:[[UIImage imageNamed:@"alert_button_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, buttonHeight/2, 0, buttonHeight/2)] forState:UIControlStateNormal];
        [confirmButton setBackgroundImage:[[UIImage imageNamed:@"alert_button_highlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, buttonHeight/2, 0, buttonHeight/2)] forState:UIControlStateHighlighted];
        
        [alertViewBackgroundImageView addSubview:confirmButton];
        
    }else if (cancelTxt || otherTxt) {
        
        //只有一个按钮
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(ALD(20), alertViewBackgroundImageView.height - ALD(30) - buttonHeight, alertViewBackgroundImageView.width - ALD(40), buttonHeight);
        confirmButton.tag = 2000;
        [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:ButtonFont]];
        [confirmButton setTitle:cancelTxt?cancelTxt:otherTxt forState:UIControlStateNormal];
        
        [confirmButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [confirmButton addTarget:self action:@selector(alertButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [confirmButton setBackgroundImage:[[UIImage imageNamed:@"alert_button_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, buttonHeight/2, 0, buttonHeight/2)] forState:UIControlStateNormal];
        [confirmButton setBackgroundImage:[[UIImage imageNamed:@"alert_button_highlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, buttonHeight/2, 0, buttonHeight/2)] forState:UIControlStateHighlighted];
        
        [alertViewBackgroundImageView addSubview:confirmButton];
        
    }else{
        
        //没有按钮
        
    }
    
}


/**
 *  @brief 创建类型一致的文字标签
 *
 *  @param aText  标签内容
 *  @param aSize  文字字体大小
 *  @param aFrame 标签大小
 *
 *  @return 标签
 */
- (UILabel *)labelWithFrame:(CGRect)aFrame text:(NSString *)aText textColor:(UIColor *)tColor
{
    UILabel *label = [[UILabel alloc] initWithFrame:aFrame];
    label.text = aText;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.textColor = tColor;
    //    label.layer.shadowColor = [UIColor blackColor].CGColor;
    //    label.layer.shadowOffset = CGSizeMake(-0.3f, 0.5f);
    //    label.layer.shadowOpacity = 0.5f;
    //    label.layer.shadowRadius = 1;
    return label;
}


/**
 *  @brief 按钮被点击
 */
- (void)alertButtonClicked:(UIButton *)btn
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(wjUpgradeAlert:clickedButtonAtIndex:)]) {
        [_delegate wjUpgradeAlert:self clickedButtonAtIndex:btn.tag-2000];
    }
    
    [self dismiss];
}


/**
 *  @brief 展示
 */
- (void)showIn
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.alpha = 0;
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 1;
    }];
    self.tag = kWJAlertTag;
    [window addSubview:self];
    
}

/**
 *  @brief 退出
 */
- (void)dismiss
{

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *alertView = [window viewWithTag:kWJAlertTag];
    [UIView animateWithDuration:0.16f animations:^{
        alertView.alpha = 0;
    } completion:^(BOOL finished) {
        [alertView removeFromSuperview];
    }];
}


- (void)setAlertTag:(NSInteger)alertTag
{
    if (_alertTag != alertTag) {
        _alertTag = alertTag;
        self.tag = alertTag;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
