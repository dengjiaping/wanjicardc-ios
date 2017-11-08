//
//  WJMemberPrivilegeTableViewCell.m
//  WanJiCard
//
//  Created by silinman on 16/6/12.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJMemberPrivilegeTableViewCell.h"

@interface WJMemberPrivilegeTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    
}
@property (nonatomic, strong)UICollectionView   *collectionView;
@property (nonatomic, strong)UILabel            *titleL;
@property (nonatomic, strong)UIImageView        *arrowIV;

@end

@implementation WJMemberPrivilegeTableViewCell{
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.arrowIV];
        [self.contentView addSubview:self.collectionView];
        
    }
    return self;
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
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imageIV = [[UIImageView alloc] initWithFrame:cell.frame];
    [cell.contentView addSubview:imageIV];
    return cell;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        //设置流水布局属性
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.itemSize = CGSizeMake(ALD(30), ALD(30));
        
        //创建CollectionView
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, ALD(33), ALD(250), ALD(40)) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        //注册自定义cell类/Users/silinman/WorkSpace/wanjicardc-ios/Classes/Business/Home/WJCategoryListViewController.h
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (UILabel *)label
{
    if (!_titleL) {
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(15), ALD(150), ALD(17))];
        _titleL.font = WJFont14;
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.textColor = WJColorDarkGray;
        _titleL.text = @"享有6项会员卡特权";
    }
    return _titleL;
}

- (UIImageView *)imageView
{
    if (!_arrowIV) {
        
        _arrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(13) - ALD(15), ALD(35), ALD(13), ALD(13))];
        _arrowIV.image = [UIImage imageNamed:@"r_icon"];
    }
    return _arrowIV;
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
