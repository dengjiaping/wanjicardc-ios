//
//  WJMyIndividualViewController.m
//  WanJiCard
//
//  Created by reborn on 2017/8/12.
//  Copyright © 2017年 WJIKA. All rights reserved.
//


#import "WJMyIndividualViewController.h"
#import "APIUnReadMessagesManger.h"
#import "APIUserDetailManager.h"
#import "WJIndivdualCollectionViewCell.h"
#import "WJModelPerson.h"
#import "WJLoginViewController.h"
#import "WJMyOrderController.h"
#import "WJPaySettingController.h"
#import "WJMyConsumerController.h"
#import "WJMessageCenterViewController.h"
#import "WJSettingViewController.h"
#import "WJIndividualViewController.h"
#import "UINavigationBar+Awesome.h"

#define kHeaderViewIdentifier               @"kHeaderViewIdentifier"
#define kDefaultCellIdentifier              @"kDefaultCellIdentifier"
#define kCollectionViewCellIdentifier       @"kCollectionViewCellIdentifier"

#define NavigationBarHight     ALD(64)
#define HeaderViewHeight       ALD(250)


@interface WJMyIndividualViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,APIManagerCallBackDelegate>
{
    UILabel         *messagePoint;
    UIImageView     *avatarImageView;
    UILabel         *phoneL;
    NSString        *isSetsecurity;
}
@property(nonatomic,strong)APIUnReadMessagesManger *noReadMessageManager;
@property(nonatomic,strong)APIUserDetailManager    *userDetailManager;
@property(nonatomic,strong)UICollectionView        *collectionView;
@property(nonatomic,strong)NSArray                 *dataArray;
@end

@implementation WJMyIndividualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self navigationSetup];
    
    [self.view addSubview:self.collectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshIndividualCenter) name:@"kTabIndividualCenterRefresh" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadCurrentView) name:@"ReloadCurrentView" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"IndividualCenterRefresh" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginRefreshHead) name:@"loginRefreshHead" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUploadHeadPortrait) name:@"refreshUploadHeadPortrait" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toMessagepage) name:@"LoginForPersonalMessage" object:nil];


}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.noReadMessageManager loadData];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar lt_reset];
}

- (void)navigationSetup
{
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.frame = CGRectMake(0, 0, ALD(21), ALD(21));
    [settingButton setImage:[UIImage imageNamed:@"nav_setting"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(settingButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.frame = CGRectMake(0, 0, ALD(21), ALD(21));
    [messageButton setImage:[UIImage imageNamed:@"nav_message"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(messageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
    
    messagePoint = [[UILabel alloc] initWithFrame:CGRectMake(ALD(13), -ALD(2), ALD(12), ALD(12))];
    messagePoint.backgroundColor = WJColorAmount;
    messagePoint.layer.cornerRadius = messagePoint.width/2;
    messagePoint.layer.masksToBounds = YES;
    messagePoint.textColor = [UIColor redColor];
    messagePoint.font = WJFont10;
    messagePoint.textAlignment = NSTextAlignmentCenter;
    messagePoint.hidden = YES;
    [messageButton addSubview:messagePoint];
    
}

-(void)refreshIndividualCenter
{
    [self.noReadMessageManager loadData];
}

-(void)refreshView
{
    [self.collectionView reloadData];
}

-(void)loginRefreshHead
{
    [self.collectionView reloadData];
}

-(void)ReloadCurrentView
{
    WJModelPerson * person = [WJGlobalVariable sharedInstance].defaultPerson;
    if (person) {
        [person logout];
    }
    [self.collectionView reloadData];
}

-(void)toMessagepage
{
    WJMessageCenterViewController *messageCenterVC = [[WJMessageCenterViewController alloc] init];
    [self.navigationController pushViewController:messageCenterVC animated:YES];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if([manager isKindOfClass:[APIUserDetailManager class]])
    {
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        
        WJModelPerson *person = [WJDBPersonManager getDefaultPerson];
        [person updateWithDic:dic];
        
        if (person) {
            BOOL su = [[WJDBPersonManager new] updatePerson:person];
            if (su) {
                [self.collectionView reloadData];
            }
        }

        isSetsecurity = ToString(dic[@"isSetsecurity"]);
        
        [self.collectionView reloadData];
        
        
    } else if ([manager isKindOfClass:[APIUnReadMessagesManger class]]) {
        
        NSDictionary *dic = [[manager fetchDataWithReformer:nil] objectForKey:@"news"];
        
        if (dic[@"ifRead"] != nil && [dic[@"ifRead"] integerValue] != 0) {
            
            messagePoint.hidden = NO;
            
        } else {
            
            messagePoint.hidden = YES;
        }
        
        [self.userDetailManager loadData];
        
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    
}

#pragma mark - CollectionViewDelegate/CollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
        
    } else if (section == 1) {
        return self.dataArray.count;
    }
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    
    if (section == 1) {
        
        WJIndivdualCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];
        
        NSDictionary * dic = [self.dataArray  objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            
            cell.countL.hidden = YES;
            [cell configDataWithIcon:dic[@"icon"] Title:dic[@"text"] countString:@""];
            
        } else if (indexPath.row == 1) {
            cell.countL.hidden = YES;
            [cell configDataWithIcon:dic[@"icon"] Title:dic[@"text"] countString:@""];
            
        } else if (indexPath.row == 2) {
            
            [cell configDataWithIcon:dic[@"icon"] Title:dic[@"text"] countString:isSetsecurity];
            
        }
        
        return cell;
    }
    

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDefaultCellIdentifier forIndexPath:indexPath];
    
    return cell;
}


- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;

    
    if (kind == UICollectionElementKindSectionHeader)
    {
        if (indexPath.section == 0) {
            
            UICollectionReusableView * headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewIdentifier forIndexPath:indexPath];
            
            UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, HeaderViewHeight)];
            bgView.image = [UIImage imageNamed:@"Center_Background"];
            [headerview addSubview:bgView];
            
            
   
            avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake((headerview.width- ALD(80))/2, (headerview.height - ALD(40))/2, ALD(80), ALD(80))];
            avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
            
            WJModelPerson *defaultPerson = [WJDBPersonManager getDefaultPerson];

            [avatarImageView sd_setImageWithURL:[NSURL URLWithString:defaultPerson.headImageUrl] placeholderImage:[UIImage imageNamed:@"headerImg"]];

            
            avatarImageView.layer.cornerRadius = avatarImageView.width/2;
            avatarImageView.clipsToBounds = YES;
            [bgView addSubview:avatarImageView];
            
            phoneL = [[UILabel alloc] initWithFrame:CGRectMake((headerview.width - ALD(100))/2,avatarImageView.bottom + ALD(10) , ALD(100), ALD(20))];
            
            
            if (nil != defaultPerson && nil != defaultPerson.token && 0 != defaultPerson.token.length) {
                
                if ([defaultPerson.userName isEqualToString:@""]) {
                    phoneL.text = defaultPerson.phone;
                    
                    
                } else {
                    phoneL.text = defaultPerson.userName;
                    
                }
                
            }else{
                
                phoneL.text = @"未登录";

            }
            
            phoneL.textColor = [UIColor whiteColor];
            phoneL.textAlignment = NSTextAlignmentCenter;
            phoneL.font = WJFont12;
            [bgView addSubview:phoneL];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
            [headerview  addGestureRecognizer:tapGesture];
            
            return headerview;
            
        }
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDefaultCellIdentifier forIndexPath:indexPath];
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    
    if (section == 0) {
        return CGSizeMake(0,0);
        
    } else if (section == 1) {
        
        return CGSizeMake(kScreenWidth,ALD(44));
        
    }
    
    return CGSizeMake(0,0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return CGSizeMake(kScreenWidth, HeaderViewHeight);
        
    } else if (section == 1) {
        
        return CGSizeMake(0, 0);
        
    } else if (section == 2) {
        
        return CGSizeMake(0, 0);
        
    }
    
    return CGSizeMake(0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    NSUInteger index = indexPath.row;
    
    WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;

    
    switch (section) {
        case 1:
        {
            switch (index) {
                case 0:
                {
                    if (defaultPerson) {
                        
                        WJMyOrderController *myOrderVC = [[WJMyOrderController alloc] init];
                        [self.navigationController pushViewController:myOrderVC animated:YES];
                        
                        
                    } else {
                                                
                        WJLoginViewController *loginVC = [[WJLoginViewController alloc] init];
                        loginVC.from = LoginFromPersonal;
                        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
                        [self.navigationController presentViewController:nav animated:YES completion:nil];
                    }
 
                    
                }
                    break;
                    
                case 1:
                {
                    if (defaultPerson) {
                        
                        WJMyConsumerController *myConsumerVC = [[WJMyConsumerController alloc] init];
                        [self.navigationController pushViewController:myConsumerVC animated:YES];
                        
                        
                    } else {
                        
                        WJLoginViewController *loginVC = [[WJLoginViewController alloc] init];
                        loginVC.from = LoginFromPersonal;
                        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
                        [self.navigationController presentViewController:nav animated:YES completion:nil];
                    }
                    
                }
                    break;
                case 2:
                {
                    if (defaultPerson) {
                        
                        WJPaySettingController *paySettingVC = [[WJPaySettingController alloc] init];
                        [self.navigationController pushViewController:paySettingVC animated:YES];
                        
                        
                    } else {
                        
                        WJLoginViewController *loginVC = [[WJLoginViewController alloc] init];
                        loginVC.from = LoginFromPersonal;
                        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
                        [self.navigationController presentViewController:nav animated:YES completion:nil];
                    }
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
            
        default:
            break;
    }
}

#pragma mark - Custom Function
- (void)gradientLayerWithView:(UIView *)view
{
    UIColor *color1 = [WJUtilityMethod colorWithHexColorString:@"#f11c61"];
    UIColor *color2 = [WJUtilityMethod colorWithHexColorString:@"#fb551b"];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)color1.CGColor, color2.CGColor, nil];
    NSArray *locations = [NSArray arrayWithObjects:@(0.0),@(1.0),nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    [view.layer addSublayer:gradientLayer];
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint   = CGPointMake(1, 1);
    
}

#pragma mark - Action
- (void)settingButtonAction
{
    WJSettingViewController *settingVC = [[WJSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];

}

- (void)messageButtonAction
{
    WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
    
    if (defaultPerson) {
        
        WJMessageCenterViewController *messageVC = [[WJMessageCenterViewController alloc] init];
        [self.navigationController pushViewController:messageVC animated:YES];
        
        
    } else {
        
        WJLoginViewController *loginVC = [[WJLoginViewController alloc] init];
        loginVC.from = LoginFromPersonal;
        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }

}

- (void)tapGesture
{
    
    WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
    
    if (defaultPerson) {
        
        WJIndividualViewController *individualVC = [[WJIndividualViewController alloc] init];
//        self.tabBarView.hidden = YES;
        [self.navigationController pushViewController:individualVC animated:YES];

        
    } else {
        
        WJLoginViewController *loginVC = [[WJLoginViewController alloc] init];
        loginVC.from = LoginFromPersonal;
        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
}

-(void)refreshUploadHeadPortrait
{
    WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:defaultPerson.headImageUrl]
                                              placeholderImage:[UIImage imageNamed:@"default_avatar_bg"]];;
}

#pragma mark - setter属性
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -NavigationBarHight - kStatusBarHeight, kScreenWidth,  kScreenHeight + kNavigationBarHeight + kStatusBarHeight) collectionViewLayout:flowLayout];
        
        _collectionView.backgroundColor = WJColorWhite;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        //默认
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kDefaultCellIdentifier];
        
        //header
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewIdentifier];
        
        
        //中间cell
        [_collectionView registerClass:[WJIndivdualCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
        
    }
    return _collectionView;
}

- (NSArray *)dataArray
{
    if(nil==_dataArray)
    {

        _dataArray = @[@{@"icon":@"Center_MyOrders",@"text":@"我的订单"},
                       @{@"icon":@"Center_MyConsume",@"text":@"我的消费"},
                       @{@"icon":@"Center_SecuritySetting",@"text":@"安全设置"}
                       ];
    }
    return _dataArray;
}


- (APIUnReadMessagesManger *)noReadMessageManager
{
    if (nil == _noReadMessageManager) {
        _noReadMessageManager = [[APIUnReadMessagesManger alloc] init];
        _noReadMessageManager.delegate = self;
    }
    return _noReadMessageManager;
}

-(APIUserDetailManager *)userDetailManager
{
    if (nil == _userDetailManager) {
        _userDetailManager = [[APIUserDetailManager alloc] init];
        _userDetailManager.delegate = self;
    }
    return _userDetailManager;
}



@end
