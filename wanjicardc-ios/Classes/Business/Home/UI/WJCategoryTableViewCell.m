//
//  WJCategoryTableViewCell.m
//  WanJiCard
//
//  Created by silinman on 16/5/27.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCategoryTableViewCell.h"
#import "WJHomePageCategoriesModel.h"
#import <SDWebImage/UIButton+WebCache.h>

@implementation WJCategoryTableViewCell{
    UIView               *backView;
    UIView               *firstView;
    UIView               *secondView;
    UIView               *thirdView;
    UIView               *fourthView;
    UIButton             *typeIV_1;
    UIButton             *typeIV_2;
    UIButton             *typeIV_3;
    UIButton             *typeIV_4;
    UILabel              *foodL;
    UILabel              *beautyL;
    UILabel              *lifeL;
    UILabel              *shoppingL;
    UILabel              *bottomLine_1;
    UILabel              *bottomLine_2;
    NSMutableArray       *array;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = WJColorViewBg;
        
//        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(90))];
//        backView.backgroundColor = WJColorWhite;
//        [self.contentView addSubview:backView];
        
        firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/4, ALD(90))];
        firstView.backgroundColor = WJColorWhite;
        [self.contentView addSubview:firstView];
        
        secondView = [[UIView alloc] initWithFrame:CGRectMake(firstView.right, 0, kScreenWidth/4, ALD(90))];
        secondView.backgroundColor = WJColorWhite;
        [self.contentView addSubview:secondView];
        
        thirdView = [[UIView alloc] initWithFrame:CGRectMake(secondView.right, 0, kScreenWidth/4, ALD(90))];
        thirdView.backgroundColor = WJColorWhite;
        [self.contentView addSubview:thirdView];
        
        fourthView = [[UIView alloc] initWithFrame:CGRectMake(thirdView.right, 0, kScreenWidth/4, ALD(90))];
        fourthView.backgroundColor = WJColorWhite;
        [self.contentView addSubview:fourthView];
        //------美食
        
        typeIV_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        typeIV_1.backgroundColor = [UIColor clearColor];
        typeIV_1.frame = CGRectMake((kScreenWidth/4 - ALD(47))/2, ALD(12), ALD(47), ALD(47));
        typeIV_1.layer.cornerRadius = typeIV_1.width/2;
        typeIV_1.layer.masksToBounds = YES;
        [typeIV_1 setImage:[UIImage imageNamed:@"privilege_default"] forState:UIControlStateNormal];
        [typeIV_1 addTarget:self action:@selector(selectFood) forControlEvents:UIControlEventTouchUpInside];
        [firstView addSubview:typeIV_1];
        
        CGFloat labelY = typeIV_1.bottom + ALD(6);
        
        foodL = [[UILabel alloc] initWithFrame:CGRectMake(typeIV_1.x - ALD(20), labelY, ALD(87), ALD(15))];
        foodL.font = WJFont13;
        foodL.textAlignment = NSTextAlignmentCenter;
        foodL.textColor = WJColorDardGray6;
//        foodL.minimumScaleFactor = 0.8;
        [firstView addSubview:foodL];
        
        //------丽人
        typeIV_2 = [UIButton buttonWithType:UIButtonTypeCustom];
        typeIV_2.backgroundColor = [UIColor clearColor];
        typeIV_2.frame = CGRectMake((kScreenWidth/4 - ALD(47))/2, ALD(12), ALD(47), ALD(47));
        typeIV_2.layer.cornerRadius = typeIV_2.width/2;
        typeIV_2.layer.masksToBounds = YES;
        [typeIV_2 setImage:[UIImage imageNamed:@"privilege_default"] forState:UIControlStateNormal];
        [typeIV_2 addTarget:self action:@selector(selectBeauty) forControlEvents:UIControlEventTouchUpInside];
        [secondView addSubview:typeIV_2];
        
        beautyL = [[UILabel alloc] initWithFrame:CGRectMake(typeIV_2.x - ALD(20), labelY, ALD(87), ALD(15))];
        beautyL.font = WJFont13;
        beautyL.textAlignment = NSTextAlignmentCenter;
        beautyL.textColor = WJColorDardGray6;
        //        foodL.minimumScaleFactor = 0.8;
        [secondView addSubview:beautyL];
        
        //------生活
        typeIV_3 = [UIButton buttonWithType:UIButtonTypeCustom];
        typeIV_3.backgroundColor = [UIColor clearColor];
        typeIV_3.frame = CGRectMake((kScreenWidth/4 - ALD(47))/2, ALD(12), ALD(47), ALD(47));
        typeIV_3.layer.cornerRadius = typeIV_3.width/2;
        typeIV_3.layer.masksToBounds = YES;
        [typeIV_3 setImage:[UIImage imageNamed:@"privilege_default"] forState:UIControlStateNormal];
        [typeIV_3 addTarget:self action:@selector(selectLife) forControlEvents:UIControlEventTouchUpInside];
        [thirdView addSubview:typeIV_3];

        lifeL = [[UILabel alloc] initWithFrame:CGRectMake(typeIV_3.x - ALD(20), labelY, ALD(87), ALD(15))];
        lifeL.font = WJFont13;
        lifeL.textAlignment = NSTextAlignmentCenter;
        lifeL.textColor = WJColorDardGray6;
        //        foodL.minimumScaleFactor = 0.8;
        [thirdView addSubview:lifeL];
        
        //------购物
        typeIV_4 = [UIButton buttonWithType:UIButtonTypeCustom];
        typeIV_4.backgroundColor = [UIColor clearColor];
        typeIV_4.frame = CGRectMake((kScreenWidth/4 - ALD(47))/2, ALD(12), ALD(47), ALD(47));
        typeIV_4.layer.cornerRadius = typeIV_4.width/2;
        typeIV_4.layer.masksToBounds = YES;
        [typeIV_4 setImage:[UIImage imageNamed:@"privilege_default"] forState:UIControlStateNormal];
        [typeIV_4 addTarget:self action:@selector(selectShopping) forControlEvents:UIControlEventTouchUpInside];
        [fourthView addSubview:typeIV_4];
        
        shoppingL = [[UILabel alloc] initWithFrame:CGRectMake(typeIV_4.x - ALD(20), labelY, ALD(87), ALD(15))];
        shoppingL.font = WJFont13;
        shoppingL.textAlignment = NSTextAlignmentCenter;
        shoppingL.textColor = WJColorDardGray6;
        //        foodL.minimumScaleFactor = 0.8;
        [fourthView addSubview:shoppingL];
        
        //线
        bottomLine_1 = [[UILabel alloc] initWithFrame:CGRectMake(0, backView.bottom, kScreenWidth, ALD(0.5))];
        bottomLine_1.backgroundColor = WJColorDarkGrayLine;
        [self.contentView addSubview:bottomLine_1];
        
        bottomLine_2 = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(99.5), kScreenWidth, ALD(0.5))];
        bottomLine_2.backgroundColor = WJColorDarkGrayLine;
        [self.contentView addSubview:bottomLine_2];
        
        array = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}


- (void)selectFood{
    WJHomePageCategoriesModel *model = [array objectAtIndex:0];
    [kDefaultCenter postNotificationName:@"PushForCategoryVC" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:model.categoryId,@"key",model.name,@"name", nil]];
}
- (void)selectBeauty{
    WJHomePageCategoriesModel *model = [array objectAtIndex:1];
    [kDefaultCenter postNotificationName:@"PushForCategoryVC" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:model.categoryId,@"key",model.name,@"name", nil]];
}
- (void)selectLife{
    WJHomePageCategoriesModel *model = [array objectAtIndex:2];
    [kDefaultCenter postNotificationName:@"PushForCategoryVC" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:model.categoryId,@"key",model.name,@"name", nil]];
}
- (void)selectShopping{
    WJHomePageCategoriesModel *model = [array objectAtIndex:3];
    [kDefaultCenter postNotificationName:@"PushForCategoryVC" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:model.categoryId,@"key",model.name,@"name", nil]];
}

- (void)configData:(NSMutableArray *)dataArray{
    [array removeAllObjects];
    UIImage *defaultIcon = [UIImage imageNamed:@"privilege_default"];
    for (int i = 0; i < dataArray.count; i ++) {
        WJHomePageCategoriesModel *model = [dataArray objectAtIndex:i];
        [array addObject:model];
    }
    if (dataArray.count == 4 || dataArray.count > 4) {
        WJHomePageCategoriesModel *model_1 = [dataArray objectAtIndex:0];
        [typeIV_1 sd_setImageWithURL:[NSURL URLWithString:model_1.img] forState:UIControlStateNormal placeholderImage:defaultIcon];
        foodL.text = model_1.name;
        
        WJHomePageCategoriesModel *model_2 = [dataArray objectAtIndex:1];
        [typeIV_2 sd_setImageWithURL:[NSURL URLWithString:model_2.img] forState:UIControlStateNormal placeholderImage:defaultIcon];
        beautyL.text = model_2.name;
        
        WJHomePageCategoriesModel *model_3 = [dataArray objectAtIndex:2];
        [typeIV_3 sd_setImageWithURL:[NSURL URLWithString:model_3.img] forState:UIControlStateNormal placeholderImage:defaultIcon];
        lifeL.text = model_3.name;
        
        WJHomePageCategoriesModel *model_4 = [dataArray objectAtIndex:3];
        [typeIV_4 sd_setImageWithURL:[NSURL URLWithString:model_4.img] forState:UIControlStateNormal placeholderImage:defaultIcon];
        shoppingL.text = model_4.name;
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
