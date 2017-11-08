//
//  WJHomeCardDetailsViewController.m
//  WanJiCard
//
//  Created by silinman on 16/5/31.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJHomeCardDetailsViewController.h"
#import "WJCardDetailsFlowLayout.h"
#import "WJCardsDetailTitleTableViewCell.h"
#import "WJMemberPrivilegeTableViewCell.h"
#import "WJCardShowTableViewCell.h"
#import "WJCardDetailFitStoreCell.h"
#import "APIProductDetailManager.h"
#import "WJCardDetailReformer.h"
#import "WJMerchantCardDetailModel.h"
#import "WJCardModel.h"
#import "WJStoreModel.h"
#import "WJCardDetailPrivilegeCell.h"
#import "WJShare.h"
#import "WJSystemAlertView.h"
#import "WJMerchantDetailController.h"
#import "WJOrderConfirmController.h"
#import "WJShopInfoTitleTableViewCell.h"
#import "WJRelationMerchantController.h"
#import "WJLoginViewController.h"
#import "WJRealNameAuthenticationViewController.h"
#import "LocationManager.h"
#import "WJModelArea.h"
#import "WJWebViewController.h"
#import "WJStatisticsManager.h"
#import "WJVerificationReceiptMoneyController.h"

@interface WJHomeCardDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,WJSystemAlertViewDelegate,APIManagerCallBackDelegate,UIActionSheetDelegate>{

    WJSystemAlertView *realNameAlertView;
    BOOL    hiddenExplain;
}

@property (nonatomic, assign)CGFloat        explainHeight;
@property (nonatomic, strong)UITableView    *tableView;
@property (nonatomic, strong)UIView         *buyView;
@property (nonatomic, strong)UILabel        *lineL;
@property (nonatomic, strong)UILabel        *moneyTitleL;
@property (nonatomic, strong)UILabel        *moneyL;
@property (nonatomic, strong)UIButton       *moneyBtn;
@property (nonatomic, strong)UIImageView    *arrowImageView;
@property (nonatomic, strong)UIImageView    *shareImageView;

@property (nonatomic, strong) APIProductDetailManager   *productDetailManager;
@property (nonatomic, strong) WJMerchantCardDetailModel *merchantCardDetailModel;
@end

@implementation WJHomeCardDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _titleStr;
    hiddenExplain = YES;
    [kDefaultCenter addObserver:self selector:@selector(requestData) name:@"LogOutToProductCardDetail" object:nil];
    [self registerNotification];
    [self UISetup];
    [self requestData];
    
    self.eventID = @"iOS_vie_Carddetails";
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)requestData{
    [self showLoadingView];
    [self.productDetailManager loadData];
}


- (void)dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)hintRealNameAuthenticationView
{
    [self requestData];
    
    WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
    
    if (defaultPerson.authentication == AuthenticationNo) {
        
        NSString *msg = @"为保障您的帐户安全，\n请尽快完成实名认证！";
        
        if (realNameAlertView == nil) {
            
            realNameAlertView = [[WJSystemAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"立即实名" textAlignment:NSTextAlignmentCenter];
            
            [realNameAlertView showIn];
            
        } else {
            
            [realNameAlertView showIn];
        }
    }
}


#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    NSLog(@"成功");
    self.merchantCardDetailModel = [manager fetchDataWithReformer:[[WJCardDetailReformer alloc] init]];
    NSLog(@"newsListArray = %@",self.merchantCardDetailModel);
    int tempId = 0;
    for (WJCardModel *cardModel in self.merchantCardDetailModel.cardArray) {
        if ([self.cardID isEqualToString:cardModel.cardId]) {
            self.cardIndex = tempId;
            break;
        }
        tempId ++;
    }
    [self refershUI];
    [self hiddenLoadingView];
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    NSLog(@"失败");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerNotification{
    
    __weak typeof(self) weakSelf = self;

    //滑动会员卡切换数据
    [kDefaultCenter addObserverForName:@"ChangeCardData" object:nil queue:nil usingBlock:^(NSNotification *note) {
        __strong typeof(self) strongSelf = weakSelf;
        NSInteger pageStr = [[note.userInfo objectForKey:@"key"] integerValue];
//        NSInteger cardNum = [[note.userInfo objectForKey:@"cardNum"] integerValue];
        strongSelf.explainHeight = 0;
        strongSelf.cardIndex = pageStr;
        [strongSelf refershUI];
    }];
    
}
- (void)UISetup{
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, ALD(19), ALD(19));
    [rightButton setImage:[UIImage imageNamed:@"nav_btn_share_nor"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.view.backgroundColor = WJColorWhite;
    
    [self.view addSubview:self.tableView];

    _buyView = [[UIView alloc] initForAutoLayout];
    _buyView.backgroundColor = WJColorWhite;
    [self.view addSubview:self.buyView];

    _lineL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(0.5))];
    _lineL.backgroundColor = WJColorSeparatorLine;
    [self.buyView addSubview:self.lineL];
    
    _moneyTitleL = [[UILabel alloc] initWithFrame:CGRectZero];
    _moneyTitleL.text = @"特价：";
    _moneyTitleL.font = WJFont14;
    _moneyTitleL.textColor = WJColorDarkGray;
    CGFloat titleLwidth = [UILabel getWidthWithTitle:_moneyTitleL.text font:_moneyTitleL.font];
    _moneyTitleL.frame = CGRectMake(ALD(12), 0, titleLwidth, ALD(47));
    [self.buyView addSubview:self.moneyTitleL];
    
    _moneyL = [[UILabel alloc] initWithFrame:CGRectZero];
    _moneyL.font = WJFont14;
    _moneyL.textColor = WJColorAmount;
    [self.buyView addSubview:self.moneyL];
    
    _moneyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _moneyBtn.layer.cornerRadius = 5.0f;
    _moneyBtn.backgroundColor = WJColorNavigationBar;
    [_moneyBtn setTitleColor:WJColorWhite forState:UIControlStateNormal];
    _moneyBtn.titleLabel.font = WJFont14;
    _moneyBtn.frame = CGRectMake(ALD(260), ALD(8), ALD(100), ALD(35));
//    _moneyBtn.layer.masksToBounds = YES;
    [_moneyBtn addTarget:self action:@selector(buyTheCard) forControlEvents:UIControlEventTouchUpInside];
    [self.buyView addSubview:self.moneyBtn];
    
    
    [self.view VFLToConstraints:@"H:|-0-[_tableView]-0-|" views:NSDictionaryOfVariableBindings(_tableView)];
    [self.view VFLToConstraints:@"H:|-0-[_buyView]-0-|" views:NSDictionaryOfVariableBindings(_buyView)];
    [self.view addConstraint:[_tableView constraintTopEqualToView:self.view]];
    [self.view addConstraints:[_tableView constraintsBottom:0 FromView:_buyView]];
    [self.view addConstraints:[_buyView constraintsAssignBottom]];
    [self.view addConstraint:[_buyView constraintHeight:ALD(48)]];
    
    self.buyView.hidden = YES;
}
- (void)refershUI{
    
    [self.tableView reloadData];

    if (self.merchantCardDetailModel.cardArray.count == 0 || self.merchantCardDetailModel.cardArray == nil) {
        self.buyView.hidden = YES;
        return;
    }else{
        self.buyView.hidden = NO;
    }
    
    WJCardModel *model = [self.merchantCardDetailModel.cardArray objectAtIndex:self.cardIndex];
    
    //isMyCard = 1,表示用户没有这张卡,2表示有
    if (self.merchantCardDetailModel.isMyCard == 1) {
        [_moneyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    }else{
        [_moneyBtn setTitle:@"去充值" forState:UIControlStateNormal];
    }
    if ([model.isLimitForSale isEqualToString:@"1"]) {
//        [_moneyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        _moneyL.text = [NSString stringWithFormat:@"￥%@",model.price];
        CGFloat moneywidth = [UILabel getWidthWithTitle:_moneyL.text font:_moneyL.font];
        _moneyL.frame = CGRectMake(_moneyTitleL.right, 0, moneywidth, ALD(47));
    }else{
        _moneyL.text = [NSString stringWithFormat:@"￥%@",model.salePrice];
        CGFloat moneywidth = [UILabel getWidthWithTitle:_moneyL.text font:_moneyL.font];
        _moneyL.frame = CGRectMake(_moneyTitleL.right, 0, moneywidth, ALD(47));
    }
}
- (void)shareAction{
    WJCardModel *cardModel = [self.merchantCardDetailModel.cardArray objectAtIndex:self.cardIndex];
    
    [WJShare sendShareController:self
                         LinkURL:self.merchantCardDetailModel.shareInfoDic[@"Url"]
                         TagName:@"TAG_CardDetail"
                           Title:self.merchantCardDetailModel.shareInfoDic[@"Title"]
                     Description:self.merchantCardDetailModel.shareInfoDic[@"Desc"]
                      ThumbImage:cardModel.cardCoverUrl];
}
#pragma mark - 分享

- (void)showShareActionSheet:(UIView *)view
{
#pragma mark - ShareSDK
//    /**
//     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
//     **/
//    if (self.merchantCardDetailModel.cardArray.count == 0) {
//        return;
//    }
//    WJCardModel *cardModel = [self.merchantCardDetailModel.cardArray objectAtIndex:self.cardIndex];
//    
//    //1、创建分享参数（必要）
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    [shareParams SSDKSetupShareParamsByText:[self.merchantCardDetailModel.shareInfoDic[@"Desc"] stringByAppendingString:self.merchantCardDetailModel.shareInfoDic[@"Url"]]
//                                     images:@[cardModel.cardCoverUrl?:PlaceholderImage]
//                                        url:self.merchantCardDetailModel.shareInfoDic[@"Url"]
//                                      title:self.merchantCardDetailModel.shareInfoDic[@"Title"]
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
//                           break;
//                           
//                       case SSDKResponseStateSuccess:
//                       {
//                           
//                           WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil message:@"分享成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil textAlignment:NSTextAlignmentCenter];
//                           [alert showIn];
//                           break;
//                       }
//                           
//                       case SSDKResponseStateFail:
//                       {
//                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
//                           {
//                               
//                               WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil message:@"分享失败\n失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil textAlignment:NSTextAlignmentCenter];
//                               [alert showIn];
//                               
//                               break;
//                           }
//                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
//                           {
//                               WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil message:@"分享失败\n失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil textAlignment:NSTextAlignmentCenter];
//                               [alert showIn];
//                               
//                               break;
//                           }
//                           else
//                           {
//                               WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"分享失败\n%@",error] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil textAlignment:NSTextAlignmentCenter];
//                               [alert showIn];
//                               
//                               break;
//                           }
//                           break;
//                       }
//                       case SSDKResponseStateCancel:
//                       {
////                           WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil message:@"分享已取消" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil textAlignment:NSTextAlignmentCenter];
////                           [alert showIn];
//                           
//                           break;
//                       }
//                       default:
//                           break;
//                   }
//                   
//               }];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.merchantCardDetailModel.cardArray.count == 0 ||
        self.merchantCardDetailModel.cardArray == nil) {
        return 0;
    }
    return 5;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.merchantCardDetailModel.cardArray.count == 0 ||
        self.merchantCardDetailModel.cardArray == nil) {
        return 0;
    }
    NSInteger  cellCount;
    switch (section) {
        case 0:
            cellCount = 1;
            break;
        case 1:
            cellCount = 1;
            break;
        case 2:
            cellCount = 1;
            break;
        case 3:
            if (hiddenExplain) {
                cellCount = 1;
            }else{
                cellCount = 2;
            }
            break;
        case 4:
            if (self.merchantCardDetailModel.supportStoreArray.count > 3) {
                cellCount = 4;
            }else{
                NSInteger counts = self.merchantCardDetailModel.supportStoreArray.count;
                cellCount = counts + 1;
            }
            break;
            
        default:
            break;
    }
    return cellCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.merchantCardDetailModel.cardArray.count == 0 || self.merchantCardDetailModel.cardArray == nil) {
        return 0;
    }
    CGFloat cellHeight;
    switch (indexPath.section) {
        case 0:
            cellHeight = ALD(230);
            break;
        case 1:{
            WJCardModel *model = [self.merchantCardDetailModel.cardArray objectAtIndex:self.cardIndex];
            if ([model.isLimitForSale isEqualToString:@"1"]) {
                cellHeight = ALD(115);
            }else{
                cellHeight = ALD(85);
            }
        }
            break;
        case 2:{
            WJCardModel *model = [self.merchantCardDetailModel.cardArray objectAtIndex:self.cardIndex];

            if (model.privilegeArray.count > 0) {
                cellHeight = ALD(93);
            }else{
                cellHeight = 0;
            }
        }
            break;
        case 3:
            if (indexPath.row == 0) {
                cellHeight = ALD(53);
            }else{
                if (_explainHeight > 0) {
                    cellHeight = _explainHeight;
                }else{
                    cellHeight = 0;
                }
            }
            break;
        case 4:
            
            if (indexPath.row == 0) {
                cellHeight = ALD(53);
            }else{
                cellHeight = ALD(95);
            }
            
            break;
        default:
            cellHeight = 0;
            break;
    }
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.merchantCardDetailModel.cardArray.count == 0 ||
        self.merchantCardDetailModel.cardArray == nil) {
        return nil;
    }
    WJCardModel *model = [self.merchantCardDetailModel.cardArray objectAtIndex:self.cardIndex];
    if (indexPath.section == 0) {
        WJCardShowTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WJCardShowTableViewCell"];
        if (nil == cell) {
            cell = [[WJCardShowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WJCardShowTableViewCell"];
        }
        [cell configData:self.merchantCardDetailModel cardIndex:self.cardIndex cardID:self.cardID];
        
        return cell;
    }else if (indexPath.section == 1) {
        WJCardsDetailTitleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WJCardsDetailTitleTableViewCell"];
        if (nil == cell) {
            cell = [[WJCardsDetailTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WJCardsDetailTitleTableViewCell"];
        }
        WJCardModel *cardmodel = [self.merchantCardDetailModel.cardArray objectAtIndex:self.cardIndex];
        [cell configData:cardmodel];
        return cell;
    }else if (indexPath.section == 2) {
        //特权
        WJCardDetailPrivilegeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"privilege"];
        
        if (!cell) {
            cell = [[WJCardDetailPrivilegeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"privilege"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.clipsToBounds = YES;
        }
        WJCardModel *cardmodel = [self.merchantCardDetailModel.cardArray objectAtIndex:self.cardIndex];
        [cell configWithPrivileges:cardmodel.privilegeArray isCard:YES];
        
        return cell;
    }else if (indexPath.section == 3) {
        //使用说明

        if (indexPath.row == 0) {
            
            WJShopInfoTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"introduce"];
            if (!cell) {
                cell = [[WJShopInfoTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"introduce"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell configData:hiddenExplain cellTitle:@"使用说明"];

            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"introduceL"];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"introduceL"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIWebView *introduceL = [[UIWebView alloc] initForAutoLayout];
                
                NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                                      "<head> \n"
                                      "<style type=\"text/css\"> \n"
                                      "body {font-size: 12px;}\n"
                                      "</style> \n"
                                      "</head> \n"
                                      "<body>%@</body> \n"  
                                      "</html>", model.useExplain];
                [introduceL loadHTMLString:jsString baseURL:nil];
                introduceL.delegate = self;
                introduceL.scrollView.scrollEnabled = NO;
                [cell.contentView addSubview:introduceL];
                [cell.contentView addConstraints:[introduceL constraintsBottomInContainer:-3]];
                [cell.contentView addConstraints:[introduceL constraintsTopInContainer:0]];
                //                [cell.contentView addConstraints:[introduceL constraintsFillWidth]];
                [cell.contentView VFLToConstraints:@"H:|-12-[introduceL]-12-|"
                                             views:NSDictionaryOfVariableBindings(introduceL)];
                cell.clipsToBounds = YES;
                
            }

            return cell;
        }
        
    }else if (indexPath.section == 4) {
        //适用门店
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storeTitle"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"storeTitle"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
                UIView *titleBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(10))];
                titleBg.backgroundColor = WJColorViewBg;
                [cell.contentView addSubview:titleBg];
                
                UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(0.5))];
                topLine.backgroundColor = WJColorSeparatorLine;
                [cell.contentView addSubview:topLine];
                
                UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(9.5), kScreenWidth, ALD(0.5))];
                bottomLine.backgroundColor = WJColorSeparatorLine;
                [cell.contentView addSubview:bottomLine];
                
                UIView *topLine_1 = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), ALD(52.5), kScreenWidth - ALD(24), ALD(0.5))];
                topLine_1.backgroundColor = WJColorSeparatorLine;
                [cell.contentView addSubview:topLine_1];
                
                UILabel *infoL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(23), ALD(150), ALD(16))];
                infoL.text = @"适用门店";
                infoL.font = WJFont14;
                infoL.textColor = WJColorDarkGray;
                [cell.contentView addSubview:infoL];
                
                UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(18), ALD(28),ALD(6), ALD(11))];
                arrowImageView.image =[UIImage imageNamed:@"details_rightArrowIcon"];
                [cell.contentView addSubview:arrowImageView];
                
                UILabel *infosL = [[UILabel alloc] initWithFrame:CGRectMake(arrowImageView.x - ALD(10) - ALD(200), ALD(25), ALD(200), ALD(16))];
                infosL.text = [NSString stringWithFormat:@"共%ld家门店可用",(long)self.merchantCardDetailModel.supportStoreNum];
                infosL.font = WJFont12;
                infosL.textAlignment = NSTextAlignmentRight;
                infosL.textColor = WJColorLightGray;
                [cell.contentView addSubview:infosL];
            }

            
            return cell;
            
        }else{
            WJCardDetailFitStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"store"];
            WJStoreModel *storeModel = [self.merchantCardDetailModel.supportStoreArray objectAtIndex:indexPath.row - 1];
            if (!cell) {
                cell = [[WJCardDetailFitStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"store"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.store = storeModel;
            return cell;
            
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            if (hiddenExplain) {
                hiddenExplain = NO;
            }else{
                hiddenExplain = YES;
            }
            [self.tableView reloadData];
        }
    }else if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            //适用门店界面
            [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_allStores"];
            WJRelationMerchantController *branchListC = [[WJRelationMerchantController alloc] init];
            branchListC.merId = self.merchantCardDetailModel.merId;
            branchListC.title = @"适用门店";
            [self.navigationController pushViewController:branchListC animated:YES];
            
        }else{
            WJStoreModel *model = [self.merchantCardDetailModel.supportStoreArray objectAtIndex:indexPath.row - 1];
            WJMerchantDetailController *vc = [WJMerchantDetailController new];
            vc.merId = model.storeId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 2){
        [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_PrivilegeExplain"];
        //特权
        WJWebViewController *webVC = [[WJWebViewController alloc] init];
        webVC.titleStr = @"特权说明";
        WJModelPerson * person = [WJGlobalVariable sharedInstance].defaultPerson;
        NSString * token = person.token?:@"";
        NSString *urlStr = [NSString stringWithFormat:@"http://e.wjika.com/tequan/?merchantId=%@&token=%@&privilegeType=%@",self.merchantCardDetailModel.mainMerId,token,@"merchant"];
        [webVC loadWeb:urlStr];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    CGFloat height = [webView.scrollView contentSize].height;
    CGFloat webViewHeight= [[webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]floatValue];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#9099a6'"];
    _explainHeight = MAX(height, webViewHeight);
    [self.tableView reloadData];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([request.URL.absoluteString isEqualToString:@"about:blank"] ) {
        return YES;
    }
    return NO;
}

#pragma mark - WJSystemAlertViewDelegate

- (void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 1) {
        
        NSString *record = [[NSUserDefaults standardUserDefaults] valueForKey:@"RealNameReciveMoneyRecord"];
        
        if (!record) {
            
            WJRealNameAuthenticationViewController *realNameAuthenticationVC = [[WJRealNameAuthenticationViewController alloc] init];
            realNameAuthenticationVC.comefrom = ComeFromProductDetail;
            realNameAuthenticationVC.isjumpOrderConfirmController = NO;
            [WJGlobalVariable sharedInstance].realAuthenfromController = self;
            [self.navigationController pushViewController:realNameAuthenticationVC animated:YES];
            
        } else {
            
            
            //收款金额验证
            WJVerificationReceiptMoneyController *verificationReceiptMoneyController = [[WJVerificationReceiptMoneyController alloc] init];
            [WJGlobalVariable sharedInstance].realAuthenfromController = self;
            verificationReceiptMoneyController.comefrom = ComeFromProductDetail;
            verificationReceiptMoneyController.isjumpOrderConfirmController = NO;
            verificationReceiptMoneyController.BankCard = record;
            [self.navigationController pushViewController:verificationReceiptMoneyController animated:YES];
            

        }
        
    }
}

#pragma mark- 点击事件
//立即购买
- (void)buyTheCard{
    
    WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
    
    //判断是否登录
    if (defaultPerson) {
        
        if (defaultPerson.authentication == AuthenticationNo) {
            
            NSString *record = [[NSUserDefaults standardUserDefaults] valueForKey:@"RealNameReciveMoneyRecord"];
            
            if (!record) {
                
                WJRealNameAuthenticationViewController *realNameAuthenticationVC = [[WJRealNameAuthenticationViewController alloc] init];
                realNameAuthenticationVC.comefrom = ComeFromProductDetail;
                realNameAuthenticationVC.isjumpOrderConfirmController = YES;
                [WJGlobalVariable sharedInstance].realAuthenfromController = self;
                [self.navigationController pushViewController:realNameAuthenticationVC animated:YES];
                
                __weak typeof(self )weakSelf = self;
                [realNameAuthenticationVC setRealNameAuthenticationSuc:^(void){
                    
                    __strong typeof(self) strongSelf = weakSelf;
                    [strongSelf goToOrderConfirmController];
                }];
                
            } else {
                
                //收款金额验证
                WJVerificationReceiptMoneyController *verificationReceiptMoneyController = [[WJVerificationReceiptMoneyController alloc] init];
                [WJGlobalVariable sharedInstance].realAuthenfromController = self;
                verificationReceiptMoneyController.comefrom = ComeFromProductDetail;
                verificationReceiptMoneyController.isjumpOrderConfirmController = YES;
                verificationReceiptMoneyController.BankCard = record;
                [self.navigationController pushViewController:verificationReceiptMoneyController animated:YES];
                
                
                __weak typeof(self) weakSelf = self;
                [verificationReceiptMoneyController setAuthenticationSuc:^(void){
                    
                    __strong typeof(self) strongSelf = weakSelf;
                    [strongSelf goToOrderConfirmController];
                    
                }];
                
            }
            
        } else {

            [self goToOrderConfirmController];
        }

    }else{
    
        //去登陆
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hintRealNameAuthenticationView) name:@"LoginForBuyCard" object:nil];

        WJLoginViewController *loginVC = [[WJLoginViewController alloc] init];
        loginVC.from = LoginFromBuyCard;
        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

- (void)goToOrderConfirmController
{
    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_Buynow"];
    [WJGlobalVariable sharedInstance].payfromController = self;
    WJCardModel *cardModel = [self.merchantCardDetailModel.cardArray objectAtIndex:self.cardIndex];
    if ([cardModel.isLimitForSale isEqualToString:@"1"] ||
        self.merchantCardDetailModel.isMyCard == 1) {
        //立即购买,merID传分店id
        WJOrderConfirmController *vc = [[WJOrderConfirmController alloc] initWithCardId:cardModel.cardId
                                                                               cardName:cardModel.name
                                                                                  merID:self.merchantID
                                                                                merName:cardModel.merName
                                                                                buyType:BuyTypeOrder];
        
        vc.currentCard = cardModel;
        vc.isLimitForSale = cardModel.isLimitForSale?:@"0";
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        
        //去充值,merID传主店id
        WJOrderConfirmController *vc = [[WJOrderConfirmController alloc] initWithCardId:nil
                                                                               cardName:cardModel.name
                                                                                  merID:self.merchantCardDetailModel.merId
                                                                                merName:cardModel.merName
                                                                                buyType:BuyTypeCharge];

    
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark- Getter and Setter
- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initForAutoLayout];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (APIProductDetailManager *)productDetailManager
{
    if (!_productDetailManager) {
        _productDetailManager = [[APIProductDetailManager alloc] init];
        _productDetailManager.delegate = self;
        _productDetailManager.proID = self.cardID;
        if ([WJGlobalVariable sharedInstance].appLocation.longitude == 0 || [WJGlobalVariable sharedInstance].appLocation.latitude == 0) {
            _productDetailManager.longitude = [LocationManager sharedInstance].choosedArea.lng;
            _productDetailManager.latitude = [LocationManager sharedInstance].choosedArea.lat;
        }else{
            _productDetailManager.longitude = [WJGlobalVariable sharedInstance].appLocation.longitude;
            _productDetailManager.latitude = [WJGlobalVariable sharedInstance].appLocation.latitude;
        }
    }
    return _productDetailManager;
}
- (UIImageView *)shareImageView
{
    if (!_shareImageView) {
        _shareImageView = [[UIImageView alloc] init];
    }
    return _shareImageView;
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
