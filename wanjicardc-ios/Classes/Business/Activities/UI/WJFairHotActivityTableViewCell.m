//
//  WJFairHotActivityTableViewCell.m
//  WanJiCard
//
//  Created by silinman on 16/8/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJFairHotActivityTableViewCell.h"
#import "WJClickImageView.h"
#import "WJFairActivityModel.h"

@implementation WJFairHotActivityTableViewCell


{
    WJClickImageView        *firstIV;
    WJClickImageView        *secondIV;
    UIImageView             *firstActIV;
    UIImageView             *secondActIV;
    UILabel                 *bottomLine;
    NSMutableArray          *array;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = WJColorWhite;
        
        firstIV = [[WJClickImageView alloc] initWithFrame:CGRectMake(ALD(12), ALD(12), kScreenWidth - ALD(24), ALD(130))];
        firstIV.userInteractionEnabled = YES;
        firstIV.layer.cornerRadius = 5.0f;
        firstIV.layer.masksToBounds = YES;
        firstIV.layer.borderWidth = 0.5;
        firstIV.layer.borderColor = [WJColorSeparatorLine CGColor];
        firstIV.image = [UIImage imageNamed:@"home_ad_default"];
        [firstIV addTarget:self action:@selector(selectFirstActivity)];
        [self.contentView addSubview:firstIV];
        
        firstActIV = [[UIImageView alloc] initWithFrame:CGRectMake(firstIV.width - ALD(54), 0, ALD(54), ALD(54))];
        [firstIV addSubview:firstActIV];
        
        secondIV = [[WJClickImageView alloc] initWithFrame:CGRectMake(ALD(12),firstIV.bottom + ALD(12), kScreenWidth - ALD(24), ALD(130))];
        secondIV.userInteractionEnabled = YES;
        secondIV.layer.cornerRadius = 5.0f;
        secondIV.layer.masksToBounds = YES;
        secondIV.layer.borderWidth = 0.5;
        secondIV.layer.borderColor = [WJColorSeparatorLine CGColor];
        secondIV.image = [UIImage imageNamed:@"home_ad_default"];
        [secondIV addTarget:self action:@selector(selectSecondActivity)];
        [self.contentView addSubview:secondIV];
        
        secondActIV = [[UIImageView alloc] initWithFrame:CGRectMake(secondIV.width - ALD(54), 0, ALD(54), ALD(54))];
        [secondIV addSubview:secondActIV];
        
        //线
        bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(299.5), kScreenWidth, ALD(0.5))];
        bottomLine.backgroundColor = WJColorDarkGrayLine;
        [self.contentView addSubview:bottomLine];
        
        
        

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
        WJFairActivityModel *model = [dataArray objectAtIndex:i];
        [array addObject:model];
    }
    
    WJFairActivityModel *model_1 = [dataArray objectAtIndex:0];
    [firstIV sd_setImageWithURL:[NSURL URLWithString:model_1.pcUrl]
               placeholderImage:[UIImage imageNamed:@"home_ad_default"]];
    if ([model_1.state isEqualToString:@""] || model_1.state == nil) {
        firstActIV.image = nil;
    }else{
        NSInteger status_1 = [model_1.state integerValue];
        switch (status_1) {
            case 0:
                firstActIV.image = [UIImage imageNamed:@"activity_new"];
                break;
            case 1:
                firstActIV.image = [UIImage imageNamed:@"activity_end"];
                break;
            default:
                break;
        }
    }

    if (dataArray.count > 1) {
        WJFairActivityModel *model_2 = [dataArray objectAtIndex:1];
        [secondIV sd_setImageWithURL:[NSURL URLWithString:model_2.pcUrl]
                    placeholderImage:[UIImage imageNamed:@"home_ad_default"]];
        bottomLine.frame = CGRectMake(0, ALD(299.5), kScreenWidth, ALD(0.5));
        
        
        if ([model_2.state isEqualToString:@""] || model_2.state == nil) {
            secondActIV.image = nil;
        }else{
            NSInteger status_2 = [model_2.state integerValue];
            switch (status_2) {
                case 0:
                    secondActIV.image = [UIImage imageNamed:@"activity_new"];
                    break;
                case 1:
                    secondActIV.image = [UIImage imageNamed:@"activity_end"];
                    break;
                default:
                    break;
            }
        }

    }else{
        bottomLine.frame = CGRectMake(0, ALD(154.5), kScreenWidth, ALD(0.5));
    }


}

- (void)selectFirstActivity{
    WJFairActivityModel *model = [array objectAtIndex:0];
    self.selectActivityBlock(model.linkUrl,model.name);
}

- (void)selectSecondActivity{
    WJFairActivityModel *model = [array objectAtIndex:1];
    self.selectActivityBlock(model.linkUrl,model.name);
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
