//
//  WJMerchantDetailController.m
//  WanJiCard
//
//  Created by Angie on 15/9/12.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJMerchantDetailController.h"
#import "WJPrivilegeController.h"
#import "WJRelationMerchantController.h"
#import "WJCardListOfMerchantViewController.h"
#import "WJRecommendStoreModel.h"
#import "WJStoreModel.h"
#import "WJMerchantDetailSummryCell.h"
#import "WJCardDetailPrivilegeCell.h"
#import "WJCardDetailFitStoreCell.h"
#import "WJMerchantDetailProductCell.h"
#import "WJCardListTableViewCell.h"
#import "WJMerchantDetailModel.h"
#import "APIMerchantDetailManager.h"
#import "WJShopPicturesViewController.h"
#import "WJMerchantMapViewController.h"
#import "ShareManager.h"
#import "WJSystemAlertView.h"
#import "WJHomeCardDetailsViewController.h"
#import "WJCardModel.h"
#import "WJShopInfoTitleTableViewCell.h"
#import "LocationManager.h"
#import "WJWebViewController.h"
#import "WJMerchantCard.h"
#import "WJStatisticsManager.h"
#import "UINavigationBar+Awesome.h"
#import "WJShare.h"

#define  moreStoreRightEdgeMargin                                 (iPhone6OrThan?(ALD(25)):(ALD(20)))
#define  moreStoreLeftEdgeMargin                                  (iPhone6OrThan?(ALD(5)):(ALD(10)))



@interface WJMerchantDetailController ()<UITableViewDataSource, UITableViewDelegate, APIManagerCallBackDelegate, UIWebViewDelegate,UIActionSheetDelegate,WJSystemAlertViewDelegate,WJMerchantDetaiCellDelegate>
{
    CGFloat         userExplaintHeight;
    CGFloat         alpha;
    UIColor         *navigationBarColor;
    NSString        *phone;
    BOOL            hiddenExplain;
    BOOL            isOpenLocation;
}

@property (nonatomic, strong) UITableView               *mTb;
@property (nonatomic, strong) WJMerchantDetailModel     *detailMerchant;
@property (nonatomic, strong) APIMerchantDetailManager  *merchantDetailManager;
@property (nonatomic, strong) UIImageView               *shareImageView;


@end

@implementation WJMerchantDetailController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家详情";
    self.eventID = @"iOS_vie_MerchantDetails";
    navigationBarColor = WJColorBlack;
    alpha = 0.3;
    [self.navigationController.navigationBar lt_setBackgroundColor:[navigationBarColor colorWithAlphaComponent:alpha]];


    hiddenExplain = YES;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, ALD(19), ALD(19));
    [rightButton setImage:[UIImage imageNamed:@"nav_btn_share_nor"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.eventID = @"iOS_act_bizdetails";
    [self requestLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar lt_setBackgroundColor:[navigationBarColor colorWithAlphaComponent:alpha]];
    [self getLocationStatus];
    [kDefaultCenter addObserver:self selector:@selector(pushForPictureVC:) name:@"PushForPictureVC" object:nil];
    [kDefaultCenter addObserver:self selector:@selector(PushForMapVC:) name:@"PushForMapVC" object:nil];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
//    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar lt_setBackgroundColor:[navigationBarColor colorWithAlphaComponent:alpha]];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    [self.navigationController.navigationBar lt_reset];
    [kDefaultCenter removeObserver:self name:@"PushForPictureVC" object:nil];
    [kDefaultCenter removeObserver:self name:@"PushForMapVC" object:nil];
}


- (void)dealloc
{
    [kDefaultCenter removeObserver:self];
}

#pragma mark - 通知相应方法
- (void)pushForPictureVC:(NSNotification *)note
{
    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_ShopBanner"];
    NSInteger imageCount                = [[note.userInfo objectForKey:@"imageCount"] integerValue];
    int currentImageIndex               = [[note.userInfo objectForKey:@"currentImageIndex"] intValue];
    WJMerchantDetailModel *detailModel  = [note.userInfo objectForKey:@"detailModel"];
    
    WJShopPicturesViewController *picVC = [[WJShopPicturesViewController alloc] initWithNibName:nil bundle:nil];
    picVC.imageCount                    = imageCount;
    picVC.currentImageIndex             = currentImageIndex;
    picVC.detailModel                   = detailModel;
    [self.navigationController pushViewController:picVC animated:YES whetherJump:NO];
}

- (void)PushForMapVC:(NSNotification *)note
{
    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_ShopMap"];
    NSString *merchantLatitude          = [note.userInfo objectForKey:@"merchantLatitude"];
    NSString *merchantLongitude         = [note.userInfo objectForKey:@"merchantLongitude"];
    NSString *merchantAddress           = [note.userInfo objectForKey:@"merchantAddress"];
    NSString *merchantName              = [note.userInfo objectForKey:@"merchantName"];
    
    WJMerchantMapViewController *picVC  = [[WJMerchantMapViewController alloc] initWithNibName:nil bundle:nil];
    picVC.merchantLatitude              = merchantLatitude;
    picVC.merchantLongitude             = merchantLongitude;
    picVC.merchantAddress               = merchantAddress;
    picVC.merchantName                  = merchantName;
    [self.navigationController pushViewController:picVC animated:YES whetherJump:NO];
}


//分享页面
- (void)shareAction{
//    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_Share"];
//    [self showShareActionSheet:self.view];
    
   
    WJMerchantImageModel *merModel = [self.detailMerchant.imageArray objectAtIndex:0];
    [WJShare sendShareController:self
                                  LinkURL:self.detailMerchant.shareUrl
                                  TagName:@"TAG_MerchantDetail"
                                    Title:self.detailMerchant.shareTitle
                              Description:[self.detailMerchant.shareDesc stringByAppendingString:self.detailMerchant.shareUrl]
                               ThumbImage:merModel.imgUrl];
}

- (void)initContent{
    [self.view addSubview:self.mTb];
    [self.view VFLToConstraints:@"H:|[_mTb]|" views:NSDictionaryOfVariableBindings(_mTb)];
    [self.view VFLToConstraints:@"V:|[_mTb]|" views:NSDictionaryOfVariableBindings(_mTb)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - WJMerchantDetaiCellDelegate
- (void)clickTelButton:(NSString *)telPhone
{
    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_ShopTel"];
    UIActionSheet *actionSheet =  [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:telPhone, nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    phone = telPhone;
    [actionSheet showInView:self.view];
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [self callTelephone];
    }
}

- (void)callTelephone
{
    NSString *phoneS = [NSString stringWithFormat:@"tel://%@", phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneS]];
}

#pragma mark - Button Action

- (void)backBarButton:(UIButton *)btn {
    if (self.isMaxCode) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)moreBranch
{
    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_relatedmore"];
    WJRelationMerchantController *branchListC = [[WJRelationMerchantController alloc] init];
    branchListC.merId = self.detailMerchant.mainMerId;
    branchListC.title = @"相关门店";
    [self.navigationController pushViewController:branchListC animated:YES];
}

- (void)moreCardList{
    //商品卡列表
    WJCardListOfMerchantViewController *cardListVC = [[WJCardListOfMerchantViewController alloc] init];
    cardListVC.cardList = self.detailMerchant.productArray;
    cardListVC.merId = self.detailMerchant.merId;
    [self.navigationController pushViewController:cardListVC animated:YES];
}

#pragma mark - Request

- (void)requestLoad{
    [self showLoadingView];
    [self.merchantDetailManager loadData];
}


- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];

    NSDictionary *merchantDetail = [manager fetchDataWithReformer:nil];
    if ([merchantDetail isKindOfClass:[NSDictionary class]]) {
        self.detailMerchant = [[WJMerchantDetailModel alloc] initWithDic:merchantDetail];
//        [self coculationIntroduceHeight];
        [self initContent];

    }else{
        ALERT(@"请求失败，请重试！");
    }
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    ALERT(@"请求失败，请重试！");
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.intoCount >= 1) {
        return 4;
    }
    return 5;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSInteger count = 1;
    switch (section) {
        case 1:{
            
            if (self.detailMerchant.introduction.length != 0) {
                
                if (hiddenExplain) {
                    count = 1;
                }else{
                    count = 2;
                }
            } else {
                count = 0;
            }
        }
            break;
        case 3:{
            if (self.detailMerchant.productArray.count > 0) {
                count = self.detailMerchant.productArray.count+1;
                count = MIN(count, 4);
            } else {
                count = 0;
            }
        }
            break;
            
        case 4:{
            count = self.detailMerchant.branchNum + 1;
            if (self.detailMerchant.branchNum > 3) {
                count = 4;
            }
        }
            break;
            
        default:
            count = 1;
            break;
    }
    
    return count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 50;
    switch (indexPath.section) {
        case 0://图片和店名、地址
            if (self.detailMerchant.activityNum == 0 || self.detailMerchant.activity.count == 0) {
                height = ALD(353);
            }else{
                height = ALD(375);
            }
            break;
        case 1://店铺详情
            if (indexPath.row == 0) {
                height = ALD(53);
            }else{
                height = userExplaintHeight;
            }
            break;
        case 2://商家特权
            height = self.detailMerchant.privilegeArray.count == 0 ? 0 : ALD(93);
            break;
          
        case 3:{//商品橱窗
            if (self.detailMerchant.productArray.count != 0) {
                if (indexPath.row == 0) {
                    height = ALD(53);
                }else{
                    height = ALD(105);
                }
            }else{
                height = 0;
            }
        }
            break;
        case 4:{//相关门店
            if (self.detailMerchant.branchNum != 0) {
                
                if (indexPath.row == 0) {
                    height = ALD(53);
                }else{
                    height = ALD(95);
                }
            }else{
                height = 0;
            }
            
        }
            break;
            
        default:
            break;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            //图片，名称，营业时间，地址，电话
            WJMerchantDetailSummryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name"];
            
            if (!cell) {
                cell = [[WJMerchantDetailSummryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"name"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.delegate = self;
            [cell configCellWithMerchantModel:self.detailMerchant];
            
            return cell;
            
        }
            break;
        case 1:{
            //店铺详情
            if (indexPath.row == 0) {
                
                WJShopInfoTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"introduce"];
                if (!cell) {
                    cell = [[WJShopInfoTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"introduce"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                [cell configData:hiddenExplain cellTitle:@"店铺详情"];
                
                return cell;
                
            }else{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"introduceInfo"];
                
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"introduceInfo"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UIWebView *introduceL = [[UIWebView alloc] initForAutoLayout];
                    NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                                          "<head> \n"
                                          "<style type=\"text/css\"> \n"
                                          "body {font-size: 12px}\n"
                                          "</style> \n"
                                          "</head> \n"
                                          "<body>%@</body> \n"
                                          "</html>", self.detailMerchant.introduction];
                    [introduceL loadHTMLString:jsString baseURL:nil];
                    introduceL.delegate = self;
                    introduceL.scrollView.scrollEnabled = NO;
                    [cell.contentView addSubview:introduceL];
                    [cell.contentView addConstraints:[introduceL constraintsBottomInContainer:-3]];
                    [cell.contentView addConstraints:[introduceL constraintsTopInContainer:0]];
                    //                [cell.contentView addConstraints:[introduceL constraintsFillWidth]];
                    [cell.contentView VFLToConstraints:@"H:|-10-[introduceL]-10-|"
                                                 views:NSDictionaryOfVariableBindings(introduceL)];
                    cell.clipsToBounds = YES;
                    
                }
                
                return cell;
                
            }
            
        }
            break;
            
        case 2:{
            //商家特权
            WJCardDetailPrivilegeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"privilege"];
            
            if (!cell) {
                cell = [[WJCardDetailPrivilegeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"privilege"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.clipsToBounds = YES;
            }
            
            [cell configWithPrivileges:self.detailMerchant.privilegeArray isCard:NO];
            
            if ([self.detailMerchant.privilegeArray count] == 0) {
                [cell notHaveValue];
            }
            
            return cell;
            
        }
            break;
   
        case 3:{
            //商品橱窗
            if (indexPath.row == 0) {
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productTitle"];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productTitle"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UIView *titleBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(10))];
                    titleBg.backgroundColor = WJColorViewBg;
                    [cell.contentView addSubview:titleBg];
                    
                    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(9.5), kScreenWidth, ALD(0.5))];
                    topLine.backgroundColor = WJColorSeparatorLine;
                    [cell.contentView addSubview:topLine];
                    
                    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(0.5))];
                    bottomLine.backgroundColor = WJColorSeparatorLine;
                    [cell.contentView addSubview:bottomLine];
                    
                    UILabel *infoL = [[UILabel alloc]initWithFrame:CGRectMake(ALD(12), ALD(25), 200, ALD(16))];
                    infoL.backgroundColor = WJColorWhite;
                    infoL.text = @"商品橱窗";
                    infoL.font = WJFont14;
                    infoL.textColor = WJColorDarkGray;
                    [cell.contentView addSubview:infoL];
                    
                    UIView *topLine_1 = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), ALD(52.5), kScreenWidth - ALD(24), ALD(0.5))];
                    topLine_1.backgroundColor = WJColorSeparatorLine;
                    [cell.contentView addSubview:topLine_1];
                    
                    if (self.detailMerchant.productArray.count > 3) {
                        
                        UIButton *moreStore = [UIButton buttonWithType:UIButtonTypeCustom];
                        moreStore.frame = CGRectMake(kScreenWidth - ALD(90), ALD(10), ALD(90), ALD(43));
                        [moreStore setTitle:@"查看全部" forState:UIControlStateNormal];
                        [moreStore setTitleColor:WJColorLightGray forState:UIControlStateNormal];
                        [moreStore  setImage:[UIImage imageNamed:@"details_rightArrowIcon"] forState:UIControlStateNormal];
                        moreStore.titleEdgeInsets = UIEdgeInsetsMake(0, - moreStoreLeftEdgeMargin, 0, moreStoreRightEdgeMargin);
                        moreStore.imageEdgeInsets = UIEdgeInsetsMake(0, ALD(90)- ALD(20), 0, ALD(10));
                        moreStore.titleLabel.font = WJFont12;
                        [moreStore addTarget:self action:@selector(moreCardList) forControlEvents:UIControlEventTouchUpInside];
                        [cell.contentView addSubview:moreStore];
                    }
                }


                return cell;
                
            }else{
                
                WJCardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardList"];
                
                if (!cell) {
                    cell = [[WJCardListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cardList"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                [cell configWithProduct:self.detailMerchant.productArray[indexPath.row-1]];
                if (indexPath.row == self.detailMerchant.productArray.count || (indexPath.row == 3 && self.detailMerchant.productArray.count > 3)) {
                    cell.bottomLine.hidden = YES;
                }
                
                return cell;
            }
        }
            break;
  
        case 4:{
            //相关门店
            
            if (indexPath.row == 0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storeTitle"];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"storeTitle"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UIView *titleBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(10))];
                    titleBg.backgroundColor = WJColorViewBg;
                    [cell.contentView addSubview:titleBg];
                    
                    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(10), kScreenWidth, ALD(0.5))];
                    topLine.backgroundColor = WJColorSeparatorLine;
                    [cell.contentView addSubview:topLine];
                    
                    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(0.5))];
                    bottomLine.backgroundColor = WJColorSeparatorLine;
                    [cell.contentView addSubview:bottomLine];
                    
                    UIView *topLine_1 = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), ALD(52.5), kScreenWidth - ALD(24), ALD(0.5))];
                    topLine_1.backgroundColor = WJColorSeparatorLine;
                    [cell.contentView addSubview:topLine_1];
                    
                    UILabel *infoL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(25), ALD(200), ALD(16))];
                    infoL.text = @"相关门店";
                    infoL.font = WJFont14;
                    infoL.textColor = WJColorDarkGray;
                    [cell.contentView addSubview:infoL];
                    if (self.detailMerchant.branchNum > 3) {
                    
                        UIButton *moreStore = [UIButton buttonWithType:UIButtonTypeCustom];
                        moreStore.frame = CGRectMake(kScreenWidth - ALD(90), ALD(10), ALD(90), ALD(43));
                        [moreStore setTitle:@"查看全部" forState:UIControlStateNormal];
                        [moreStore setTitleColor:WJColorLightGray forState:UIControlStateNormal];
                        [moreStore  setImage:[UIImage imageNamed:@"details_rightArrowIcon"] forState:UIControlStateNormal];
                        moreStore.titleEdgeInsets = UIEdgeInsetsMake(0, - moreStoreLeftEdgeMargin, 0, moreStoreRightEdgeMargin);
                        moreStore.imageEdgeInsets = UIEdgeInsetsMake(0, ALD(90)- ALD(20), 0, ALD(10));
                        moreStore.titleLabel.font = WJFont12;
                        [moreStore addTarget:self action:@selector(moreBranch) forControlEvents:UIControlEventTouchUpInside];
                        [cell.contentView addSubview:moreStore];
                    }
                }

                return cell;
                
            }else{
                WJCardDetailFitStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"store"];
                
                if (!cell) {
                    cell = [[WJCardDetailFitStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"store"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.isOpenLocation = isOpenLocation;
                cell.store = self.detailMerchant.branchArray[indexPath.row-1];
                return cell;

            }
           
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        //特权
        if ([self.detailMerchant.privilegeArray count] == 0) {
            return;
        }
        WJWebViewController *webVC = [[WJWebViewController alloc] init];
        webVC.titleStr = @"特权说明";
        WJModelPerson * person = [WJGlobalVariable sharedInstance].defaultPerson;
        NSString * token = person.token?:@"";
        NSString *urlStr = [NSString stringWithFormat:@"http://e.wjika.com/tequan/?merchantId=%@&token=%@&privilegeType=%@",self.detailMerchant.mainMerId,token,@"merchant"];
        [webVC loadWeb:urlStr];
        [self.navigationController pushViewController:webVC animated:YES];
        
    }else if(indexPath.section == 1)
    {
        //店铺详情说明
        if (indexPath.row == 0) {
            if (hiddenExplain) {
                hiddenExplain = NO;
            }else{
                hiddenExplain = YES;
            }
            [self.mTb reloadData];
        }
        
    }else if(indexPath.section == 4)
    {
        if (indexPath.row > 0) {
            WJMerchantDetailController *vc = [WJMerchantDetailController new];
            vc.merId = [self.detailMerchant.branchArray[indexPath.row-1] storeId];
            vc.intoCount = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if(indexPath.section == 3)
    {
        if (indexPath.row == 0) {
            //商品橱窗
            
        }else{
            WJCardModel *model = self.detailMerchant.productArray[indexPath.row-1];
            WJHomeCardDetailsViewController *vc = [WJHomeCardDetailsViewController new];
            vc.merchantID = self.detailMerchant.merId;
            vc.cardID       = model.cardId;
            vc.cardIndex    = indexPath.row - 1;
            vc.titleStr     = model.merName;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


#pragma mark - 属性方法

- (UITableView *)mTb{
    if (_mTb == nil) {
        _mTb = [[UITableView alloc] initForAutoLayout];
        _mTb.delegate = self;
        _mTb.dataSource = self;
        _mTb.separatorInset = UIEdgeInsetsZero;
        _mTb.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTb.backgroundColor = WJColorViewBg;
    }
    return _mTb;
}


-(APIMerchantDetailManager *)merchantDetailManager{
    if (!_merchantDetailManager) {
        _merchantDetailManager = [[APIMerchantDetailManager alloc] init];
        _merchantDetailManager.delegate = self;
        _merchantDetailManager.merID = self.merId;
        _merchantDetailManager.merchantLatitude = [NSString stringWithFormat:@"%lf",[WJGlobalVariable sharedInstance].appLocation.latitude?:0];
        _merchantDetailManager.merchantLongitude = [NSString stringWithFormat:@"%lf",[WJGlobalVariable sharedInstance].appLocation.longitude?:0];
    }
    return _merchantDetailManager;
}
- (UIImageView *)shareImageView
{
    if (!_shareImageView) {
        _shareImageView = [[UIImageView alloc] init];
    }
    return _shareImageView;
}

#pragma mark - Logic

- (void)coculationIntroduceHeight{
    
    UIWebView *introduceL = [[UIWebView alloc] initWithFrame:CGRectMake(10, -10000, kScreenWidth, 100)];
    [introduceL loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailMerchant.introduction]]];
    introduceL.delegate = self;
    introduceL.tag = 500;
    [self.view insertSubview:introduceL belowSubview:self.mTb];
}

#pragma mark -GetLocationStatus
- (void)getLocationStatus
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        
        isOpenLocation = NO;
        
    }else{
        isOpenLocation = YES;
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    CGFloat height = [webView.scrollView contentSize].height;
    CGFloat webViewHeight= [[webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]floatValue];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#9099a6'"];
    userExplaintHeight = MAX(height, webViewHeight);
    [self.mTb reloadData];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([request.URL.absoluteString isEqualToString:@"about:blank"] ) {
        return YES;
    }
    return NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    //        NSLog(@"offsetYoffsetYoffsetY ===== %lf",offsetY);
    CGFloat tempOffset = ALD(350 - 64*3) ;
    if (offsetY > tempOffset) {
        CGFloat temp = ALD(350 - 64*2 - offsetY) ;
        navigationBarColor = WJColorNavigationBar;
        alpha = MIN(1, 1 - temp / ALD(64));
    } else {
        navigationBarColor = WJColorBlack;
        alpha = 0.3*MIN((tempOffset-offsetY)/ALD(32), 1);
    }
    [self.navigationController.navigationBar lt_setBackgroundColor:[navigationBarColor colorWithAlphaComponent:alpha]];

    
}

#pragma mark - 分享

- (void)showShareActionSheet:(UIView *)view
{
#pragma mark - ShareSDK
//    /**
//     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
//     **/
//    
//    WJMerchantImageModel *merModel = [self.detailMerchant.imageArray objectAtIndex:0];
//    //1、创建分享参数（必要）
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    //    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
//    [shareParams SSDKSetupShareParamsByText:[self.detailMerchant.shareDesc stringByAppendingString:self.detailMerchant.shareUrl]
//                                     images:@[merModel.imgUrl?:PlaceholderImage]
//                                        url:[NSURL URLWithString:self.detailMerchant.shareUrl]
//                                      title:self.detailMerchant.shareTitle
//                                       type:SSDKContentTypeAuto];
//    
//    //1.2、自定义分享平台（非必要）
//    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:@[@(SSDKPlatformSubTypeWechatSession),
//                                                                       @(SSDKPlatformSubTypeWechatTimeline),
//                                                                       @(SSDKPlatformSubTypeQQFriend),
//                                                                       @(SSDKPlatformTypeSinaWeibo)]];
//    [SSUIShareActionSheetStyle setCancelButtonLabelColor:WJColorBlack];
//    
//    //2、分享
//    [ShareSDK showShareActionSheet:view
//                             items:activePlatforms
//                       shareParams:shareParams
//               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                   
//                   switch (state) {
//                           
//                       case SSDKResponseStateBegin:
//                       {
//                           //                           [weakSelf showLoadingView:YES];
//                           break;
//                       }
//                       case SSDKResponseStateSuccess:
//                       {
//                            
//                           WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil
//                                                                                       message:@"分享成功"
//                                                                                      delegate:self
//                                                                             cancelButtonTitle:@"确定"
//                                                                             otherButtonTitles:nil
//                                                                                 textAlignment:NSTextAlignmentCenter];
//
//                           [alert showIn];
//                           
//                           break;
//                       }
//                       case SSDKResponseStateFail:
//                       {
//                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
//                           {
//                               
//                               
//                               WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil
//                                                                                           message:@"分享失败\n失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
//                                                                                          delegate:self
//                                                                                 cancelButtonTitle:@"OK"
//                                                                                 otherButtonTitles:nil
//                                                                                     textAlignment:NSTextAlignmentCenter];
//
//                               
//                               [alert showIn];
//                               
//                               break;
//                           }
//                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
//                           {
//                               
//                               WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil
//                                                                                           message:@"分享失败\n失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用。"
//                                                                                          delegate:self
//                                                                                 cancelButtonTitle:@"OK"
//                                                                                 otherButtonTitles:nil
//                                                                                     textAlignment:NSTextAlignmentCenter];
//
//                               [alert showIn];
//                               
//                               break;
//                           }
//                           else
//                           {
//                               
//                               WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil
//                                                                                           message:[NSString stringWithFormat:@"分享失败\n%@",error]
//                                                                                          delegate:self
//                                                                                 cancelButtonTitle:@"OK"
//                                                                                 otherButtonTitles:nil
//                                                                                     textAlignment:NSTextAlignmentCenter];
//                               
//                               [alert showIn];
//                               
//                               break;
//                           }
//                           
//                           break;
//                       }
//                       case SSDKResponseStateCancel:
//                       {
//                           
////                           WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil
////                                                                                       message:@"分享已取消"
////                                                                                      delegate:self
////                                                                             cancelButtonTitle:@"确定"
////                                                                             otherButtonTitles:nil
////                                                                                 textAlignment:NSTextAlignmentCenter];
////                           
////                           [alert showIn];
//                           break;
//                       }
//                       default:
//                           break;
//                   }
//                   
//                   if (state != SSDKResponseStateBegin)
//                   {
//                       //                       [theController showLoadingView:NO];
//                       //                       [theController.tableView reloadData];
//                   }
//                   
//               }];
}


@end


