//
//  WJHotBrandCollectionViewCell.m
//  WanJiCard
//
//  Created by silinman on 16/5/28.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJHotBrandCollectionViewCell.h"
#import "WJMoreBrandesModel.h"

@implementation WJHotBrandCollectionViewCell
{
    UIImageView     *first_IV;
    UIImageView     *firstIV;
    UIImageView     *first_V;
    UILabel         *firstL;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) { 
        
        first_IV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ALD(105), ALD(62))];
        first_IV.layer.cornerRadius = 3.0f;
//        first_IV.alpha = 0.4f;
        first_IV.layer.masksToBounds = YES;
        first_IV.contentMode = UIViewContentModeScaleToFill;
        first_IV.image = [UIImage imageNamed:@"hot_brand_default"];
        [self addSubview:first_IV];
        
        first_V = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ALD(105), ALD(62))];
//        first_V.backgroundColor = WJColorBlack;
        first_V.image = [UIImage imageNamed:@"maoboli"];
        first_V.layer.cornerRadius = 3.0f;
        first_V.layer.masksToBounds = YES;
//        first_V.alpha = 0.4f;
        [self addSubview:first_V];
        
        firstIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(25), ALD(13), ALD(55), ALD(35))];
        firstIV.layer.cornerRadius = 3.0f;
        firstIV.layer.masksToBounds = YES;
        firstIV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:firstIV];
        
        firstL = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(72), ALD(105), ALD(15))];
        firstL.font = WJFont13;
        firstL.textColor = WJColorDarkGray;
        firstL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:firstL];
        
    }
    return self;
}
- (void)configData:(WJMoreBrandesModel *)model{
    [first_IV sd_setImageWithURL:[NSURL URLWithString:model.brandPhotoUrl] placeholderImage:[UIImage imageNamed:@"hot_brand_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        first_IV.image = [self.class coreBlurImage:image withBlurNumber:4.0];
    }];
    [firstIV sd_setImageWithURL:[NSURL URLWithString:model.logoUrl] placeholderImage:nil];
    firstL.text = model.name;
}

+ (UIImage *)coreBlurImage:(UIImage *)image
            withBlurNumber:(CGFloat)blur {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage  *inputImage=[CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

@end
