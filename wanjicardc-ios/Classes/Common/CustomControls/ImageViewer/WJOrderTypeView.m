//
//  WJOrderTypeView.m
//  WanJiCard
//
//  Created by reborn on 16/8/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJOrderTypeView.h"
#import "WJOrderTypeViewCell.h"
#import "WJOrderSectionCell.h"

#define KOrderTypeViewCell      @"KOrderTypeViewCell"
#define KOrderTypeSectionCell   @"KOrderTypeSectionCell"

@interface WJOrderTypeView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *orderArray;
@property (nonatomic, strong) NSArray *sectionTitleArray;
@property (nonatomic, assign) CGFloat collectionHeight;
@end

@implementation WJOrderTypeView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        NSArray *array1 = [NSArray arrayWithObjects:@"全部订单",@"待支付订单",@"已关闭订单",@"已完成订单",nil];
        NSArray *array2 = [NSArray arrayWithObjects:@"商家卡订单",@"电子卡订单",@"包子充值订单",nil];
        
        _orderArray = @[array1,array2];
        _sectionTitleArray = [NSArray arrayWithObjects:@"订单状态",@"订单类型", nil];
        
        UIView *backView = [[UIView alloc] initWithFrame:frame];
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self addSubview:backView];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        
        self.orderCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.collectionHeight) collectionViewLayout:flowLayout];
        self.orderCollectionView.backgroundColor = WJColorViewBg;
        self.orderCollectionView.delegate = self;
        self.orderCollectionView.dataSource = self;
        
        [self.orderCollectionView registerClass:[WJOrderTypeViewCell class] forCellWithReuseIdentifier:KOrderTypeViewCell];
        [self.orderCollectionView registerClass:[WJOrderSectionCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:KOrderTypeSectionCell];

        [self addSubview:self.orderCollectionView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takeBack:)];
        [backView addGestureRecognizer:tapGesture];
    }
    return  self;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _sectionTitleArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSUInteger index = section;
    if (index < _sectionTitleArray.count) {
        
        return [[_orderArray objectAtIndex:section] count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = indexPath.section;

    if (index < _sectionTitleArray.count) {
        
        WJOrderTypeViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KOrderTypeViewCell forIndexPath:indexPath];
        
        if (indexPath.section == 0 && indexPath.item == 0) {
            cell.selected = YES;
            [cell changeLabelColor];
        }
        
        [cell upadate:[[_orderArray objectAtIndex:index] objectAtIndex:indexPath.item]];
        return cell;
    }
    
    UICollectionViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    NSUInteger index = indexPath.section;
    
    if (index < _sectionTitleArray.count) {
        
        WJOrderSectionCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:KOrderTypeSectionCell forIndexPath:indexPath];
        cell.title = [_sectionTitleArray objectAtIndex:index];
        return cell;
    }
    
    reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KOrderTypeDefaultSectionCell" forIndexPath:indexPath];

    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (iPhone6OrThan) {
        
        return CGSizeMake((kScreenWidth-ALD(40))/3, ALD(35));
 
    } else {
        
        return CGSizeMake((kScreenWidth-ALD(50))/3, ALD(35));
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 10, 10);

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, ALD(45));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderTypeViewUpdateOrder:section:)]) {
        [self.delegate orderTypeViewUpdateOrder:indexPath.item section:indexPath.section];
    }
    
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    if (indexPath != firstIndexPath) {
        WJOrderTypeViewCell *firstCell = (WJOrderTypeViewCell *)[collectionView cellForItemAtIndexPath:firstIndexPath];
        firstCell.selected = NO;
        [firstCell changeLabelColor];
    }
    
    WJOrderTypeViewCell *cell = (WJOrderTypeViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell changeLabelColor];
    
    self.hidden = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WJOrderTypeViewCell *cell = (WJOrderTypeViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell changeLabelColor];
}

- (void)takeBack:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hideBackOrderTypeView:)]) {
        [self.delegate hideBackOrderTypeView:self];
    }
}

- (CGFloat )collectionHeight
{
    _collectionHeight = [self heightWightArray:[self.orderArray objectAtIndex:0]] + [self heightWightArray:[self.orderArray objectAtIndex:1]] + _sectionTitleArray.count * ALD(45);
    
    return _collectionHeight;
}

- (CGFloat)heightWightArray:(NSArray *)array
{
    return (ALD(10) + ALD(35)) * ([array count] % 3 > 0 ? [array count]/3 + 1 :[array count]/3);
}

@end
