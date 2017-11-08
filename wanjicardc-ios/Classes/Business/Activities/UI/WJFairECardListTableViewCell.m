//
//  WJFairECardListTableViewCell.m
//  WanJiCard
//
//  Created by silinman on 16/8/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJFairECardListTableViewCell.h"
#import "WJECardCollectionViewCell.h"
#import "WJECardModel.h"

@interface WJFairECardListTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView          *collectionView;
@property (nonatomic, strong) NSMutableArray            *dataArray;
@property (nonatomic, strong) UILabel                   *bottomLine;

@end

@implementation WJFairECardListTableViewCell

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
        
        self.backgroundColor = WJColorWhite;
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
        [self.contentView addSubview:self.collectionView];
        _bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(349.5), kScreenWidth, ALD(0.5))];
        _bottomLine.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:self.bottomLine];
    }
    return self;
}

- (void)configData:(NSMutableArray *)datasArray{
    if (datasArray.count == 0) {
        return;
    }
    [self.dataArray removeAllObjects];
    for (int i = 0; i < datasArray.count; i ++) {
        WJECardModel *model = [datasArray objectAtIndex:i];
        [self.dataArray addObject:model];
    }
    float cellHeight;
    //    if (self.dataArray.count > 20) {
    //        cellHeight = ALD(185) + ALD(9 * 170);
    //    }else{
    //        if (self.dataArray.count > 2) {
    //            cellHeight = ALD(185) + ALD((self.dataArray.count/2 + self.dataArray.count%2 - 1) * 170);
    //        }else{
    //            cellHeight = ALD(185);
    //        }
    //    }
    
    
    if (self.dataArray.count > 2) {
        cellHeight = ALD(185) + ALD((self.dataArray.count/2 + self.dataArray.count%2 - 1) * 170);
    } else {
        cellHeight = ALD(185);
        
    }
    
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, cellHeight);
    self.bottomLine.frame     = CGRectMake(0, cellHeight - ALD(0.5), kScreenWidth, ALD(0.5));
    
    [self.collectionView reloadData];
}


#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WJECardCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"WJECardCollectionViewCell" forIndexPath:indexPath];
    WJECardModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell configData:model];
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(ALD(12), ALD(11), ALD(25), ALD(11));
}

#pragma mark ---- UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WJECardModel *model = [self.dataArray objectAtIndex:indexPath.row];
    self.selectECardBlock(model);
}

#pragma mark - 懒加载collectionView
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(ALD(170), ALD(160));
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(0)) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = WJColorWhite;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[WJECardCollectionViewCell class] forCellWithReuseIdentifier:@"WJECardCollectionViewCell"];
    }
    return _collectionView;
}


@end
