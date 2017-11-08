//
//  WJHotBrandListViewController.m
//  WanJiCard
//
//  Created by silinman on 16/5/27.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJHotBrandListViewController.h"
#import "WJHotBrandCollectionViewCell.h"
#import "WJMoreBrandesReformer.h"
#import "APIMoreBrandesManager.h"
#import "WJMoreBrandesModel.h"
#import "WJEmptyView.h"
#import "WJHotBrandShopListViewController.h"
#import "MJRefresh.h"


@interface WJHotBrandListViewController ()<APIManagerCallBackDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    
}
@property (nonatomic, strong) UICollectionView          *collectionView;
@property (nonatomic, strong) APIMoreBrandesManager     *moreBrandesManager;
@property (nonatomic, strong) NSArray                   *dataArray;
@property (nonatomic, strong) WJEmptyView               *emptyView;

@end

@implementation WJHotBrandListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UISetUp];
    [self requestData];
}
- (void)UISetUp{
    self.title = @"热门品牌";
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.collectionView];
//    [self createRefershHeaderAndFooter];
}
- (void)requestData{
    [self showLoadingView];
    [self.moreBrandesManager loadData];
}
//创建刷新
- (void)createRefershHeaderAndFooter{
    
    NSArray *idleImages = @[[UIImage imageNamed:@"WJKLoading01"],
                            [UIImage imageNamed:@"WJKLoading02"],
                            [UIImage imageNamed:@"WJKLoading03"],
                            [UIImage imageNamed:@"WJKLoading04"],
                            [UIImage imageNamed:@"WJKLoading05"],
                            [UIImage imageNamed:@"WJKLoading06"],
                            [UIImage imageNamed:@"WJKLoading07"],
                            [UIImage imageNamed:@"WJKLoading08"]];
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setImages:idleImages forState:MJRefreshStateIdle];
    [header setImages:idleImages forState:MJRefreshStatePulling];
    [header setImages:idleImages forState:MJRefreshStateRefreshing];
    self.collectionView.header = header;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterRefresh)];
    [footer setImages:idleImages forState:MJRefreshStateRefreshing];
    self.collectionView.footer = footer;
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
}
//上拉刷新数据
- (void)loadNewData{
    
}
//下拉加载更多数据
- (void)loadFooterRefresh{
    
}
#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    NSLog(@"成功 === %@",manager);
    if([manager isKindOfClass:[APIMoreBrandesManager class]])
    {
        self.dataArray = [[NSArray alloc]initWithArray: [manager fetchDataWithReformer:[[WJMoreBrandesReformer alloc] init]]];
        NSLog(@"dataArray = %@",self.dataArray);
        [self.collectionView reloadData];
    }
    [self hiddenLoadingView];
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    NSLog(@"失败");
    [self hiddenLoadingView];
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
    WJHotBrandCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"WJHotBrandCollectionViewCell" forIndexPath:indexPath];
    WJMoreBrandesModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell configData:model];
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(ALD(15), ALD(12), ALD(5), ALD(12));
}

#pragma mark ---- UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WJMoreBrandesModel *model = [self.dataArray objectAtIndex:indexPath.row];
    WJHotBrandShopListViewController *hotVC = [[WJHotBrandShopListViewController alloc] initWithNibName:nil bundle:nil];
    hotVC.categoryTitle = model.name;
    hotVC.searchManager.merchantAccountId = model.merchantAccountId;
    [self.navigationController pushViewController:hotVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载collectionView
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        //设置流水布局属性
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//        layout.minimumLineSpacing = 0;
//        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(ALD(105), ALD(95));
        
        //创建CollectionView
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        //注册自定义cell类
        [_collectionView registerClass:[WJHotBrandCollectionViewCell class] forCellWithReuseIdentifier:@"WJHotBrandCollectionViewCell"];
    }
    return _collectionView;
}


- (APIMoreBrandesManager *)moreBrandesManager{
    if (nil == _moreBrandesManager) {
        _moreBrandesManager = [[APIMoreBrandesManager alloc] init];
        _moreBrandesManager.delegate = self;
    }
    return _moreBrandesManager;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
