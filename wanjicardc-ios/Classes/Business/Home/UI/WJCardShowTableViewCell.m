//
//  WJCardShowTableViewCell.m
//  WanJiCard
//
//  Created by silinman on 16/6/15.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCardShowTableViewCell.h"
#import "WJCardDetailsFlowLayout.h"
#import "WJCardShowCollectionViewCell.h"
#import "WJMerchantCardDetailModel.h"
#import "WJCardModel.h"

@interface WJCardShowTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,CustomViewFlowLayoutDelegate>{
    NSString *cardNum;
    int      temp;
    BOOL     isUseId;
}

@property (nonatomic, strong)UICollectionView           *collectionView;
@property (nonatomic, strong)UIPageControl              *pageControl;
@property (nonatomic, strong)WJMerchantCardDetailModel  *cardDetailModel;
@property (nonatomic, strong)NSString                   *cardsID;

@end

@implementation WJCardShowTableViewCell

-(void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = WJColorWhite;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = WJColorWhite;
        temp = 0;
        isUseId = YES;
        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.pageControl];
        
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    WJCardDetailsFlowLayout *layout = (WJCardDetailsFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat itemWidth = layout.itemSize.width;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    CGFloat scrollViewWidth = scrollView.bounds.size.width;
    
    int page = 0;
    if (offsetX <= 0) {
        page = 0;
    }else if(offsetX + scrollViewWidth >= scrollView.contentSize.width){
        page = (int)[self.collectionView numberOfItemsInSection:0] - 1;
    }else{
        div_t x = div(offsetX, itemWidth);
        page = x.rem > itemWidth/2 ? x.quot+1 : x.quot;
    }
    
    [self collectionView:self.collectionView
                  layout:nil
 cellCenteredAtIndexPath:nil
                    page:page];
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout cellCenteredAtIndexPath:(NSIndexPath *)indexPath page:(int)page{
    NSLog(@"第 %ld 张卡",(long)page);
    if (self.pageControl.currentPage != page) {
        self.pageControl.currentPage = page;
        NSString *pageStr = [NSString stringWithFormat:@"%d",page];
        [kDefaultCenter postNotificationName:@"ChangeCardData"
                                      object:nil
                                    userInfo:[NSDictionary dictionaryWithObjectsAndKeys:pageStr,@"key",cardNum,@"cardNum", nil]];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cardDetailModel.cardArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return  1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WJCardShowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WJCardShowCollectionViewCell"
                                  forIndexPath:indexPath];
    WJCardModel *model = [self.cardDetailModel.cardArray objectAtIndex:indexPath.row];
    [cell configData:model];
    return cell;
}

- (void)configData:(WJMerchantCardDetailModel *)model cardIndex:(NSInteger )cardIndex cardID:(NSString *)cardID{
    if (model == nil) {
        return;
    }
    self.cardDetailModel = model;
    self.cardsID = cardID;
//    [self.collectionView reloadData];
    if (model.cardArray.count == 1) {
        self.pageControl.hidden = YES;
    }else{
        self.pageControl.hidden = NO;
        self.pageControl.numberOfPages = model.cardArray.count;
        
        //是否使用cardID来判断第几张卡（第一次进入卡详情页面使用cardID来判断，页面内使用cardIndex）
        if (isUseId == YES) {
            for (WJCardModel *cardModel in model.cardArray) {
                if ([cardModel.cardId isEqualToString:cardID]) {
                    break;
                }
                temp ++;
            }
            
            if (temp != 0 && temp < model.cardArray.count && self.pageControl.currentPage == 0 ) {
                CGFloat offX = temp*(self.collectionView.width-60);//MIN(temp*(self.collectionView.width-60), self.collectionView.contentSize.width-self.collectionView.width);
                self.collectionView.contentOffset = CGPointMake(offX, 0) ;
            }else{
                temp = (int)cardIndex;
            }
            self.pageControl.currentPage = temp;
            isUseId = NO;
            WJCardDetailsFlowLayout *layout = (WJCardDetailsFlowLayout *)self.collectionView.collectionViewLayout;
            [layout configPreviseOffX:self.collectionView.contentOffset.x - temp * ALD(5)];
            
        }else{
            self.pageControl.currentPage = cardIndex;
        }
    }
}
#pragma mark - 懒加载collectionView 和 pageCtrl
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        WJCardDetailsFlowLayout *layout = [[WJCardDetailsFlowLayout alloc] init];
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(205)) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = WJColorWhite;
        _collectionView.decelerationRate = 0.2;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[WJCardShowCollectionViewCell class] forCellWithReuseIdentifier:@"WJCardShowCollectionViewCell"];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(ALD(12) , ALD(210), kScreenWidth - ALD(24), ALD(12))];
        _pageControl.currentPageIndicatorTintColor = WJColorNavigationBar;
        _pageControl.pageIndicatorTintColor = WJColorPageControlTintColor;
//        _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        _pageControl.centerX = self.centerX;
    }
    return _pageControl;
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
