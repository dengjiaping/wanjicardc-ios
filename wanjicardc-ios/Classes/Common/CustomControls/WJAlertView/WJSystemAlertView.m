//
//  WJSystemAlertView.m
//  WanJiCard
//
//  Created by 孙琦 on 16/7/5.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJSystemAlertView.h"

#define LINE_SPACING ALD(7)   //行间距
#define TitleFont    WJFont17
#define MessageFont  WJFont13
#define ButtonFont   WJFont17

#define WJColorDardGray5            [WJUtilityMethod colorWithHexColorString:@"#555555"]
#define WJColorAlertButton            [WJUtilityMethod colorWithHexColorString:@"#157efb"]

@implementation WJSystemAlertView
{
    UIImageView *backImaegView;
    UILabel *titleLabel;
    UILabel *messageLabel;
    //横线
    UIView *lineH;
    UIButton *cancelBtn;
    UIButton *confirmButton;
}

#pragma mark - 初始化
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id<WJSystemAlertViewDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelTitle
            otherButtonTitles:(NSString *)otherTitles
                textAlignment:(NSTextAlignment)alignment
{
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    if(self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.5f];
        self.title = title;
        self.message = message;
        self.delegate = delegate;
        self.alertTag = kSystemAlertViewTag;
        
        //message距离左边的距离
        CGFloat messageDistanceBorderX = ALD(15);
        
        backImaegView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ALD(270), ALD(165))];
        backImaegView.center = self.center;
        backImaegView.backgroundColor = [UIColor whiteColor];
        backImaegView.layer.cornerRadius = 13;
        backImaegView.userInteractionEnabled = YES;
        [self addSubview:backImaegView];
        
        //标题label
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.font = TitleFont;
        titleLabel.textColor = WJColorDardGray3;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        [backImaegView addSubview:titleLabel];
        
        //消息label
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(messageDistanceBorderX), 0, backImaegView.bounds.size.width-ALD(messageDistanceBorderX)*2, 10)];
        messageLabel.font = MessageFont;
        messageLabel.textColor = WJColorDardGray5;
        messageLabel.numberOfLines = 0;
        [backImaegView addSubview:messageLabel];
        
        [self fitTitleAndMessageFrame];
        
        //竖线
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, backImaegView.bounds.size.height-ALD(43), backImaegView.bounds.size.width, ALD(0.5))];
        lineV.backgroundColor = WJColorDarkGrayLine;
        [backImaegView addSubview:lineV];
        
        //横线
       lineH = [[UIView alloc] initWithFrame:CGRectMake(backImaegView.bounds.size.width/2, backImaegView.bounds.size.height-ALD(43), ALD(0.5), ALD(43))];
        lineH.backgroundColor = WJColorDarkGrayLine;
        [backImaegView addSubview:lineH];
        [self addCancelButtonTitle:cancelTitle otherButtonTitles:otherTitles];
    }
    return self;
}

#pragma mark - 初始化Views
- (void)addCancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitles
{
  
    if ((cancelTitle && cancelTitle.length>0) && (otherTitles && otherTitles.length>0)) {
        //左侧按钮
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0,backImaegView.bounds.size.height-ALD(43),backImaegView.bounds.size.width/2,ALD(43));
        cancelBtn.tag = 1000;
        [cancelBtn.titleLabel setFont:ButtonFont];
        [cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
        [cancelBtn setTitleColor:WJColorAlertButton forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [cancelBtn addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [backImaegView addSubview:cancelBtn];
        
        //右侧按钮
        confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(backImaegView.bounds.size.width/2,backImaegView.bounds.size.height-ALD(43),backImaegView.bounds.size.width/2,ALD(43));
        confirmButton.tag = 1001;
        [confirmButton.titleLabel setFont:ButtonFont];
        [confirmButton setTitle:otherTitles forState:UIControlStateNormal];
        [confirmButton setTitleColor:WJColorAlertButton forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [confirmButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [backImaegView addSubview:confirmButton];
    }
    else
    {
        lineH.hidden = YES;
        //一个按钮
        confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(0,backImaegView.bounds.size.height-ALD(43),backImaegView.bounds.size.width,ALD(43));
        confirmButton.tag = 1000;
        [confirmButton.titleLabel setFont:ButtonFont];
        [confirmButton setTitle:(cancelTitle != nil && cancelTitle.length>0)?cancelTitle:otherTitles forState:UIControlStateNormal];
        [confirmButton setTitleColor:WJColorAlertButton forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [confirmButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [backImaegView addSubview:confirmButton];
        
    }
//    [backImaegView setFrame:CGRectMake(CGRectGetMinX(backImaegView.frame),
//                                       CGRectGetMinY(backImaegView.frame),
//                                       CGRectGetWidth(backImaegView.frame),
//                                       CGRectGetMaxY(cancelBtn.frame))];
}

#pragma mark - 重新适配高度
- (void)fitTitleAndMessageFrame
{
    //标题label高
    CGFloat titleHeight = 0;
    //消息高度
    CGFloat messageHeight = 0;
    //标题和label的总高度
    CGFloat textTotalHeight = 0;
    //title到message的间距
    CGFloat titleToMessageHeight = 0;
    //message距离左边的距离
    CGFloat messageDistanceBorderX = ALD(15);
    titleLabel.text = _title;
    messageLabel.text = _message;
    if (self.title && [self.title length] > 0) {
        //title的适应高度
        CGRect titleSize = [self.title boundingRectWithSize:CGSizeMake(backImaegView.bounds.size.width-ALD(30), 100000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: TitleFont} context:nil];
        titleHeight = titleSize.size.height>35?35:titleSize.size.height;
    }
    
    //设置message行间距
    if (self.message && [self.message length] > 0) {
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.message];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:LINE_SPACING];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.message length])];
        [messageLabel setAttributedText:attributedString1];
        [messageLabel sizeToFit];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageHeight = messageLabel.bounds.size.height;
        //如果消息是多行显示
        if ((messageLabel.bounds.size.height-LINE_SPACING)/ ALD(13) >2) {
            titleToMessageHeight = 10;
        }
        else
        {
            titleToMessageHeight = 8;
        }
    }
    
    //只有标题或是只有消息
    if(!((self.message && self.message.length>0)&&(self.title && self.title.length>0)))
    {
        titleToMessageHeight = 0;
    }
    
    textTotalHeight = titleHeight+messageHeight+titleToMessageHeight;
    titleLabel.frame = CGRectMake(ALD(15), (backImaegView.bounds.size.height - ALD(43) - textTotalHeight)/2, backImaegView.bounds.size.width-ALD(30), titleHeight);

    
    //如果消息是多行显示
    if ((messageLabel.bounds.size.height-LINE_SPACING)/ALD(13)>2) {
        
        messageLabel.frame = CGRectMake(ALD(messageDistanceBorderX),  CGRectGetMaxY(titleLabel.frame) + titleToMessageHeight, backImaegView.bounds.size.width-ALD(messageDistanceBorderX)*2, messageHeight);
        
    }
    else
    {
        messageLabel.frame = CGRectMake(ALD(messageDistanceBorderX),  CGRectGetMaxY(titleLabel.frame) + titleToMessageHeight+LINE_SPACING/2, backImaegView.bounds.size.width-ALD(messageDistanceBorderX)*2, messageHeight);
    }
    
    
//    [cancelBtn setFrame:CGRectMake(0, CGRectGetMaxY(messageLabel.frame) + ALD(22), cancelBtn.frame.size.width, cancelBtn.frame.size.height)];
//    
//    [confirmButton setFrame:CGRectMake(CGRectGetMaxX(cancelBtn.frame), CGRectGetMaxY(messageLabel.frame) + ALD(22), confirmButton.frame.size.width, confirmButton.frame.size.height)];

    
//    [backImaegView setFrame:CGRectMake(CGRectGetMinX(backImaegView.frame),
//                                      CGRectGetMinY(backImaegView.frame),
//                                      CGRectGetWidth(backImaegView.frame),
//                                       CGRectGetMaxY(cancelBtn.frame))];
    
}

- (void)cancelButtonClicked:(UIButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(wjAlertView:clickedButtonAtIndex:)]) {
        [_delegate wjAlertView:self clickedButtonAtIndex:btn.tag-1000];
    }
    
    [self dismiss];
}

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

- (void)setMessage:(NSString *)message
{
    if(_message != message)
    {
       _message = message;
    }
    [self fitTitleAndMessageFrame];
}

- (void)setTitle:(NSString *)title
{
    if(_title != title)
    {
        _title = title ;
    }
     [self fitTitleAndMessageFrame];
}

@end

