//
//  WJCardPackageTipVeiw.m
//  WanJiCard
//
//  Created by 林有亮 on 16/7/13.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCardPackageTipVeiw.h"

@implementation WJCardPackageTipVeiw

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIImageView * logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - ALD(50), ALD(115), ALD(100), ALD(100))];
        logoIV.image = [UIImage imageNamed:@"cardPackageFaile"];
        
        UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(20), CGRectGetMaxY(logoIV.frame) + 25, kScreenWidth - ALD(40), 30)];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.textColor = kBlueColor;
        tipLabel.font = WJFont15;
        tipLabel.text = @"卡包加载失败";
        
        UILabel * desLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(20), CGRectGetMaxY(tipLabel.frame) + 15, kScreenWidth - ALD(40), 20)];
        desLabel.textAlignment = NSTextAlignmentCenter;
        desLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"9099a6"];
        desLabel.font = WJFont12;
        desLabel.text = @"请点击重新加载按钮试试吧！";
        
        self.reloadRequestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.reloadRequestBtn setFrame:CGRectMake(20, ALD(60) + CGRectGetMaxY(desLabel.frame), kScreenWidth - 40, 50)];
        [self.reloadRequestBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [self.reloadRequestBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
//        [self.reloadRequestBtn setTintColor:kBlueColor];
        [self.reloadRequestBtn.layer setCornerRadius:3];
        self.reloadRequestBtn.layer.borderColor = [kBlueColor CGColor];
        self.reloadRequestBtn.layer.borderWidth = 1;
        
        [self addSubview:logoIV];
        [self addSubview:tipLabel];
        [self addSubview:desLabel];
        [self addSubview:self.reloadRequestBtn];
    }
    return self;
}
@end
