//
//  WJBaoziCountTableViewCell.m
//  WanJiCard
//
//  Created by silinman on 16/8/17.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJBaoziCountTableViewCell.h"
#import "WJClickImageView.h"

@implementation WJBaoziCountTableViewCell
{
    WJClickImageView    *clickIV;
    UIImageView         *bunsIV;
    UILabel             *bunsCountL;
    UILabel             *bunsTitleL;
    UIImageView         *lineIV;
    UILabel             *bottomLine;
    UIButton            *clickBtn;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = WJColorWhite;

        clickIV = [[WJClickImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - ALD(106), ALD(64))];
        clickIV.userInteractionEnabled = YES;
        [clickIV addTarget:self action:@selector(pushForMyBunsVC)];
        [self.contentView addSubview:clickIV];
        
        bunsIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), ALD(10), ALD(45), ALD(45))];
        bunsIV.image = [UIImage imageNamed:@"fair_btn_baozi"];
        [clickIV addSubview:bunsIV];
        
        bunsCountL = [[UILabel alloc] initWithFrame:CGRectMake(bunsIV.right + ALD(12), ALD(20), ALD(100), ALD(27))];
        bunsCountL.font = WJFont24;
        bunsCountL.textColor = WJYellowColorAmount;
        bunsCountL.text = @"0";
        [clickIV addSubview:bunsCountL];
        
        bunsTitleL = [[UILabel alloc] initWithFrame:CGRectMake(bunsCountL.right + ALD(5), ALD(25), ALD(50), ALD(17))];
        bunsTitleL.font = WJFont14;
        bunsTitleL.textColor = WJColorLightGray;
        bunsTitleL.text = @"个包子";
        [clickIV addSubview:bunsTitleL];
        
        lineIV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(104), ALD(5), ALD(1), ALD(54))];
        lineIV.image = [UIImage imageNamed:@"verticalLine"];
        [self.contentView addSubview:lineIV];
        
        clickBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        clickBtn.layer.cornerRadius = 5.0f;
        clickBtn.backgroundColor = WJColorNavigationBar;
        [clickBtn setTitleColor:WJColorWhite forState:UIControlStateNormal];
        clickBtn.titleLabel.font = WJFont14;
        clickBtn.frame = CGRectMake(kScreenWidth - ALD(92), ALD(17), ALD(80), ALD(30));
        [clickBtn addTarget:self action:@selector(clickAciton) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:clickBtn];
        
        bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(63.5), kScreenWidth, ALD(0.5))];
        bottomLine.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:bottomLine];
        
    }
    return self;
}

- (void)pushForMyBunsVC{
    if ([WJGlobalVariable sharedInstance].defaultPerson) {
        self.myBuns();
    }
}

- (void)clickAciton{
    if ([WJGlobalVariable sharedInstance].defaultPerson) {
        self.payBuns();
    }else{
        self.userLogin();
    }
}

- (void)configData:(NSString *)baoziCount isLogin:(BOOL)login{
    if ([WJGlobalVariable sharedInstance].defaultPerson) {
        [clickBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    }else{
        [clickBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    }
    if (login) {
//        clickBtn.titleLabel.text = @"立即充值";
        bunsCountL.text = [WJGlobalVariable changeMoneyString:baoziCount];
        CGFloat bunsCountLwidth = [UILabel getWidthWithTitle:bunsCountL.text font:bunsCountL.font];
        bunsCountL.frame = CGRectMake(bunsIV.right + ALD(12), ALD(20), bunsCountLwidth, ALD(27));
        
        bunsTitleL.text = @"个包子";
        CGFloat bunsTitleLwidth = [UILabel getWidthWithTitle:bunsTitleL.text font:bunsTitleL.font];
        bunsTitleL.frame = CGRectMake(bunsCountL.right + ALD(5), ALD(27), bunsTitleLwidth, ALD(17));
    }else{
//        clickBtn.titleLabel.text = @"立即登录";
        bunsCountL.text = @"";
        bunsTitleL.text = @"登录查看可用包子";
        
        bunsCountL.frame = CGRectMake(bunsIV.right + ALD(12), ALD(20), 0, ALD(27));
        
        CGFloat bunsTitleLwidth = [UILabel getWidthWithTitle:bunsTitleL.text font:bunsTitleL.font];
        bunsTitleL.frame = CGRectMake(bunsCountL.right, ALD(25), bunsTitleLwidth, ALD(17));
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
