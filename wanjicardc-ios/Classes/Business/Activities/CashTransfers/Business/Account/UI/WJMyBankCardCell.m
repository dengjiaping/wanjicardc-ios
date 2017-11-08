//
//  WJMyBankCardCell.m
//  WanJiCard
//
//  Created by reborn on 16/11/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJMyBankCardCell.h"

@implementation WJMyBankCardCell

{
    UIImageView *bankLogolImageView;
    UILabel     *bankNameL;
    UILabel     *cardTypeL;
    UILabel     *bankCardNumL;
    UILabel     *cardStatus;
    UIButton    *setReceiveCardBtn;
    UIButton    *deleteBtn;
    
    UIView      *middleLine;
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = WJColorViewBg2;
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(ALD(10), ALD(10), ALD(kScreenWidth - ALD(20)), ALD(140))];
        backView.layer.cornerRadius = 8;
        backView.backgroundColor = WJColorWhite;
        [self.contentView addSubview:backView];
        
        
        UIImage* bankLogoImage = [UIImage imageNamed:@"supportBankDefaultImage"];
        
        bankLogolImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(10), ALD(15), bankLogoImage.size.width, bankLogoImage.size.height)];
        bankLogolImageView.layer.cornerRadius = bankLogoImage.size.height/2;
        [backView addSubview:bankLogolImageView];
        
        
        bankNameL = [[UILabel alloc] initWithFrame:CGRectMake(bankLogolImageView.right+ ALD(15), ALD(15), ALD(80), ALD(20))];
        bankNameL.textColor = WJColorDarkGray;
        bankNameL.font = WJFont15;
        [backView addSubview:bankNameL];
        
        
        bankCardNumL = [[UILabel alloc] initWithFrame:CGRectMake(backView.width - ALD(10) - ALD(150),bankNameL.frame.origin.y, ALD(150), ALD(20))];
        bankCardNumL.textAlignment = NSTextAlignmentRight;
        bankCardNumL.textColor = WJColorDarkGray;
        bankCardNumL.font = WJFont15;
        [backView addSubview:bankCardNumL];
        
        cardTypeL = [[UILabel alloc] initWithFrame:CGRectMake(bankNameL.frame.origin.x, bankNameL.bottom + ALD(15), ALD(120), ALD(20))];
        cardTypeL.font = WJFont13;
        cardTypeL.textColor = WJColorDarkGray;
        [backView addSubview:cardTypeL];
        
        cardStatus = [[UILabel alloc] initWithFrame:CGRectMake(backView.width - ALD(10) - ALD(50), CGRectGetMinY(cardTypeL.frame), ALD(50), ALD(20))];
        cardStatus.text = @"已绑定";
        cardStatus.textAlignment = NSTextAlignmentRight;
        cardStatus.font = WJFont13;
        cardStatus.textColor = WJColorDardGray6;
        [backView addSubview:cardStatus];
        
        
        middleLine = [[UIView alloc] initWithFrame:CGRectMake(0, cardTypeL.bottom + ALD(15), kScreenWidth, ALD(0.5))];
        middleLine.backgroundColor = WJColorSeparatorLine;
        [backView addSubview:middleLine];
        
        
        setReceiveCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        setReceiveCardBtn.frame = CGRectMake(ALD(10), middleLine.bottom + ALD(10), ALD(90), ALD(30));
        [setReceiveCardBtn setTitle:@"设为收款卡" forState:UIControlStateNormal];
        [setReceiveCardBtn setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        setReceiveCardBtn.layer.cornerRadius = 8;
        setReceiveCardBtn.layer.borderColor = WJColorNavigationBar.CGColor;
        setReceiveCardBtn.layer.borderWidth = 0.5;
        setReceiveCardBtn.titleLabel.font = WJFont12;
        //        setReceiveCardBtn.userInteractionEnabled = NO;
        [setReceiveCardBtn addTarget:self action:@selector(setReceiveCardBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:setReceiveCardBtn];
        
        
        deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(backView.width - ALD(15) - ALD(30), middleLine.bottom + ALD(10), ALD(30), ALD(30));
        [deleteBtn setImage:[UIImage imageNamed:@"bankCardDelete"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:deleteBtn];
        
    }
    return self;
}

- (void)configDataWithModel:(WJBankCardModel *)model
{
    [bankLogolImageView sd_setImageWithURL:[NSURL URLWithString:model.bankLogol] placeholderImage:[UIImage imageNamed:@"supportBankDefaultImage"]];
    
    bankNameL.text = model.bankName;
    
    bankCardNumL.text = model.bankCardNumber;

//    NSRange trange = NSMakeRange(4, 8);
//    NSString *tBankCardNumStr = [model.bankCardNumber stringByReplacingCharactersInRange:trange withString:@"＊＊＊＊"];
////    NSString *strContent = [NSString stringWithFormat:@"已向您%@的手机发送验证码",tPhoneStr];
//    bankCardNumL.attributedText = [self attributedText:tBankCardNumStr];
    
    cardTypeL.text = model.bankCardType;
    
    if (model.isReceiveCard) {
        
        [setReceiveCardBtn setTitle:@"收款卡" forState:UIControlStateNormal];
        setReceiveCardBtn.backgroundColor = WJColorNavigationBar;
        [setReceiveCardBtn setTitleColor:WJColorWhite forState:UIControlStateNormal];
        setReceiveCardBtn.userInteractionEnabled = NO;
    } else {
        
        [setReceiveCardBtn setTitle:@"设为收款卡" forState:UIControlStateNormal];
        setReceiveCardBtn.backgroundColor = WJColorWhite;
        [setReceiveCardBtn setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        setReceiveCardBtn.userInteractionEnabled = YES;
    }
}

#pragma mark - action

- (void)setReceiveCardBtnAction:(id)sender
{
    self.bankCardSetting();
}

- (void)deleteBtnAction:(id)sender
{
    self.deleteCardBinding();
}

//- (NSAttributedString *)attributedText:(NSString *)text{
//    
//    NSMutableAttributedString *result = [[NSMutableAttributedString alloc]
//                                         initWithString:text];
//    NSDictionary *attributesForFirstWord = @{
//                                             NSFontAttributeName : WJFont15,
//                                             NSForegroundColorAttributeName : WJColorDarkGray,
//                                             };
//    
//    [result setAttributes:attributesForFirstWord
//                    range:NSMakeRange(0, 11)];
//    return [[NSAttributedString alloc] initWithAttributedString:result];
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
