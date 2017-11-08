//
//  WJCardDetailAllPrivilegeCell.m
//  WanJiCard
//
//  Created by Harry Hu on 15/9/7.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJCardDetailAllPrivilegeCell.h"

@implementation WJCardDetailAllPrivilegeCell{
    UIImageView *iconIV;
    UILabel *nameL;
    UILabel *conditionL;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(10), ALD(12), ALD(35), ALD(35))];
        iconIV.contentMode = UIViewContentModeScaleAspectFit;
        iconIV.layer.cornerRadius = 3;
        iconIV.backgroundColor = WJColorViewBg;
        [self.contentView addSubview:iconIV];
        
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(iconIV.right + ALD(15), 0, kScreenWidth - ALD(70), ALD(20))];
        nameL.centerY = ALD(20);
        nameL.font = WJFont14;
        nameL.textColor = WJColorDardGray3;
        nameL.minimumScaleFactor = 0.8;
        [self.contentView addSubview:nameL];
        
        conditionL = [[UILabel alloc] initWithFrame:CGRectMake(nameL.x, 0, nameL.width, ALD(35))];
        conditionL.centerY = ALD(45);
        conditionL.font = WJFont13;
        conditionL.textColor = WJColorDardGray9;
        conditionL.numberOfLines = 0;
        conditionL.minimumScaleFactor = 0.8;
        [self.contentView addSubview:conditionL];
    }
    return self;
}


- (void)configData:(PayPrivilegeModel *)model{
    
    [iconIV sd_setImageWithURL:[NSURL URLWithString:model.privilegePic]
              placeholderImage:[UIImage imageNamed:@"topic_default"]];
    
    nameL.text = model.privilegeName;
    conditionL.text = model.merchantPrivilegeDes;
    
    
//    if (model.isOwn) {
//        conditionL.hidden = YES;
//        nameL.centerY = iconIV.centerY;
//    }else{
//        conditionL.hidden = NO;
//        nameL.centerY = ALD(23);
//    }
    
    
}


@end
