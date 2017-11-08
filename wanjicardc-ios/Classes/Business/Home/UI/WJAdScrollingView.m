//
//  WJAdScrollingView.m
//  WanJiCard
//
//  Created by silinman on 16/5/20.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJAdScrollingView.h"
#import "WJAdScrollingCell.h"
#import "WJHomePageActivitiesModel.h"

#define IDENTIFIER @"CollectionViewCell"
@interface WJAdScrollingView()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    
}
@property (nonatomic, copy) void(^process)(NSInteger index);
@property (nonatomic, strong)NSMutableArray *imageArray;
@property (nonatomic, strong)NSMutableArray *picUrls;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UIPageControl *pageCtrl;
@property (nonatomic, strong)NSTimer *timer;

@end


@implementation WJAdScrollingView
- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageNames selectImageHandle:(void(^)(NSInteger index))process
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        //保存数据
        self.process = process;
        if (imageNames.count != 0) {
            for (int i = 0; i < imageNames.count; i ++) {
                if (i > 7) {
                    break;
                }
                [self.imageArray addObject:@"home_banner_default"];
                WJHomePageActivitiesModel *model = [imageNames objectAtIndex:i];
                [self.picUrls addObject:model.img];
            }
        }else{
            
            [self.imageArray addObject:@"home_banner_default"];
        }
        

        
        //先滚动到第1组(中间组)
        if (self.imageArray.count > 1) {
            //创建添加collectionView
            [self addSubview:self.collectionView];
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            [self addSubview:self.pageCtrl];
            [self addTimer];
        }
    }
    return self;
}

#pragma mark - CollectionView 代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //固定3个组
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //每组cell个数
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WJAdScrollingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER forIndexPath:indexPath];

    cell.imageName = self.imageArray[indexPath.row];
    if (self.picUrls.count == 0 || self.picUrls == nil) {
        return cell;
    }
    cell.URLString = self.picUrls[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.process(indexPath.row);
}

#pragma maek - scrollView 代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self addTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 取出偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 计算第几页
    NSInteger index = offsetX / CGRectGetWidth(scrollView.frame);
    
    // 计算第几组
    NSInteger section = index / self.imageArray.count;
    
    // 计算item
    NSInteger item = index % self.imageArray.count;
    
    if (self.imageArray.count > 1) {
        // 判断已经到第一组或者是最后一组
        if( (item==self.imageArray.count) || (item==0) )
        {
            if ( section == 0 || section == 2 )
            {
                // 滚动到第一组
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:1] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            }
        }
    }

    
    //设置页码器值
    self.pageCtrl.currentPage = item;
}

#pragma mark - 定时器操作
- (void)addTimer
{
    if (_timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)nextPage
{
    NSIndexPath *currentPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    //计算下一个位置
    NSInteger nextRow = currentPath.row + 1;
    NSInteger nextSection = currentPath.section;
    
    //滚动溢出时需要设置Row和Section
    if (nextRow == self.imageArray.count)
    {
        nextRow = 0;
        if( nextSection == 2 )
        {
            nextSection = 1;
        }
        else
        {
            nextSection++;
        }
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:nextRow inSection:nextSection];
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
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
        layout.itemSize = self.frame.size;
        
        //创建CollectionView
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        //注册自定义cell类
        [_collectionView registerClass:[WJAdScrollingCell class] forCellWithReuseIdentifier:IDENTIFIER];
    }
    return _collectionView;
}

- (UIPageControl *)pageCtrl
{
    if (!_pageCtrl) {
        
        //设置frame
        CGFloat x = (self.frame.size.width - 100) * 0.5f;
        CGFloat y = self.frame.size.height - 25;
        CGFloat w = 100;
        CGFloat h = 20;
        
        //创建PageControl
        _pageCtrl = [[UIPageControl alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _pageCtrl.numberOfPages = [self.imageArray count];
        _pageCtrl.currentPage = 0;
        _pageCtrl.currentPageIndicatorTintColor = WJColorWhite;
        _pageCtrl.pageIndicatorTintColor = COLOR(255, 255, 255, 0.4);
    }
    return _pageCtrl;
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



@end
