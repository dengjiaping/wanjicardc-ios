//
//  WJBillTypeView.m
//  WanJiCard
//
//  Created by reborn on 16/11/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJBillTypeView.h"
#import "WJOrderTypeViewCell.h"
#import "WJOrderSectionCell.h"

#define KBillTypeViewCell      @"KOrderTypeViewCell"
#define KBillTypeSectionCell   @"KOrderTypeSectionCell"

@interface WJBillTypeView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *billArray;
@property (nonatomic, strong) NSArray *sectionTitleArray;
@property (nonatomic, assign) CGFloat collectionHeight;
@end

@implementation WJBillTypeView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
//        NSArray *array1 = [NSArray arrayWithObjects:@"全部账单",@"待支付账单",@"已关闭账单",@"已成功帐单",nil];
        NSArray *array1 = [NSArray arrayWithObjects:@"全部账单",@"待支付账单",@"已成功帐单",nil];

        
        _billArray = @[array1];

        _sectionTitleArray = [NSArray arrayWithObjects:@"订单状态", nil];
        
        UIView *backView = [[UIView alloc] initWithFrame:frame];
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self addSubview:backView];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        
        self.billCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.collectionHeight) collectionViewLayout:flowLayout];
        self.billCollectionView.backgroundColor = WJColorViewBg;
        self.billCollectionView.delegate = self;
        self.billCollectionView.dataSource = self;
        
        [self.billCollectionView registerClass:[WJOrderTypeViewCell class] forCellWithReuseIdentifier:KBillTypeViewCell];
        [self.billCollectionView registerClass:[WJOrderSectionCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:KBillTypeSectionCell];
        
        [self addSubview:self.billCollectionView];
        
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
        
        return [[_billArray objectAtIndex:section] count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = indexPath.section;
    
    if (index < _sectionTitleArray.count) {
        
        WJOrderTypeViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KBillTypeViewCell forIndexPath:indexPath];
        
        if (indexPath.section == 0 && indexPath.item == 0) {
            cell.selected = YES;
            [cell changeLabelColor];
        }
        
        [cell upadate:[[_billArray objectAtIndex:index] objectAtIndex:indexPath.item]];
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
        
        WJOrderSectionCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:KBillTypeSectionCell forIndexPath:indexPath];
        cell.title = [_sectionTitleArray objectAtIndex:index];
        return cell;
    }
    
    reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KBillTypeDefaultSectionCell" forIndexPath:indexPath];
    
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(billTypeViewUpdateBill:section:)]) {
        [self.delegate billTypeViewUpdateBill:indexPath.item section:indexPath.section];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(hideBackBillTypeView:)]) {
        [self.delegate hideBackBillTypeView:self];
    }
}

- (CGFloat )collectionHeight
{
    _collectionHeight = [self heightWightArray:[self.billArray objectAtIndex:0]] + _sectionTitleArray.count * ALD(45);
    
    return _collectionHeight;
}

- (CGFloat)heightWightArray:(NSArray *)array
{
    return (ALD(10) + ALD(35)) * ([array count] % 3 > 0 ? [array count]/3 + 1 :[array count]/3);
}


@end
