//
//  WJSafetyQuestionCell.m
//  WanJiCard
//
//  Created by 孙明月 on 16/1/7.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJSafetyQuestionCell.h"

@implementation WJSafetyQuestionCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.tipTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 61, 44)];
        self.tipTextLabel.text = @"答案:";
        self.tipTextLabel.font = WJFont15;
//        tipTextLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"2f333b"];
        [self.tipTextLabel sizeToFit];
        [self.tipTextLabel setFrame:CGRectMake(12, 0, self.tipTextLabel.frame.size.width, ALD(45))];
        
        CGSize  size = [@"问题三：" sizeWithAttributes:@{NSFontAttributeName:WJFont15} constrainedToSize:CGSizeMake(1000000, 44)];
        
        self.questionText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.tipTextLabel.frame) + size.width,0,kScreenWidth - CGRectGetMaxX(self.tipTextLabel.frame) - 12,ALD(43))];
        self.questionText.borderStyle = UITextBorderStyleNone;
        self.questionText.returnKeyType = UIReturnKeyDone;
        self.questionText.font = WJFont15;
        
        [self.contentView addSubview:self.tipTextLabel];
        [self.contentView addSubview:self.questionText];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
