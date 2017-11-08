//
//  WJFitStoreCell.m
//  WanJiCard
//
//  Created by Harry Hu on 15/9/6.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJCardDetailFitStoreCell.h"
#import "WJStoreModel.h"


@implementation WJCardDetailFitStoreCell{
    UIImageView     *iconIV;
    UILabel         *nameL;
    UILabel         *shopL;
    UILabel         *addressL;
    UILabel         *soldL;
    UILabel         *distanceLabel;
    UIImageView     *locationIV;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), ALD(94.5), kScreenWidth - ALD(24), ALD(0.5))];
        topLine.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:topLine];
        
        iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), ALD(15), ALD(90), ALD(65))];
        [self.contentView addSubview:iconIV];
        
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(iconIV.right + ALD(14), ALD(15), kScreenWidth- 30 - ALD(90), ALD(17))];
        nameL.font = WJFont15;
        nameL.textColor = WJColorDarkGray;
        [self.contentView addSubview:nameL];
        
        shopL = [[UILabel alloc] initWithFrame:CGRectMake(nameL.right + ALD(5), ALD(15), kScreenWidth - nameL.right - ALD(5) - ALD(12), ALD(16))];
        shopL.font = WJFont14;
        shopL.textColor = WJColorLightGray;
        [self.contentView addSubview:shopL];
        
        addressL = [[UILabel alloc] initWithFrame:CGRectMake(iconIV.right + ALD(14), nameL.bottom+2, kScreenWidth- 30-ALD(90), 20)];
        addressL.font = WJFont12;
        addressL.textColor = WJColorLightGray;
        [self.contentView addSubview:addressL];
        
        soldL = [[UILabel alloc] initWithFrame:CGRectMake(iconIV.right + ALD(14), addressL.bottom+2, kScreenWidth- 30-ALD(90), 20)];
        soldL.font = WJFont12;
        soldL.textColor = WJColorLightGray;
        [self.contentView addSubview:soldL];
        
        distanceLabel = [[UILabel alloc] init];
        distanceLabel.textColor = WJColorLightGray;
        distanceLabel.font = WJFont12;
        distanceLabel.textAlignment = NSTextAlignmentRight;
        distanceLabel.hidden = YES;
        [self.contentView addSubview:distanceLabel];
        
        locationIV = [[UIImageView alloc] init];
        locationIV.hidden = YES;
        locationIV.image = [UIImage imageNamed:@"Details_icon_distance_dis"];
        [self.contentView addSubview:locationIV];
    }
    return self;
}

- (void)setStore:(WJStoreModel *)store{

    _store = store;
    
    //图
    NSString *imageUrl = ClippingCenterImageUrl(store.storeCover, ALD(90), ALD(65));
    [iconIV sd_setImageWithURL:[NSURL URLWithString:imageUrl]
              placeholderImage:[UIImage imageNamed:@"merchant_list_default"]];
    
    //商家名
    NSArray *array_1 = [store.storeName componentsSeparatedByString:@"("];
    NSArray *array_2 = [store.storeName componentsSeparatedByString:@"（"];
    if (array_1.count > 1 || array_2.count > 1) {
        if (array_1.count > 1) {
            NSString *shopTitleStr = [array_1 objectAtIndex:0];
            nameL.text = shopTitleStr;
            CGFloat width = [UILabel getWidthWithTitle:nameL.text font:nameL.font];
            nameL.frame = CGRectMake(iconIV.right + ALD(14), ALD(15), width, ALD(17));
            //店名
            NSString *shopNameStr = [NSString stringWithFormat:@"(%@",[array_1 objectAtIndex:1]];
            shopL.text = shopNameStr;
            CGFloat shopwidth = [UILabel getWidthWithTitle:shopL.text font:shopL.font];
            shopL.frame = CGRectMake(nameL.right, ALD(15), shopwidth, ALD(16));
        }else{
            NSString *shopTitleStr = [array_2 objectAtIndex:0];
            nameL.text = shopTitleStr;
            CGFloat width = [UILabel getWidthWithTitle:nameL.text font:nameL.font];
            nameL.frame = CGRectMake(iconIV.right + ALD(14), ALD(15), width, ALD(17));
            //店名
            NSString *shopNameStr = [NSString stringWithFormat:@"（%@",[array_2 objectAtIndex:1]];
            shopL.text = shopNameStr;
            CGFloat shopwidth = [UILabel getWidthWithTitle:shopL.text font:shopL.font];
            shopL.frame = CGRectMake(nameL.right, ALD(15), shopwidth, ALD(16));
        }
    }else{
        nameL.text = store.storeName;
    }

    //地址
    addressL.text = [NSString stringWithFormat:@"地址：%@",store.storeAddress];
    CGFloat addresswidth = [UILabel getWidthWithTitle:addressL.text font:addressL.font];
    if (addresswidth > kScreenWidth - iconIV.right - ALD(24)) {
        addresswidth = kScreenWidth - iconIV.right - ALD(24);
    }
    addressL.frame = CGRectMake(nameL.x, nameL.bottom + ALD(11), addresswidth, ALD(14));
    
    //已售
    soldL.text = [NSString stringWithFormat:@"已售 %ld",(long)store.storeTotalSale];
    CGFloat soldwidth = [UILabel getWidthWithTitle:soldL.text font:soldL.font];
    soldL.frame = CGRectMake(nameL.x, addressL.bottom + ALD(11), soldwidth, ALD(14));
    
    
    
    CGSize distanceSize = [store.distanceStr boundingRectWithSize:CGSizeMake(10000000, ALD(20))
                                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                       attributes:[NSDictionary dictionaryWithObjectsAndKeys:distanceLabel.font,NSFontAttributeName, nil]
                                                          context:nil].size;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        
        self.isOpenLocation = NO;
        
    }else{
        self.isOpenLocation = YES;
    }
    
    if (self.isOpenLocation) {
        
        if (store.distanceStr.length != 0 && store.distanceStr != nil) {
            
            distanceLabel.hidden = NO;
            locationIV.hidden = NO;
            
            distanceLabel.frame = CGRectMake(kScreenWidth - ALD(12)- distanceSize.width, CGRectGetMaxY(addressL.frame)+ ALD(11.5), distanceSize.width, ALD(20));
            locationIV.frame = CGRectMake(CGRectGetMinX(distanceLabel.frame)- ALD(13)-ALD(5), CGRectGetMaxY(addressL.frame)+ ALD(15), ALD(13), ALD(13));
            
            distanceLabel.text = store.distanceStr;
            
        } else {
            
            distanceLabel.hidden = YES;
            locationIV.hidden = YES;
        }
    } else {
        
        distanceLabel.hidden = YES;
        locationIV.hidden = YES;
    }
    
}

@end
