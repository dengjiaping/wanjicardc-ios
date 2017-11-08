//
//  WJShareFriendView.m
//  WanJiCard
//
//  Created by Lynn on 15/9/22.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJShareFriendView.h"

@interface WJShareFriendView()

@property (nonatomic, strong) UIView        *backView;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UILabel       *desLabel;
@property (nonatomic, strong) UIImageView   *logoImageView;
@property (nonatomic, strong) UIButton      *exitButton;
@property (nonatomic, strong) UIButton      *shareButton;
@end

@implementation WJShareFriendView
//@property (nonatomic, strong) UIView        *backView;
//@property (nonatomic, strong) UILabel       *titleView;
//@property (nonatomic, strong) UIImageView   *logoView;
//@property (nonatomic, strong) UIButton      *exitButton;
//@property (nonatomic, strong) UIButton      *shareButton;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(ALD(30), ALD(160), kScreenWidth-ALD(60), kScreenHeight - ALD(320))];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 6;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(5), ALD(25), CGRectGetWidth(_backView.frame) - ALD(10), ALD(25))];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"亲，你已经领取过会员卡了，不能再领啦！";
        _titleLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"028be6"];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame), CGRectGetWidth(_titleLabel.frame), CGRectGetHeight(_titleLabel.frame))];
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.text = @"不妨召集你好友过来领卡吧？";
        _desLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"028be6"];
        _desLabel.font = _titleLabel.font;
        
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_backView.frame) - ALD(120))/2, CGRectGetMaxY(_desLabel.frame) + ALD(30), ALD(120), ALD(120))];
        _logoImageView.image = [UIImage imageNamed:@"invitation_image"];
        
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setFrame:CGRectMake(ALD(15), CGRectGetMaxY(_logoImageView.frame) + ALD(50), CGRectGetWidth(_backView.frame) - ALD(30), ALD(40))];
        [_shareButton setTitle:@"马上邀请" forState:UIControlStateNormal];
        _shareButton.layer.cornerRadius = 3;
        [_shareButton addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"028be6"];
        
        
        CGFloat height = _shareButton.y + _shareButton.height + ALD(50);
        
        [_backView setFrame:CGRectMake(ALD(30), (kScreenHeight - height)/2.0, kScreenWidth - ALD(60), height)];
        
        _exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exitButton setFrame:CGRectMake(CGRectGetMaxX(_backView.frame)-ALD(22), CGRectGetMinY(_backView.frame) - ALD(23), ALD(44), ALD(44))];
        [_exitButton setImage:[UIImage imageNamed:@"shareExit"] forState:UIControlStateNormal];
        [_exitButton addTarget:self action:@selector(shareExitAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [_backView addSubview:_titleLabel];
        [_backView addSubview:_desLabel];
        [_backView addSubview:_shareButton];
        [_backView addSubview:_logoImageView];

      
        [self addSubview:_backView];
        [self addSubview:_exitButton];
        
        UIColor *backColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        UIImage *backImage = [WJUtilityMethod createImageWithColor:backColor];
        self.backgroundColor = [WJUtilityMethod getColorFromImage:backImage];

    }
    return self;
}

- (void)shareButtonAction
{
    NSLog(@"%s",__func__);
    
    if ([self.delegate respondsToSelector:@selector(ShareToFriend)]) {
        [self.delegate ShareToFriend];
    }
}

- (void)shareExitAction
{
    if ([self.delegate respondsToSelector:@selector(exitShareView)]) {
        [self.delegate exitShareView];
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
