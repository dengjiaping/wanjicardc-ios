//
//  WJAlertView.m
//  WanJiCard
//
//  Created by 孙明月 on 16/1/16.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJAlertView.h"
#define BetweenText  10
#define TitleFont  ALD(21)
#define MessageFont  ALD(15)
#define ButtonFont  ALD(16)
#define TextY   214
#define TitleColor  [UIColor blackColor]
#define MessageColor [WJUtilityMethod colorWithHexColorString:@"#646464"]
@interface WJAlertView()
{
    UIImageView *alertViewBackgroundImageView;
    UILabel *titleLabel;
    UILabel *alertTextLabel;
}

@end
@implementation WJAlertView

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id<WJAlertViewDelegate>)delegate
  cancelButtonTitle:(NSString *)cancelTitle
  otherButtonTitles:(NSString *)otherTitles
      textAlignment:(NSTextAlignment)alignment
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self = [super initWithFrame:window.bounds];

    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.5f];
        self.delegate = delegate;
        self.title = title;
        self.message = message;
        self.alertTag = kAlertViewTag;
        
        NSString *imageName = [NSString stringWithFormat:@"alert_base_%@@%@x", @(kScreenWidth), @([UIScreen mainScreen].scale)];
        if([[UIScreen mainScreen] scale] == 3){
            imageName = @"alert_base_414@3x";
        }
       
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        alertViewBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        alertViewBackgroundImageView.userInteractionEnabled = YES;
        alertViewBackgroundImageView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(110, 0, 20, 0)];
        [self addSubview:alertViewBackgroundImageView];

        
        //除了text部分的高度
        CGFloat noTextHeight = ALD((TextY+46+34)*0.5)+30;
        //title的高度
        CGFloat titleHeight = 0;
        //message的高度
        CGFloat messageHeight = 0;
        //文字部分的高度
        CGFloat textH = titleHeight + BetweenText + messageHeight;
        
      
        //title
        titleLabel = [self labelWithFrame:CGRectZero  text:title textColor:TitleColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:TitleFont];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        //message
        alertTextLabel = [self labelWithFrame:CGRectZero text:message textColor:MessageColor];
        alertTextLabel.font = [UIFont systemFontOfSize:MessageFont];
        alertTextLabel.textAlignment = alignment;
       
        [alertViewBackgroundImageView addSubview:titleLabel];
        [alertViewBackgroundImageView addSubview:alertTextLabel];
        
        
        if (title && [title length] > 0) {
            //title的适应高度
            CGRect titleSize = [title boundingRectWithSize:CGSizeMake(alertViewBackgroundImageView.width-22, 100000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:TitleFont]} context:nil];
            
            titleHeight = titleSize.size.height;
        }
        
        if(message && [message length]>0) {
            CGRect messageSize = [message boundingRectWithSize:CGSizeMake(alertViewBackgroundImageView.width-22, 100000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:MessageFont]} context:nil];
            
            messageHeight = messageSize.size.height;
        }
        
        
        CGFloat borgin = titleHeight > 0 ? BetweenText : 0;
        titleLabel.frame = CGRectMake(11, ALD(TextY*0.5), alertViewBackgroundImageView.width - 22, titleHeight);
        alertTextLabel.frame = CGRectMake(11, titleLabel.bottom + borgin, alertViewBackgroundImageView.width - 22, messageHeight);
        textH = titleHeight + borgin + messageHeight;

        alertViewBackgroundImageView.frame = CGRectMake((self.width - alertViewBackgroundImageView.width)*0.5, ALD(304*0.5), alertViewBackgroundImageView.width, MAX(image.size.height, textH + noTextHeight));
        [self addButtonWithCancel:cancelTitle otherText:otherTitles];
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
    CGFloat buttonWidth = (alertViewBackgroundImageView.width-30)/2;
    CGFloat buttonHeight = 30;

    if (cancelTxt && otherTxt) {

        //左侧按钮
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(11, alertViewBackgroundImageView.height - ALD(34*0.5) - buttonHeight, buttonWidth, buttonHeight);
        cancelButton.tag = 1000;
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:ButtonFont]];
        [cancelButton setTitle:cancelTxt forState:UIControlStateNormal];
        [cancelButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [cancelButton addTarget:self action:@selector(alertButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cancelButton setBackgroundImage:[[UIImage imageNamed:@"alert_button_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30/2, 0, 30/2)] forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[[UIImage imageNamed:@"alert_button_highlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30/2, 0, 30/2)] forState:UIControlStateHighlighted];
        
        [alertViewBackgroundImageView addSubview:cancelButton];
        
        
        //右侧按钮
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(alertViewBackgroundImageView.width - 11 - buttonWidth, alertViewBackgroundImageView.height - ALD(17)-buttonHeight, buttonWidth, buttonHeight);
        confirmButton.tag = 1001;
        [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:ButtonFont]];
        [confirmButton setTitle:otherTxt forState:UIControlStateNormal];
        [confirmButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [confirmButton addTarget:self action:@selector(alertButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [confirmButton setBackgroundImage:[[UIImage imageNamed:@"alert_button_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30/2, 0, 30/2)] forState:UIControlStateNormal];
        [confirmButton setBackgroundImage:[[UIImage imageNamed:@"alert_button_highlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30/2, 0, 30/2)] forState:UIControlStateHighlighted];
        
        [alertViewBackgroundImageView addSubview:confirmButton];
        
    } else {
        
        //只有一个按钮
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake((alertViewBackgroundImageView.width - ALD(180))*0.5, alertViewBackgroundImageView.height - ALD(17) - buttonHeight, ALD(180), buttonHeight);
        confirmButton.tag = 1000;
        [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:ButtonFont]];
        [confirmButton setTitle:cancelTxt?:(otherTxt?:@"确定") forState:UIControlStateNormal];
        
        [confirmButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [confirmButton addTarget:self action:@selector(alertButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [confirmButton setBackgroundImage:[[UIImage imageNamed:@"alert_button_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30/2, 0, 30/2)] forState:UIControlStateNormal];
        [confirmButton setBackgroundImage:[[UIImage imageNamed:@"alert_button_highlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30/2, 0, 30/2)] forState:UIControlStateHighlighted];
        
        [alertViewBackgroundImageView addSubview:confirmButton];
        
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
    
    if (_delegate && [_delegate respondsToSelector:@selector(wjAlertView:clickedButtonAtIndex:)]) {
        [_delegate wjAlertView:self clickedButtonAtIndex:btn.tag-1000];
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
    self.tag = self.alertTag;
    [window addSubview:self];
}

/**
 *  @brief 退出
 */
- (void)dismiss
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *alertView = [window viewWithTag:self.alertTag];
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
