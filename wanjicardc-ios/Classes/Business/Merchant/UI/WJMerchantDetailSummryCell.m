//
//  WJMerchantDetailNameCell.m
//  WanJiCard
//
//  Created by Angie on 15/9/25.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJMerchantDetailSummryCell.h"
#import "WJMerchantDetailModel.h"
#import "WJSystemAlertView.h"
#import "UIButton+WebCache.h"
#import "WJShopPicturesViewController.h"
#import "WJButton.h"

@interface WJMerchantDetailSummryCell()<WJSystemAlertViewDelegate, UIScrollViewDelegate>

@end

@implementation WJMerchantDetailSummryCell{
    UIScrollView            *imageScrollView;
    UIPageControl           *pageC;
    UILabel                 *nameL;
    UILabel                 *shopL;
    UILabel                 *salesPromotionL;
    UILabel                 *businessL;
    UILabel                 *activityL;
    UILabel                 *addressL;
    UILabel                 *phoneL;
    NSMutableArray          *picIVs;
    NSString                *phone;
    UILabel                 *photoNumL;
    WJMerchantDetailModel   *detailModel;
    UIButton                *locationBtn;
    UIButton                *teleBtn;
    UILabel                 *line1;
    UILabel                 *line2;
    UILabel                 *line3;
    UILabel                 *countL;
    UIImageView             *countBackIV;
    UIView                  *tapBackView;
    UIImage *image;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        picIVs = [NSMutableArray array];
        
        imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(236))];
        imageScrollView.showsHorizontalScrollIndicator = NO;
        imageScrollView.pagingEnabled = YES;
        imageScrollView.delegate = self;
        [self.contentView addSubview:imageScrollView];
        
        countBackIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, ALD(193), kScreenWidth, ALD(43))];
        countBackIV.image = [UIImage imageNamed:@"shop_picBottomShadow"];
        [self.contentView addSubview:countBackIV];
        
        countL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(13) , kScreenWidth - ALD(12) - ALD(12), ALD(18))];
        countL.textAlignment = NSTextAlignmentRight;
        countL.textColor = WJColorWhite;
        countL.font = WJFont14;
        [countBackIV addSubview:countL];
        
        pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(10, ALD(214), 300, 20)];
        pageC.currentPageIndicatorTintColor = [UIColor clearColor];
        pageC.pageIndicatorTintColor = [UIColor clearColor];
        [self.contentView addSubview:pageC];
        
        //商家
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(250), ALD(250), ALD(18))];
        nameL.textAlignment = NSTextAlignmentLeft;
        nameL.textColor = WJColorDarkGray;
        nameL.font = WJFont16;
        [self.contentView addSubview:nameL];
        
        //店名
        shopL = [[UILabel alloc] initWithFrame:CGRectMake(nameL.right + ALD(5), ALD(250), ALD(100), ALD(17))];
        shopL.textAlignment = NSTextAlignmentLeft;
        shopL.font = WJFont15;
        shopL.textColor = WJColorLightGray;
        [self.contentView addSubview:shopL];
        
        //营业时间
        businessL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), nameL.bottom + ALD(12), kScreenWidth - ALD(24), ALD(14))];
        businessL.textAlignment = NSTextAlignmentLeft;
        businessL.font = WJFont12;
        businessL.textColor = WJColorLightGray;
        [self.contentView addSubview:businessL];
        
        //活动
        activityL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), businessL.bottom + ALD(12), ALD(32), ALD(16))];
        activityL.textColor = WJColorWhite;
        activityL.font = WJFont10;
        activityL.text = @"特惠";
        activityL.layer.cornerRadius = 3.f;
        activityL.layer.masksToBounds = YES;
        activityL.textAlignment = NSTextAlignmentCenter;
        activityL.backgroundColor = WJColorCardRed;
        [self.contentView addSubview:activityL];
        
        //线1
        line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(331), kScreenWidth, ALD(0.5))];
        line1.backgroundColor = WJColorDarkGrayLine;
        [self.contentView addSubview:line1];
        
        
        tapBackView = [[UIView alloc] initWithFrame:CGRectMake(0, line1.bottom + ALD(13), kScreenWidth - ALD(50), ALD(44))];
        [self.contentView addSubview:tapBackView];
        
        //地址图标
        image = [UIImage imageNamed:@"Details_btn_add_nor"];
        locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        locationBtn.frame = CGRectMake(ALD(12) , (tapBackView.height - image.size.height)/2, ALD(18), ALD(18));
        [locationBtn setImage:[UIImage imageNamed:@"Details_btn_add_nor"] forState:UIControlStateNormal];
        [locationBtn addTarget:self action:@selector(locationBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [tapBackView addSubview:locationBtn];

        
        //电话
        teleBtn = [WJButton buttonWithType:UIButtonTypeCustom];
        teleBtn.frame = CGRectMake(kScreenWidth - ALD(16) - ALD(18), line1.bottom + ALD(13), ALD(18), ALD(18));
        [teleBtn setImage:[UIImage imageNamed:@"Details_btn_tel_nor"] forState:UIControlStateNormal];
        [teleBtn addTarget:self action:@selector(teleBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:teleBtn];
        
        //线2
        line2 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(50), line1.bottom + ALD(6), ALD(0.5), ALD(32))];
        line2.backgroundColor = WJColorDarkGrayLine;
        [self.contentView addSubview:line2];
        
        //地址
        addressL = [[UILabel alloc] initWithFrame:CGRectMake(locationBtn.right + ALD(10), 0, line2.right - locationBtn.right - ALD(12), ALD(44))];

        addressL.numberOfLines = 0;
        addressL.textAlignment = NSTextAlignmentLeft;
        addressL.font = WJFont12;
        addressL.textColor = WJColorLightGray;
        [tapBackView addSubview:addressL];


        //线3
//        line3 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bottom - ALD(0.5), kScreenWidth, ALD(0.5))];
//        line3.backgroundColor = WJColorDarkGrayLine;
//        [self.contentView addSubview:line3];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletapPressGesture)];
        [tapBackView  addGestureRecognizer:tapGesture];
        
    }
    return self;
}

- (void)configCellWithMerchantModel:(WJMerchantDetailModel *)model{
    
    detailModel = model;
    [picIVs makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [picIVs removeAllObjects];
    
    countL.text = [NSString stringWithFormat:@"1/%ld",(long)detailModel.imageNum];

    int i = 0;
    for (; i < model.imageArray.count; i++) {
        
        NSString *imageUrl = ClippingCenterImageUrl([(WJMerchantImageModel *)model.imageArray[i] imgUrl], kScreenWidth, ALD(236));
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, ALD(236))];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.clipsToBounds = YES;
        [btn sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"merchant_detail_default"]];
        btn.tag = i;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [imageScrollView addSubview:btn];
        [picIVs addObject:btn];
    }
    
    imageScrollView.contentSize = CGSizeMake(kScreenWidth*i, imageScrollView.height);
    
    pageC.numberOfPages = i;
    
    if (model.imageArray.count < 2) {
        pageC.hidden = YES;
    }
    
    NSArray *array_1 = [model.merName componentsSeparatedByString:@"("];
    NSArray *array_2 = [model.merName componentsSeparatedByString:@"（"];
    if (array_1.count > 1 || array_2.count > 1) {
        if (array_1.count > 1) {
            NSString *shopTitleStr = [array_1 objectAtIndex:0];
            nameL.text = shopTitleStr;
            CGFloat width = [UILabel getWidthWithTitle:nameL.text font:nameL.font];
            nameL.frame = CGRectMake(ALD(12), ALD(250), width, ALD(18));
            //店名
            NSString *shopNameStr = [NSString stringWithFormat:@"(%@",[array_1 objectAtIndex:1]];
            shopL.text = shopNameStr;
            CGFloat shopwidth = [UILabel getWidthWithTitle:shopL.text font:shopL.font];
            shopL.frame = CGRectMake(nameL.right, ALD(250), shopwidth, ALD(17));
        }else{
            NSString *shopTitleStr = [array_2 objectAtIndex:0];
            nameL.text = shopTitleStr;
            CGFloat width = [UILabel getWidthWithTitle:nameL.text font:nameL.font];
            nameL.frame = CGRectMake(ALD(12), ALD(250), width, ALD(18));
            //店名
            NSString *shopNameStr = [NSString stringWithFormat:@"（%@",[array_2 objectAtIndex:1]];
            shopL.text = shopNameStr;
            CGFloat shopwidth = [UILabel getWidthWithTitle:shopL.text font:shopL.font];
            shopL.frame = CGRectMake(nameL.right, ALD(250), shopwidth, ALD(17));
        }
    }else{
        nameL.text = model.merName;
    }
    businessL.text = [NSString stringWithFormat:@"营业时间：%@", model.businessTime?:@""];
    addressL.text = [NSString stringWithFormat:@"地址：%@", model.address?:@""];
    phone = model.phone;
    if (model.activityNum == 0 || model.activity.count == 0) {
        activityL.hidden = YES;
        line1.frame = CGRectMake(0, businessL.bottom + ALD(15), kScreenWidth, ALD(0.5));
        
        tapBackView.frame = CGRectMake(0, line1.bottom, kScreenWidth - ALD(50), ALD(44));
        locationBtn.frame = CGRectMake(ALD(12) , (tapBackView.height - image.size.height)/2, ALD(18), ALD(18));

        teleBtn.frame = CGRectMake(kScreenWidth - ALD(16) - ALD(18), line1.bottom + ALD(13), ALD(18), ALD(18));

        line2.frame = CGRectMake(kScreenWidth - ALD(50), line1.bottom + ALD(6), ALD(0.5), ALD(32));
        addressL = [[UILabel alloc] initWithFrame:CGRectMake(locationBtn.right + ALD(10), 0, line2.right - locationBtn.right - ALD(12), ALD(44))];

    }else{
        activityL.text = @"特惠";
        activityL.frame =  CGRectMake(ALD(12), businessL.bottom + ALD(12), ALD(32), ALD(16));
        line1.frame = CGRectMake(0, activityL.bottom + ALD(10), kScreenWidth, ALD(0.5));
        
        tapBackView.frame = CGRectMake(0, line1.bottom, kScreenWidth - ALD(50), ALD(44));
        locationBtn.frame = CGRectMake(ALD(12) , (tapBackView.height - image.size.height)/2, ALD(18), ALD(18));
        
        teleBtn.frame = CGRectMake(kScreenWidth - ALD(16) - ALD(18), line1.bottom + ALD(13), ALD(18), ALD(18));
        
        line2.frame = CGRectMake(kScreenWidth - ALD(50), line1.bottom + ALD(6), ALD(0.5), ALD(32));
        addressL = [[UILabel alloc] initWithFrame:CGRectMake(locationBtn.right + ALD(10), 0, line2.right - locationBtn.right - ALD(12), ALD(44))];
    }

    
}

//图片展示
- (void)buttonClick:(UIButton *)button
{
    [kDefaultCenter postNotificationName:@"PushForPictureVC" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(unsigned long)picIVs.count],@"imageCount",[NSString stringWithFormat:@"%ld",button.tag],@"currentImageIndex",detailModel,@"detailModel", nil]];
    
}

//地理位置
- (void)locationBtnAction{
    
    [kDefaultCenter postNotificationName:@"PushForMapVC" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lf",detailModel.lat],@"merchantLatitude",[NSString stringWithFormat:@"%lf",detailModel.lng],@"merchantLongitude",
                                                                                                    detailModel.address,@"merchantAddress",
                                                                                                    detailModel.merName,@"merchantName", nil]];

}

//电话
- (void)teleBtnAction{
    
    if ([self.delegate respondsToSelector:@selector(clickTelButton:)]) {
        [self.delegate clickTelButton:phone];
    }
}

- (void)handletapPressGesture
{
    [self locationBtnAction];
}

- (NSAttributedString *)attributedText:(NSString *)text firstLength:(NSInteger)len{
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc]
                                         initWithString:text];
    NSDictionary *attributesForFirstWord = @{
                                             NSFontAttributeName : WJFont12,
                                             NSForegroundColorAttributeName : WJColorDardGray6,
                                             };
    
    NSDictionary *attributesForSecondWord = @{
                                              NSFontAttributeName : WJFont12,
                                              NSForegroundColorAttributeName : WJColorDardGray3,
                                              };
    [result setAttributes:attributesForFirstWord
                    range:NSMakeRange(0, len)];
    [result setAttributes:attributesForSecondWord
                    range:NSMakeRange(len, text.length - len)];
    return [[NSAttributedString alloc] initWithAttributedString:result];
}

#pragma WJSystemAlertViewDelegate
//- (void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (1==buttonIndex) {
//        [self callTelephone];
//
//    } else{
//        
//    }
//}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    NSInteger page = floor((scrollView.contentOffset.x -pageWidth/2)/pageWidth) +1;
    pageC.currentPage = page;
    countL.text = [NSString stringWithFormat:@"%ld/%ld",page + 1,detailModel.imageNum];
}

#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(WJShopPicturesViewController *)browser placeholderImageForIndex:(NSInteger)index
{
    return [self.subviews[index] currentImage];
}

- (NSURL *)photoBrowser:(WJShopPicturesViewController *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = detailModel.imageArray[index];
    return [NSURL URLWithString:urlStr];
}

@end
