//
//  WJShopAndCardsTableViewCell.m
//  WanJiCard
//
//  Created by silinman on 16/5/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJShopAndCardsTableViewCell.h"
#import "WJShopAndCardsCollectionViewCell.h"
#import "WJShopAndCardsCollectionReusableView.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "WJHomePageBottomModel.h"
#import "WJHomePageCardsModel.h"
#import "WJCardActsModel.h"
#import "LocationManager.h"

@interface WJShopAndCardsTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>


@property (nonatomic, copy)             void(^process)(NSInteger index);
@property (nonatomic, strong)           NSMutableArray      *imageArray;
@property (nonatomic, strong)           NSMutableArray      *picUrls;
@property (nonatomic, strong)           NSMutableArray      *cardActsArray;
@property (nonatomic, strong)           UICollectionView    *collectionView;
@property (nonatomic, strong)           WJHomePageBottomModel *bottomsModel;
@end

@implementation WJShopAndCardsTableViewCell{
    UILabel                 *titleL;
    UILabel                 *shopL;
    UILabel                 *firstActivityL;
    UILabel                 *addressL;
    UIImageView             *locationIV;
    UILabel                 *locationL;
    UILabel                 *soldL;
    UILabel                 *bottomLine;
    BOOL                    isActs;
    BOOL                    isClicked;
    BOOL                    shopIsClicked;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        isClicked = YES;
        shopIsClicked = YES;
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(30), ALD(250), ALD(17))];
        titleL.textAlignment = NSTextAlignmentLeft;
        titleL.font = WJFont15;
        titleL.textColor = WJColorDarkGray;
        [self.contentView addSubview:titleL];
        
        shopL = [[UILabel alloc] initWithFrame:CGRectMake(titleL.right + ALD(5), ALD(30), ALD(250), ALD(17))];
        shopL.textAlignment = NSTextAlignmentLeft;
        shopL.font = WJFont12;
        shopL.textColor = WJColorLightGray;
        [self.contentView addSubview:shopL];
        
        firstActivityL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), titleL.bottom + ALD(15), ALD(32), ALD(16))];
        firstActivityL.textColor = WJColorWhite;
        firstActivityL.font = WJFont10;
        firstActivityL.backgroundColor = WJColorCardRed;
        firstActivityL.textAlignment = NSTextAlignmentCenter;
        firstActivityL.layer.cornerRadius = 3.f;
        firstActivityL.layer.masksToBounds = YES;
        [self.contentView addSubview:firstActivityL];
        
        addressL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12),firstActivityL.bottom + ALD(15), ALD(250), ALD(14))];
        addressL.textAlignment = NSTextAlignmentLeft;
        addressL.font = WJFont12;
        addressL.textColor = WJColorLightGray;
        [self.contentView addSubview:addressL];
        
        locationIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), addressL.bottom + ALD(15), ALD(13), ALD(13))];
        locationIV.image = [UIImage imageNamed:@"Details_icon_distance_dis"];
        [self.contentView addSubview:locationIV];
        
        locationL = [[UILabel alloc] initWithFrame:CGRectMake(locationIV.right + ALD(5), ALD(30), ALD(250), ALD(17))];
        locationL.textAlignment = NSTextAlignmentLeft;
        locationL.font = WJFont12;
        locationL.textColor = WJColorLightGray;
        [self.contentView addSubview:locationL];
        
        soldL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(30), ALD(250), ALD(14))];
        soldL.textAlignment = NSTextAlignmentLeft;
        soldL.font = WJFont12;
        soldL.textColor = WJColorLightGray;
        [self.contentView addSubview:soldL];
        
        bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(154), kScreenWidth, ALD(0.5))];
        bottomLine.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:bottomLine];
        
        //创建添加collectionView
        isActs = NO;        
        [self.contentView addSubview:self.collectionView];
        [self.imageArray removeAllObjects];
        [self.picUrls removeAllObjects];
        [self.cardActsArray removeAllObjects];
    }
    return self;
}
- (void)sendPicUrls:(WJHomePageBottomModel *)bottomModel selectImageHandle:(void(^)(NSInteger index))process;
{
    self.picUrls = nil;
    self.imageArray = nil;
    self.cardActsArray = nil;
    self.bottomsModel = bottomModel;
    self.process = process;
    for (int i = 0; i < bottomModel.cardsArray.count; i ++) {
        WJHomePageCardsModel *model = [bottomModel.cardsArray objectAtIndex:i];
        [self.picUrls addObject:model];
        [self.imageArray addObject:model.cardColor];
    }
    for (int i = 0; i < bottomModel.cardActs.count; i ++) {
        WJCardActsModel *cardActsModel = [bottomModel.cardActs objectAtIndex:i];
        [self.cardActsArray addObject:cardActsModel];
    }
    //商家名
    NSArray *array_1 = [bottomModel.merchantName componentsSeparatedByString:@"("];
    NSArray *array_2 = [bottomModel.merchantName componentsSeparatedByString:@"（"];

    if (array_1.count > 1 || array_2.count > 1) {
        NSString *shopTitleStr;
        NSString *shopNameStr;
        if (array_1.count > 1) {
            shopTitleStr = [array_1 objectAtIndex:0];
            titleL.text = shopTitleStr;
            CGFloat width = [UILabel getWidthWithTitle:titleL.text font:titleL.font];
            titleL.frame = CGRectMake(ALD(12), ALD(30), width, ALD(17));
            //店名
            shopNameStr = [NSString stringWithFormat:@"(%@",[array_1 objectAtIndex:1]];
            shopL.text = shopNameStr;
            CGFloat shopwidth = [UILabel getWidthWithTitle:shopL.text font:shopL.font];
            shopL.frame = CGRectMake(titleL.right + ALD(5), ALD(31), shopwidth, ALD(14));
        }else{
            shopTitleStr = [array_2 objectAtIndex:0];
            titleL.text = shopTitleStr;
            CGFloat width = [UILabel getWidthWithTitle:titleL.text font:titleL.font];
            titleL.frame = CGRectMake(ALD(12), ALD(30), width, ALD(17));
            //店名
            shopNameStr = [NSString stringWithFormat:@"（%@",[array_2 objectAtIndex:1]];
            shopL.text = shopNameStr;
            CGFloat shopwidth = [UILabel getWidthWithTitle:shopL.text font:shopL.font];
            shopL.frame = CGRectMake(titleL.right + ALD(5), ALD(31), shopwidth, ALD(14));
        }
    }else{
        titleL.text = bottomModel.merchantName;
        CGFloat width = [UILabel getWidthWithTitle:titleL.text font:titleL.font];
        titleL.frame = CGRectMake(ALD(12), ALD(30), width, ALD(17));
        shopL.text = @"";
    }
    //活动
    if (self.cardActsArray.count != 0) {
        isActs = YES;
        WJCardActsModel *cardActsModel = [self.cardActsArray objectAtIndex:0];
        if (cardActsModel.actName) {
            firstActivityL.text = cardActsModel.actName;
        }else{
            firstActivityL.text = @"特惠";
        }
        firstActivityL.hidden = NO;
        //地址
        addressL.text = [NSString stringWithFormat:@"地址：%@",bottomModel.merchantAddress];
        addressL.frame = CGRectMake(ALD(12), firstActivityL.bottom + ALD(15), kScreenWidth - ALD(83) - ALD(12), ALD(14));
        
    }else{
        isActs = NO;
        //商家名
        CGFloat width = [UILabel getWidthWithTitle:titleL.text font:titleL.font];
        titleL.frame = CGRectMake(ALD(12), ALD(45), width, ALD(17));
        //店名
        CGFloat shopwidth = [UILabel getWidthWithTitle:shopL.text font:shopL.font];
        shopL.frame = CGRectMake(titleL.right + ALD(5), ALD(46), shopwidth, ALD(14));
        //活动
        firstActivityL.hidden = YES;
        //地址
        addressL.text = [NSString stringWithFormat:@"地址：%@",bottomModel.merchantAddress];
        addressL.frame = CGRectMake(ALD(12), titleL.bottom + ALD(15), kScreenWidth - ALD(83) - ALD(12), ALD(14));

    }
    
    //已售
    soldL.text = [NSString stringWithFormat:@"已售  %@",bottomModel.totalSale];
    CGFloat soldLwidth = [UILabel getWidthWithTitle:soldL.text font:soldL.font];
    soldL.frame = CGRectMake( ALD(12), addressL.bottom + ALD(15), soldLwidth, ALD(14));
    
    if (bottomModel.distance == nil || [bottomModel.distance isEqualToString:@""] || [bottomModel.distance isEqualToString:@"0"]) {
        locationIV.hidden = YES;
        locationL.hidden = YES;

    }else{
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
            locationIV.hidden = YES;
            locationL.hidden = YES;
        }else{
            locationIV.hidden = NO;
            locationL.hidden = NO;
            //距离图标
            locationIV.frame = CGRectMake(soldL.right + ALD(15), addressL.bottom + ALD(15), ALD(13), ALD(13));
            //距离
            locationL.text = bottomModel.distance;
            CGFloat locationLwidth = [UILabel getWidthWithTitle:locationL.text font:locationL.font];
            locationL.frame = CGRectMake(locationIV.right + ALD(5), locationIV.y, locationLwidth, ALD(14));
        }
    }
    
    [_collectionView reloadData];
}

#pragma mark - CollectionView 代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //固定3个组
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //每组cell个数
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WJShopAndCardsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WJShopAndCardsCollectionViewCell" forIndexPath:indexPath];
    if (self.picUrls == nil || self.picUrls.count == 0) {
        return cell;
    }
    WJHomePageCardsModel *model = [self.picUrls objectAtIndex:indexPath.row];
    
    [cell configData:self.bottomsModel cardData:model];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    self.process(indexPath.row);
    if ([WJGlobalVariable sharedInstance].homeCardClickCount == 0) {
        if (isClicked) {
            isClicked = NO;
            self.process(indexPath.row);
        }
        [WJGlobalVariable sharedInstance].homeCardClickCount ++;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WJGlobalVariable sharedInstance].homeCardClickCount = 0;
        isClicked = YES;
    });
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    WJShopAndCardsCollectionReusableView *headView;
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        headView = [_collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WJShopAndCardsCollectionReusableView" forIndexPath:indexPath];
        [headView addTarget:self action:@selector(didSelect:)];
    }
    return headView;
}
- (void)didSelect:(id)sender{
    
    if (shopIsClicked) {
        [kDefaultCenter postNotificationName:@"PushForShopDetails" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_bottomsModel.merchantId,@"key", nil]];
        shopIsClicked = NO;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        shopIsClicked = YES;
    });

}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {kScreenWidth - ALD(83),ALD(155)};
    return size;
}
#pragma mark - 懒加载collectionView 和 pageCtrl
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        //设置流水布局属性
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.itemSize = CGSizeMake(ALD(267), ALD(153));
        
        //创建CollectionView
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(154)) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        //注册自定义cell类
        [_collectionView registerClass:[WJShopAndCardsCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WJShopAndCardsCollectionReusableView"];
        [_collectionView registerClass:[WJShopAndCardsCollectionViewCell class] forCellWithReuseIdentifier:@"WJShopAndCardsCollectionViewCell"];
    }
    return _collectionView;
}
- (NSMutableArray *)imageArray
{
    if(nil == _imageArray)
    {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (NSMutableArray *)picUrls
{
    if(nil == _picUrls)
    {
        _picUrls = [NSMutableArray array];
    }
    return _picUrls;
}
- (NSMutableArray *)cardActsArray
{
    if(nil == _cardActsArray)
    {
        _cardActsArray = [NSMutableArray array];
    }
    return _cardActsArray;
}

@end
