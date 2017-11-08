//
//  WJActivityTableViewCell.m
//  WanJiCard
//
//  Created by silinman on 16/5/27.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJActivityTableViewCell.h"
#import "WJClickImageView.h"
#import "WJHomePageCityActivityModel.h"
#import "WJHomePageActivitiesModel.h"


@implementation WJActivityTableViewCell{
    UIView              *backView;
    WJClickImageView    *picIV_1;
    WJClickImageView    *picIV_2;
    UILabel             *bottomLine_1;
    UILabel             *bottomLine_2;
    UILabel             *middleLine;
    NSMutableArray      *array;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = WJColorViewBg;
        
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(90))];
        backView.backgroundColor = WJColorWhite;
        [self.contentView addSubview:backView];
        
        picIV_1 = [[WJClickImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2 - ALD(1), ALD(90))];
        picIV_1.userInteractionEnabled = YES;
        picIV_1.image = [UIImage imageNamed:@"home_ad_default"];
        [picIV_1 addTarget:self action:@selector(selectFirstActivity)];
        [backView addSubview:picIV_1];
        
        middleLine = [[UILabel alloc] initWithFrame:CGRectMake(picIV_1.right, ALD(20), ALD(0.5), ALD(50))];
        middleLine.backgroundColor = WJColorSeparatorLine;
        [backView addSubview:middleLine];
        
        picIV_2 = [[WJClickImageView alloc] initWithFrame:CGRectMake(middleLine.right, 0, kScreenWidth/2, ALD(90))];
        picIV_2.userInteractionEnabled = YES;
        picIV_2.image = [UIImage imageNamed:@"home_ad_default"];
        [picIV_2 addTarget:self action:@selector(selectSecondActivity)];
        [backView addSubview:picIV_2];
        
        //线
        bottomLine_1 = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(90), kScreenWidth, ALD(0.5))];
        bottomLine_1.backgroundColor = WJColorDarkGrayLine;
        [self.contentView addSubview:bottomLine_1];
        
        bottomLine_2 = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(99.5), kScreenWidth, ALD(0.5))];
        bottomLine_2.backgroundColor = WJColorDarkGrayLine;
        [self.contentView addSubview:bottomLine_2];
        
        array = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}
- (void)configData:(NSMutableArray *)dataArray{
    if (dataArray.count == 0) {
        return;
    }
    [array removeAllObjects];
    for (int i = 0; i < dataArray.count; i ++) {
        WJHomePageActivitiesModel *model = [dataArray objectAtIndex:i];
        [array addObject:model];
    }
    WJHomePageActivitiesModel *model_1 = [dataArray objectAtIndex:0];
    [picIV_1 sd_setImageWithURL:[NSURL URLWithString:model_1.img]
               placeholderImage:[UIImage imageNamed:@"home_ad_default"]];
    
    WJHomePageActivitiesModel *model_2 = [dataArray objectAtIndex:1];
    [picIV_2 sd_setImageWithURL:[NSURL URLWithString:model_2.img]
               placeholderImage:[UIImage imageNamed:@"home_ad_default"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)selectFirstActivity{
    if (array.count > 0) {
        WJHomePageActivitiesModel *model = [array objectAtIndex:0];
        [kDefaultCenter postNotificationName:@"PushForWebVC"
                                  object:nil
                                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:model.url,@"url",model.activityName,@"name",model.activityType,@"type",model.merchantName,@"merchantName",model.brandName,@"brandName",model.merchantAccountId,@"merchantAccountId",model.merchantId,@"merchantId",model.isLogin,@"isLogin", nil]];
    }
}
- (void)selectSecondActivity{
    if (array.count > 1) {
        WJHomePageActivitiesModel *model = [array objectAtIndex:1];
        [kDefaultCenter postNotificationName:@"PushForWebVC"
                                      object:nil
                                    userInfo:[NSDictionary dictionaryWithObjectsAndKeys:model.url,@"url",model.activityName,@"name",model.activityType,@"type",model.merchantName,@"merchantName",model.brandName,@"brandName",model.merchantAccountId,@"merchantAccountId",model.merchantId,@"merchantId",model.isLogin,@"isLogin", nil]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
