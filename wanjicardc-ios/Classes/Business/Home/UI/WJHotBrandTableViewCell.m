//
//  WJHotBrandTableViewCell.m
//  WanJiCard
//
//  Created by silinman on 16/5/27.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJHotBrandTableViewCell.h"
#import "WJClickImageView.h"
#import "WJMoreBrandesModel.h"

@implementation WJHotBrandTableViewCell{
    UIView               *backView;
    UILabel              *titleL;
    UILabel              *moreL;
    UIImageView          *arrowIV;
    UIButton             *moreBtn;
    UIImageView          *first_IV;
    UIImageView          *second_IV;
    UIImageView          *third_IV;
    UIImageView          *fourth_IV;
    UIImageView          *first_V;
    UIImageView          *second_V;
    UIImageView          *third_V;
    UIImageView          *fourth_V;
    WJClickImageView     *firstIV;
    WJClickImageView     *secondIV;
    WJClickImageView     *thirdIV;
    WJClickImageView     *fourthIV;
    UILabel              *firstL;
    UILabel              *secondL;
    UILabel              *thirdL;
    UILabel              *fourthL;
    UILabel              *topLine_1;
    UILabel              *topLine_2;
    UILabel              *bottomLine_1;
    UILabel              *bottomLine_2;
    NSMutableArray       *array;
    CGFloat              alpha;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = WJColorViewBg;
        alpha = 0.4;
        
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(0), kScreenWidth, ALD(120))];
        backView.backgroundColor = WJColorWhite;
        [self.contentView addSubview:backView];
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(15), ALD(80), ALD(17))];
        titleL.font = WJFont14;
        titleL.textAlignment = NSTextAlignmentLeft;
        titleL.textColor = WJColorDarkGray;
        titleL.text = @"热门品牌";
        [backView addSubview:titleL];
        
        arrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(6) - ALD(12), ALD(18), ALD(6), ALD(11))];
        arrowIV.image = [UIImage imageNamed:@"home_rightArrowsIcon"];
        [backView addSubview:arrowIV];
        
        moreL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(65), ALD(15), ALD(40), ALD(17))];
        moreL.font = WJFont13;
        moreL.textAlignment = NSTextAlignmentRight;
        moreL.textColor = WJColorLightGray;
        moreL.text = @"更多";
        [backView addSubview:moreL];
        
        moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.backgroundColor = [UIColor clearColor];
        moreBtn.frame = CGRectMake(kScreenWidth - ALD(120), 0, ALD(120), ALD(35));
        [moreBtn addTarget:self action:@selector(pushMoreHotBrand) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:moreBtn];
        
        //------first
        first_IV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), ALD(45), ALD(80), ALD(45))];
        first_IV.layer.cornerRadius = 3.0f;
        first_IV.layer.masksToBounds = YES;
        first_IV.contentMode = UIViewContentModeScaleToFill;
//        first_IV.image = [UIImage imageNamed:@"home_brand_default"];
        first_IV.hidden = YES;
        [backView addSubview:first_IV];
        
        first_V = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), ALD(45), ALD(80), ALD(45))];
//        first_V.backgroundColor = WJColorBlack;
        first_V.image = [UIImage imageNamed:@"maoboli"];
        first_V.layer.cornerRadius = 3.0f;
        first_V.layer.masksToBounds = YES;
//        first_V.alpha = alpha;
        first_V.hidden = YES;
        [backView addSubview:first_V];
        
        firstIV = [[WJClickImageView alloc] initWithFrame:CGRectMake(ALD(24.5), ALD(50), ALD(55), ALD(35))];
        firstIV.userInteractionEnabled = YES;
        firstIV.layer.cornerRadius = 3.0f;
        firstIV.layer.masksToBounds = YES;
        firstIV.contentMode = UIViewContentModeScaleAspectFit;
        firstIV.hidden = YES;
        [firstIV addTarget:self action:@selector(selectFirstBrand)];
        [backView addSubview:firstIV];
        
        firstL = [[UILabel alloc] initWithFrame:CGRectMake(first_IV.x, first_IV.bottom + ALD(5), ALD(80), ALD(13))];
        firstL.font = WJFont10;
        firstL.textColor = WJColorDarkGray;
        firstL.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:firstL];
        
        //------second
        second_IV = [[UIImageView alloc] initWithFrame:CGRectMake(first_IV.right + ALD(10), ALD(45), ALD(80), ALD(45))];
        second_IV.layer.cornerRadius = 3.0f;
        second_IV.layer.masksToBounds = YES;
        second_IV.hidden = YES;
        second_IV.contentMode = UIViewContentModeScaleToFill;
//        second_IV.image = [UIImage imageNamed:@"home_brand_default"];
        [backView addSubview:second_IV];
        
        second_V = [[UIImageView alloc] initWithFrame:CGRectMake(first_IV.right + ALD(10), ALD(45), ALD(80), ALD(45))];
//        second_V.backgroundColor = WJColorBlack;
        second_V.image = [UIImage imageNamed:@"maoboli"];
        second_V.layer.cornerRadius = 3.0f;
        second_V.layer.masksToBounds = YES;
//        second_V.alpha = alpha;
        second_V.hidden = YES;
        [backView addSubview:second_V];
        
        secondIV = [[WJClickImageView alloc] initWithFrame:CGRectMake(first_IV.right + ALD(22.5), ALD(50), ALD(55), ALD(35))];
        secondIV.userInteractionEnabled = YES;
        secondIV.layer.cornerRadius = 3.0f;
        secondIV.layer.masksToBounds = YES;
        secondIV.hidden = YES;
        secondIV.contentMode = UIViewContentModeScaleAspectFit;
        [secondIV addTarget:self action:@selector(selectSecondBrand)];
        [backView addSubview:secondIV];
        
        secondL = [[UILabel alloc] initWithFrame:CGRectMake(second_IV.x, second_IV.bottom + ALD(5), ALD(80), ALD(13))];
        secondL.font = WJFont10;
        secondL.textColor = WJColorDarkGray;
        secondL.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:secondL];
        
        //------third
        third_IV = [[UIImageView alloc] initWithFrame:CGRectMake(second_IV.right + ALD(10), ALD(45), ALD(80), ALD(45))];
        third_IV.layer.cornerRadius = 3.0f;
        third_IV.layer.masksToBounds = YES;
        third_IV.hidden = YES;
        third_IV.contentMode = UIViewContentModeScaleToFill;
//        third_IV.image = [UIImage imageNamed:@"home_brand_default"];
        [backView addSubview:third_IV];
        
        third_V = [[UIImageView alloc] initWithFrame:CGRectMake(second_IV.right + ALD(10), ALD(45), ALD(80), ALD(45))];
//        third_V.backgroundColor = WJColorBlack;
        third_V.image = [UIImage imageNamed:@"maoboli"];
        third_V.layer.cornerRadius = 3.0f;
        third_V.layer.masksToBounds = YES;
//        third_V.alpha = alpha;
        third_V.hidden = YES;
        [backView addSubview:third_V];
        
        thirdIV = [[WJClickImageView alloc] initWithFrame:CGRectMake(second_IV.right + ALD(22.5), ALD(50), ALD(55), ALD(35))];
        thirdIV.userInteractionEnabled = YES;
        thirdIV.layer.cornerRadius = 3.0f;
        thirdIV.layer.masksToBounds = YES;
        thirdIV.contentMode = UIViewContentModeScaleAspectFit;
        thirdIV.hidden = YES;
        [thirdIV addTarget:self action:@selector(selectThirdBrand)];
        [backView addSubview:thirdIV];
        
        thirdL = [[UILabel alloc] initWithFrame:CGRectMake(third_IV.x, third_IV.bottom + ALD(5), ALD(80), ALD(13))];
        thirdL.font = WJFont10;
        thirdL.textColor = WJColorDarkGray;
        thirdL.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:thirdL];
        
        //------fourth
        fourth_IV = [[UIImageView alloc] initWithFrame:CGRectMake(third_IV.right + ALD(10), ALD(45), ALD(80), ALD(45))];
        fourth_IV.layer.cornerRadius = 3.0f;
        fourth_IV.layer.masksToBounds = YES;
        fourth_IV.contentMode = UIViewContentModeScaleToFill;
//        fourth_IV.image = [UIImage imageNamed:@"home_brand_default"];
        fourth_IV.hidden = YES;
        [backView addSubview:fourth_IV];
        
        fourth_V = [[UIImageView alloc] initWithFrame:CGRectMake(third_IV.right + ALD(10), ALD(45), ALD(80), ALD(45))];
//        fourth_V.backgroundColor = WJColorBlack;
        fourth_V.image = [UIImage imageNamed:@"maoboli"];
        fourth_V.layer.cornerRadius = 3.0f;
        fourth_V.layer.masksToBounds = YES;
//        fourth_V.alpha = alpha;
        fourth_V.hidden = YES;
        [backView addSubview:fourth_V];
        
        fourthIV = [[WJClickImageView alloc] initWithFrame:CGRectMake(third_IV.right + ALD(22.5), ALD(50), ALD(55), ALD(35))];
        fourthIV.userInteractionEnabled = YES;
        fourthIV.layer.cornerRadius = 3.0f;
        fourthIV.layer.masksToBounds = YES;
        fourthIV.hidden = YES;
        fourthIV.contentMode = UIViewContentModeScaleAspectFit;
        [fourthIV addTarget:self action:@selector(selectFourthBrand)];
        [backView addSubview:fourthIV];
        
        fourthL = [[UILabel alloc] initWithFrame:CGRectMake(fourth_IV.x, fourth_IV.bottom + ALD(5), ALD(80), ALD(13))];
        fourthL.font = WJFont10;
        fourthL.textColor = WJColorDarkGray;
        fourthL.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:fourthL];
        
        
        //线
        
        bottomLine_1 = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(120), kScreenWidth, ALD(0.5))];
        bottomLine_1.backgroundColor = WJColorDarkGrayLine;
        [self.contentView addSubview:bottomLine_1];
        
        bottomLine_2 = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(129.5), kScreenWidth, ALD(0.5))];
        bottomLine_2.backgroundColor = WJColorDarkGrayLine;
        [self.contentView addSubview:bottomLine_2];
        
        array = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
//更多热门品牌
- (void)pushMoreHotBrand{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushForHotBrandVC" object:nil];
}

- (void)selectFirstBrand{
    WJMoreBrandesModel *model = [array objectAtIndex:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushForHotBrandShopVC" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:model.name,@"name",model.merchantAccountId,@"merchantAccountId", nil]];
}
- (void)selectSecondBrand{
    WJMoreBrandesModel *model = [array objectAtIndex:1];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushForHotBrandShopVC" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:model.name,@"name",model.merchantAccountId,@"merchantAccountId", nil]];
}
- (void)selectThirdBrand{
    WJMoreBrandesModel *model = [array objectAtIndex:2];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushForHotBrandShopVC" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:model.name,@"name",model.merchantAccountId,@"merchantAccountId", nil]];
}
- (void)selectFourthBrand{
    WJMoreBrandesModel *model = [array objectAtIndex:3];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushForHotBrandShopVC" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:model.name,@"name",model.merchantAccountId,@"merchantAccountId", nil]];
}
//
//- (void)configData:(NSMutableArray *)dataArray{
//    [array removeAllObjects];
//    for (int i = 0; i < dataArray.count; i ++) {
//        WJMoreBrandesModel *model = [dataArray objectAtIndex:i];
//        [array addObject:model];
//    }
//    if (dataArray.count == 4 || dataArray.count > 4) {
//        WJMoreBrandesModel *model_1 = [dataArray objectAtIndex:0];
//        [first_IV sd_setImageWithURL:[NSURL URLWithString:model_1.brandPhotoUrl] placeholderImage:[UIImage imageNamed:@"home_brand_default"]];
//        [firstIV sd_setImageWithURL:[NSURL URLWithString:model_1.logoUrl] placeholderImage:nil];
//        firstL.text = model_1.name;
//
//        WJMoreBrandesModel *model_2 = [dataArray objectAtIndex:1];
//        [second_IV sd_setImageWithURL:[NSURL URLWithString:model_2.brandPhotoUrl] placeholderImage:[UIImage imageNamed:@"home_brand_default"]];
//        [secondIV sd_setImageWithURL:[NSURL URLWithString:model_2.logoUrl] placeholderImage:nil];
//        secondL.text = model_2.name;
//        
//        WJMoreBrandesModel *model_3 = [dataArray objectAtIndex:2];
//        [third_IV sd_setImageWithURL:[NSURL URLWithString:model_3.brandPhotoUrl] placeholderImage:[UIImage imageNamed:@"home_brand_default"]];
//        [thirdIV sd_setImageWithURL:[NSURL URLWithString:model_3.logoUrl] placeholderImage:nil];
//        thirdL.text = model_3.name;
//        
//        WJMoreBrandesModel *model_4 = [dataArray objectAtIndex:3];
//        [fourth_IV sd_setImageWithURL:[NSURL URLWithString:model_4.brandPhotoUrl] placeholderImage:[UIImage imageNamed:@"home_brand_default"]];
//        [fourthIV sd_setImageWithURL:[NSURL URLWithString:model_4.logoUrl] placeholderImage:nil];
//        fourthL.text = model_4.name;
//    }
//}
- (void)configData:(NSMutableArray *)dataArray{
    
    [array removeAllObjects];
    for (int i = 0; i < dataArray.count; i ++) {
        WJMoreBrandesModel *model = [dataArray objectAtIndex:i];
        [array addObject:model];
    }
    if (dataArray.count == 4 || dataArray.count > 4) {
        
        [self configFirstData:dataArray];
        [self configSecondData:dataArray];
        [self configThirdData:dataArray];
        [self configFourData:dataArray];
        
    }
    if (dataArray.count > 0 && dataArray.count < 4) {
        
        if (dataArray.count == 1) {
            
            [self configFirstData:dataArray];
            
        } else if (dataArray.count == 2) {
            
            [self configFirstData:dataArray];
            [self configSecondData:dataArray];
            
        } else if (dataArray.count == 3) {
            
            [self configFirstData:dataArray];
            [self configSecondData:dataArray];
            [self configThirdData:dataArray];
        }
    }
}

- (void)configFirstData:(NSMutableArray *)dataArray
{
    first_IV.hidden = NO;
    firstIV.hidden = NO;
    
    WJMoreBrandesModel *model_1 = [dataArray objectAtIndex:0];
    if (model_1.brandType == 1) {
        [first_IV sd_setImageWithURL:[NSURL URLWithString:model_1.brandPhotoUrl] placeholderImage:[UIImage imageNamed:@"home_brand_default"]];
        first_V.hidden = NO;
        
    } else {
        first_IV.backgroundColor = [WJUtilityMethod colorWithHexColorString:model_1.color];
        first_V.hidden = YES;
        
    }
    [firstIV sd_setImageWithURL:[NSURL URLWithString:model_1.logoUrl] placeholderImage:nil];
    firstL.text = model_1.name;
}

- (void)configSecondData:(NSMutableArray *)dataArray
{
    second_IV.hidden = NO;
    secondIV.hidden = NO;
    
    WJMoreBrandesModel *model_2 = [dataArray objectAtIndex:1];
    
    if (model_2.brandType == 1) {
        [second_IV sd_setImageWithURL:[NSURL URLWithString:model_2.brandPhotoUrl] placeholderImage:[UIImage imageNamed:@"home_brand_default"]];
        second_V.hidden = NO;
        
    } else {
        second_IV.backgroundColor = [WJUtilityMethod colorWithHexColorString:model_2.color];
        second_V.hidden = YES;
        
    }
    [secondIV sd_setImageWithURL:[NSURL URLWithString:model_2.logoUrl] placeholderImage:nil];
    secondL.text = model_2.name;
}


- (void)configThirdData:(NSMutableArray *)dataArray
{
    third_IV.hidden = NO;
    thirdIV.hidden = NO;
    
    WJMoreBrandesModel *model_3 = [dataArray objectAtIndex:2];
    
    if (model_3.brandType == 1) {
        [third_IV sd_setImageWithURL:[NSURL URLWithString:model_3.brandPhotoUrl] placeholderImage:[UIImage imageNamed:@"home_brand_default"]];
        third_V.hidden = NO;
        
    } else {
        third_IV.backgroundColor = [WJUtilityMethod colorWithHexColorString:model_3.color];
        third_V.hidden = YES;
        
    }
    
    [thirdIV sd_setImageWithURL:[NSURL URLWithString:model_3.logoUrl] placeholderImage:nil];
    thirdL.text = model_3.name;
}

- (void)configFourData:(NSMutableArray *)dataArray
{
    fourth_IV.hidden = NO;
    fourthIV.hidden = NO;
    
    WJMoreBrandesModel *model_4 = [dataArray objectAtIndex:3];
    
    if (model_4.brandType == 1) {
        [fourth_IV sd_setImageWithURL:[NSURL URLWithString:model_4.brandPhotoUrl] placeholderImage:[UIImage imageNamed:@"home_brand_default"]];
        fourth_V.hidden = NO;
        
    } else {
        fourth_IV.backgroundColor = [WJUtilityMethod colorWithHexColorString:model_4.color];
        fourth_V.hidden = YES;
        
    }
    
    [fourthIV sd_setImageWithURL:[NSURL URLWithString:model_4.logoUrl] placeholderImage:nil];
    fourthL.text = model_4.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
