//
//  WJProductDetailController.m
//  WanJiCard
//
//  Created by Harry Hu on 15/8/31.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJProductDetailController.h"
#import "WJPrivilegeController.h"
#import "WJMerchantDetailController.h"
#import "WJOrderConfirmController.h"
#import "WJRelationMerchantController.h"

#import "WJCardDetailSummaryCell.h"
#import "WJCardDetailPrivilegeCell.h"
#import "WJCardDetailFitStoreCell.h"

#import "WJCardDetailModel.h"
#import "WJModelCard.h"
#import "WJDBCardManager.h"

#import "APICardDetailManager.h"
#import "WJCardDetailReformer.h"

#import "APIProductDetailManager.h"

#import "ShareManager.h"


#import "WJAlertView.h"
#import "WJRealNameAuthenticationViewController.h"

@interface WJProductDetailController ()<UITableViewDataSource, UITableViewDelegate,
APIManagerCallBackDelegate, UIWebViewDelegate,WJAlertViewDelegate>{
    CGFloat userExplaintHeight;
}

@property (nonatomic, strong) UITableView *mTb;
@property (nonatomic, strong) WJCardDetailModel         *detailCard;
@property (nonatomic, strong) APICardDetailManager      *cardDetailManager;
@property (nonatomic, strong) APIProductDetailManager   *productDetailManager;

@property (nonatomic, strong) UIImageView   * shareImageView;
@end

@implementation WJProductDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.card.name;
    self.eventID = @"iOS_act_bizcarddetails";

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 22, 22);
    [rightBtn setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    [self requestLoad];
}



- (void)initContent {
    [self.view addSubview:self.mTb];
    
    self.title = self.detailCard.name;

    
    UIView *bottom = [[UIView alloc] initForAutoLayout];
    bottom.backgroundColor = WJColorViewBg2;
    [self.view addSubview:bottom];
    
    UILabel *amountL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, ALD(57))];
    amountL.textColor = WJColorDardGray3;
    amountL.font = WJFont13;
    if (self.detailCard.isLimitForSale) {
        amountL.text = [NSString stringWithFormat:@"￥%@",[WJUtilityMethod floatNumberForMoneyFomatter:self.detailCard.price]];
        
    } else {
        amountL.text = [NSString stringWithFormat:@"￥%@",[WJUtilityMethod floatNumberForMoneyFomatter:self.detailCard.salePrice]];
        
    }
    [bottom addSubview:amountL];

    
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.translatesAutoresizingMaskIntoConstraints = NO;
    [payButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [payButton setBackgroundColor:WJColorNavigationBar];
    payButton.layer.cornerRadius = 4;
    payButton.titleLabel.font = WJFont15;
    [payButton addTarget:self action:@selector(paymentRightNowAction) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:payButton];
    
    [bottom addConstraints:[payButton constraintsSize:CGSizeMake(90, ALD(41))]];
    [bottom addConstraint:[payButton constraintCenterYEqualToView:bottom]];
    [bottom addConstraints:[payButton constraintsRightInContainer:10]];
    
    [self.view VFLToConstraints:@"H:|-0-[_mTb]-0-|" views:NSDictionaryOfVariableBindings(_mTb)];
    [self.view VFLToConstraints:@"H:|-0-[bottom]-0-|" views:NSDictionaryOfVariableBindings(bottom)];
    [self.view addConstraint:[_mTb constraintTopEqualToView:self.view]];
    [self.view addConstraints:[_mTb constraintsBottom:0 FromView:bottom]];
    [self.view addConstraints:[bottom constraintsAssignBottom]];
    [self.view addConstraint:[bottom constraintHeight:ALD(57)]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Button Action

- (void)shareBtnAction{
    NSLog(@"分享");
    [self showShareActionSheet:self.view];
    
}

- (void)moreBranch
{
    WJRelationMerchantController *branchListC = [[WJRelationMerchantController alloc] init];
    branchListC.merId = self.detailCard.mainMerId;
    branchListC.title = @"此卡劵适用的门店";
    [self.navigationController pushViewController:branchListC animated:YES];
}

- (void)paymentRightNowAction{
    NSLog(@"购卡");
    
    WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
    
    if (defaultPerson.authentication == AuthenticationNo) {
        
        WJRealNameAuthenticationViewController *realNameAuthenticationVC = [[WJRealNameAuthenticationViewController alloc] init];
        realNameAuthenticationVC.comefrom = ComeFromProductDetail;
        [WJGlobalVariable sharedInstance].fromController = self;
        [self.navigationController pushViewController:realNameAuthenticationVC animated:YES];
        
        __weak typeof(self) weakSelf = self;
        [realNameAuthenticationVC setRealNameAuthenticationSuc:^(void){
            
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf fromBuyCardToOrderConfirmController];
        }];
        
    }  else {
        
        [self fromBuyCardToOrderConfirmController];
    }
    
}

- (void)fromBuyCardToOrderConfirmController
{
    WJOrderConfirmController *vc = [[WJOrderConfirmController alloc] initWithCardId:self.card.cardId cardName:self.card.name buyType:BuyTypeOrder];
    //    vc.amountPer = self.detailCard.salePrice;
    vc.originalPrice = self.card.salePrice;
    vc.Price = self.detailCard.price;
    vc.merID = self.card.merId;
    vc.merchantCardId = self.card.cardId;
    vc.merName = self.detailCard.merName?:self.card.merName;
    vc.activityId = self.detailCard.activityId;
    vc.isLimitForSale = self.detailCard.isLimitForSale;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Request

- (void)requestLoad{

    [self showLoadingView];

    [self.productDetailManager loadData];

}

- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    self.detailCard = [manager fetchDataWithReformer:[[WJCardDetailReformer alloc] init]];
    [self.shareImageView sd_setImageWithURL:[NSURL URLWithString:self.detailCard.cardCoverUrl]
                           placeholderImage:[UIImage imageNamed:@"topic_default"]];
    [self initContent];

}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    ALERT(manager.errorMessage);
}


#pragma mark - UITableView


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        NSInteger count = MIN(self.detailCard.supportStoreArray.count+1, 4);
        if (self.detailCard.supportStoreArray.count < self.detailCard.supportStoreNum) {
            count += 1;
        }
        return count;
    }
    
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 50;
    switch (indexPath.section) {
        case 0:
            height = ALD(236);
            break;
            
        case 1:
            height = ALD(105);
            break;
            
//        case 2:
//            height = ALD(110);
//            break;
            
        case 2:
            height = userExplaintHeight+ALD(60);
            break;
            
        case 3:{
            if (indexPath.row == 0 || indexPath.row == (MIN(self.detailCard.supportStoreArray.count+2, 5)-1)) {
                height = ALD(45);
            }else{
                height = ALD(95);
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
            //卡片照片
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardPic"];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cardPic"];
                cell.backgroundColor = WJColorViewBg;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIImageView *picIV = [[UIImageView alloc] initForAutoLayout];
                picIV.contentMode = UIViewContentModeScaleAspectFit;
                [picIV setImage:[WJGlobalVariable cardBgImageByType:self.detailCard.cType]];
                [cell.contentView addSubview:picIV];
                [cell.contentView addConstraints:[picIV constraintsSize:CGSizeMake(ALD(345), ALD(206))]];
                [cell.contentView addConstraints:[picIV constraintsCenterEqualToView:cell.contentView]];
                
                UIImageView *iconIV = [[UIImageView alloc] initForAutoLayout];
                [iconIV sd_setImageWithURL:[NSURL URLWithString:self.detailCard.cardCoverUrl?:@""]
                          placeholderImage:[UIImage imageNamed:@"topic_default"]];
                [picIV addSubview:iconIV];
                [picIV addConstraints:[iconIV constraintsLeftInContainer:20]];
                [picIV addConstraints:[iconIV constraintsTopInContainer:15]];
                [picIV addConstraints:[iconIV constraintsSize:CGSizeMake(ALD(55), ALD(35))]];
                
                UILabel *cardNameL = [[UILabel alloc] initForAutoLayout];
                cardNameL.text = self.detailCard.name;
                cardNameL.textColor = WJColorWhite;
                cardNameL.font = WJFont16;
                [picIV addSubview:cardNameL];
                
                [picIV addConstraints:[cardNameL constraintsLeft:20 FromView:iconIV]];
                [picIV addConstraints:[cardNameL constraintsRightInContainer:10]];
                [picIV addConstraint:[cardNameL constraintCenterYEqualToView:iconIV]];
                [picIV addConstraint:[cardNameL constraintHeight:30]];
                
                UILabel *merNameL = [[UILabel alloc] initForAutoLayout];
                merNameL.text = self.detailCard.merName;
                merNameL.textColor = WJColorWhite;
                merNameL.font = WJFont14;
                [picIV addSubview:merNameL];
                [picIV addConstraints:[merNameL constraintsLeftInContainer:20]];
                [picIV addConstraints:[merNameL constraintsBottomInContainer:22]];
                [picIV addConstraints:[merNameL constraintsRightInContainer:10]];
                [picIV addConstraint:[merNameL constraintHeight:30]];
                
                
                UILabel *priceLabel = [[UILabel alloc] initForAutoLayout];
                priceLabel.textColor = [UIColor whiteColor];
                priceLabel.font = [UIFont systemFontOfSize:24];
                priceLabel.text = [NSString stringWithFormat:@"￥ %@",[NSString stringWithFormat:@"%.2f",self.detailCard.faceValue]];
                [picIV addSubview:priceLabel];
                
                [picIV addConstraints:[priceLabel constraintsLeft:10 FromView:iconIV]];
                [picIV addConstraints:[priceLabel constraintsRightInContainer:10]];
                [picIV addConstraints:[priceLabel constraintsTop:0 FromView:cardNameL]];
                [picIV addConstraint:[priceLabel constraintHeight:50]];
                
            }
            
            return cell;
        }
            break;
            
        case 1:{
            //名称，简介，余额
            WJCardDetailSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name"];
           
            if (!cell) {
                cell = [[WJCardDetailSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"name"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.isCardInfo = YES;

            [cell configWithData:self.detailCard];
            
            return cell;

        }
            break;
            
//        case 2:{
//            //特权
//            WJCardDetailPrivilegeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"privilege"];
//            
//            if (cell == nil) {
//                cell = [[WJCardDetailPrivilegeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"privilege"];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//        
//            [cell configWithPrivileges:self.detailCard.privilegeArray isCard:YES];
//            
//            if ([self.detailCard.privilegeArray count] == 0) {
//                [cell notHaveValue];
//            }
//            
//            return cell;
//        }
//            break;
            
        case 2:{
            //使用说明
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"introduce"];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"introduce"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(15))];
                headView.backgroundColor = WJColorViewBg;
                [cell.contentView addSubview:headView];
                
                
                UILabel *infoL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), ALD(15), 200, ALD(30))];
                infoL.text = @"使用说明";
                infoL.font = WJFont16;
                infoL.textColor = WJColorDardGray3;
                [cell.contentView addSubview:infoL];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, infoL.bottom, kScreenWidth, 0.5)];
                line.backgroundColor = WJColorViewBg;
                [cell.contentView addSubview:line];
                
                UIWebView *introduceL = [[UIWebView alloc] initForAutoLayout];
                [introduceL loadHTMLString:self.detailCard.useExplain baseURL:nil];
                introduceL.scrollView.scrollEnabled = NO;
                introduceL.delegate = self;
                [cell.contentView addSubview:introduceL];
                cell.clipsToBounds = YES;

                [cell.contentView addConstraints:[introduceL constraintsBottomInContainer:-3]];
                [cell.contentView addConstraints:[introduceL constraintsTopInContainer:ALD(46)]];
                [cell.contentView addConstraints:[introduceL constraintsLeftInContainer:10]];
                [cell.contentView addConstraints:[introduceL constraintsRightInContainer:10]];
            }
            
            return cell;
   
        }
            break;
            
        case 3:{
            //适用门店
            if (indexPath.row == 0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storeTitle"];
                if (!cell) {
                    
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"storeTitle"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = WJColorViewBg;
                    
                    UILabel *infoL = [[UILabel alloc] initForAutoLayout];
                    infoL.backgroundColor = WJColorWhite;
                    infoL.text = @"   此会员卡适用的门店";
                    infoL.font = WJFont16;
                    infoL.textColor = WJColorDardGray3;
                    [cell.contentView addSubview:infoL];
                    UILabel *storeNumL = [[UILabel alloc] initForAutoLayout];
                    storeNumL.backgroundColor = WJColorWhite;
                    storeNumL.font = WJFont13;
                    storeNumL.textAlignment = NSTextAlignmentRight;
                    storeNumL.textColor = WJColorDardGray9;
                    storeNumL.text = [NSString stringWithFormat:@"共有%@家店面可用", @(self.detailCard.supportStoreNum)];
                    [cell.contentView addSubview:storeNumL];
                    
                    [cell.contentView addConstraints:[infoL constraintsFillWidth]];
                    [cell.contentView addConstraints:[infoL constraintsBottomInContainer:0]];
                    [cell.contentView addConstraint:[infoL constraintHeight:ALD(30)]];
                    [cell.contentView addConstraints:[storeNumL constraintsRightInContainer:10]];
                    [cell.contentView addConstraints:[storeNumL constraintsBottomInContainer:0]];
                    [cell.contentView addConstraints:[storeNumL constraintsSize:CGSizeMake(150, ALD(30))]];

                }

                return cell;
                
            }else if (indexPath.row == MIN(self.detailCard.supportStoreArray.count+2, 5)-1){
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreStore"];
                if (!cell) {
                    
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moreStore"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UILabel * titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
                    titleL.text = @"查看更多店铺";
                    titleL.textColor = WJColorDardGray3;
                    titleL.font = WJFont16;
                    titleL.textAlignment = NSTextAlignmentCenter;
                    titleL.userInteractionEnabled = YES;
                    titleL.backgroundColor = [UIColor whiteColor];
                    [cell.contentView addSubview:titleL];
                    
                    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(40), 11, 22, 22)];
                    imageView.image = [UIImage imageNamed:@"lump_icon"];
                    [cell.contentView addSubview:imageView];
                    
                    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreBranch)];
                    [titleL addGestureRecognizer:tap];
                    
                    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
                    line.backgroundColor = WJColorViewBg;
                    [cell.contentView addSubview:line];
                }
                
                return cell;
            }
            
            WJCardDetailFitStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"store"];
            
            if (!cell) {
                cell = [[WJCardDetailFitStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"store"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.store = self.detailCard.supportStoreArray[indexPath.row-1];
            return cell;
            
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        NSLog(@"选择商家");
        if (indexPath.row>0) {
            WJMerchantDetailController *vc = [[WJMerchantDetailController alloc] init];
            vc.merId = [self.detailCard.supportStoreArray[indexPath.row-1] storeId];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
//    }else if(indexPath.section == 2){
//        
//        if ([self.detailCard.privilegeArray count] == 0) {
//            return;
//        }
//        
//        WJPrivilegeController *cpvc = [[WJPrivilegeController alloc] init];
//        cpvc.cardId = self.card.freeCardID;
//        cpvc.privilegeArray = self.detailCard.privilegeArray;
//        [self.navigationController pushViewController:cpvc animated:YES];

    }
}

#pragma mark - 分享

- (void)showShareActionSheet:(UIView *)view
{
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:[self.detailCard.shareInfoDic[@"Desc"] stringByAppendingString:self.detailCard.shareInfoDic[@"Url"]]
                                     images:@[self.shareImageView.image?:PlaceholderImage]
                                        url:self.detailCard.shareInfoDic[@"Url"]
                                      title:self.detailCard.shareInfoDic[@"Title"]
                                       type:SSDKContentTypeAuto];
    
    //1.2、自定义分享平台（非必要）
    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
    
    //2、分享
    [ShareSDK showShareActionSheet:view
                             items:activePlatforms
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                           break;
                       
                       case SSDKResponseStateSuccess:
                       {
                        
                           WJAlertView *alert = [[WJAlertView alloc]initWithTitle:nil
                                                                          message:@"分享成功"
                                                                         delegate:self
                                                                cancelButtonTitle:@"确定"
                                                                otherButtonTitles:nil
                                                                    textAlignment:NSTextAlignmentCenter];
                           [alert showIn];
                           break;
                       }

                       case SSDKResponseStateFail:
                       {
                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                           {
                               
                               WJAlertView *alert = [[WJAlertView alloc]initWithTitle:nil
                                                                              message:@"分享失败\n失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
                                                                             delegate:self
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles:nil
                                                                        textAlignment:NSTextAlignmentCenter];
                               [alert showIn];
                               
                               break;
                           }
                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                           {
                               
                               WJAlertView *alert = [[WJAlertView alloc]initWithTitle:nil
                                                                              message:@"分享失败\n失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用。"
                                                                             delegate:self
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles:nil
                                                                        textAlignment:NSTextAlignmentCenter];
                               [alert showIn];
                               break;
                           }
                           else
                           {
           
                               WJAlertView *alert = [[WJAlertView alloc]initWithTitle:nil
                                                                              message:[NSString stringWithFormat:@"分享失败\n%@",error]
                                                                             delegate:self
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles:nil
                                                                        textAlignment:NSTextAlignmentCenter];
                               [alert showIn];
                               
                               break;
                           }
                           break;
                       }
//                       case SSDKResponseStateCancel:
//                       {
//                           
//                           WJAlertView *alert = [[WJAlertView alloc]initWithTitle:nil
//                                                                          message:@"分享已取消"
//                                                                         delegate:self
//                                                                cancelButtonTitle:@"确定"
//                                                                otherButtonTitles:nil
//                                                                    textAlignment:NSTextAlignmentCenter];
//                           
//                           [alert showIn];
//                           break;
//                       }
                       default:
                           break;
                   }
                   
               }];
}

#pragma mark - 属性方法
- (UITableView *)mTb{
    if (_mTb == nil) {
        _mTb = [[UITableView alloc] initForAutoLayout];
        _mTb.delegate = self;
        _mTb.dataSource = self;
        _mTb.separatorInset = UIEdgeInsetsZero;
        _mTb.backgroundColor = WJColorViewBg;
        _mTb.tableFooterView = [UIView new];
    }
    return _mTb;
}

- (APICardDetailManager *)cardDetailManager{
    if (!_cardDetailManager) {
        _cardDetailManager = [[APICardDetailManager alloc] init];
        _cardDetailManager.delegate = self;
        _cardDetailManager.merId = self.card.cardId;
    }
    return _cardDetailManager;
}

- (APIProductDetailManager *)productDetailManager
{
    if (!_productDetailManager) {
        _productDetailManager = [[APIProductDetailManager alloc] init];
        _productDetailManager.delegate = self;
    }
    _productDetailManager.proID = self.card.cardId;
    return _productDetailManager;
}


- (UIImageView *)shareImageView
{
    if (!_shareImageView) {
        _shareImageView = [[UIImageView alloc] init];
    }
    return _shareImageView;
}


#pragma mark - Logic

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    CGFloat height = [webView.scrollView contentSize].height;
    CGFloat webViewHeight= [[webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]floatValue];
    userExplaintHeight = MAX(height, webViewHeight);
    [self.mTb reloadData];

}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([request.URL.absoluteString isEqualToString:@"about:blank"] ) {
        return YES;
    }
    return NO;
}



@end
