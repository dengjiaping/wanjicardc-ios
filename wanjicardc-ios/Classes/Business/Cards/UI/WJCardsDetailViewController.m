//
//  WJCardsDetailViewController.m
//  WanJiCard
//
//  Created by 孙琦 on 16/5/19.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJCardsDetailViewController.h"
#import "WJRelationMerchantController.h"
#import "WJOrderConfirmController.h"
#import "WJOrderDetailController.h"
#import "WJPayCompleteController.h"
#import "WJMyConsumerController.h"
#import "WJWebViewController.h"
#import "WJMyCardPackageDetailModel.h"
#import "APICardDetailManager.h"
#import "WJRealNameAuthenticationViewController.h"
#import "WJModelCard.h"
#import "WJCardInPackReformer.h"
#import "PayPrivilegeModel.h"
#import "WJVerificationReceiptMoneyController.h"

@interface WJCardsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,APIManagerCallBackDelegate>
{
    UILabel *titleLabel;
    UILabel *balanceLabel;
    UIImageView *iconIV;
    UIImageView *cardImageView;
    UILabel * desLabel;
    UILabel *privilegeLabel;
}

@property (strong,nonatomic)UITableView *tableView;
@property (nonatomic, strong) WJMyCardPackageDetailModel *detailCard;
@property (nonatomic, strong) APICardDetailManager       *cardDetailManager;
@property (nonatomic, strong) UIImageView                *shareImageView;

@end

@implementation WJCardsDetailViewController
{
    CGFloat instructionHeight;
    UIImageView *arrowImageView;
    BOOL arrowShow;
    BOOL isReload;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    // self.tabBarView.hidden = YES;
}

- (void)dealloc
{
    [kDefaultCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员卡详情";
    titleLabel = [[UILabel alloc] init];
    balanceLabel = [[UILabel alloc] init];
    desLabel = [[UILabel alloc] init];
    iconIV = [[UIImageView alloc] init];
    cardImageView = [[UIImageView alloc] init];

    arrowShow = NO;
    self.eventID = @"iOS_vie_Mycard";

    [kDefaultCenter addObserver:self selector:@selector(reloadCardData) name:kChargeSuccess object:nil];

    [self requestLoad];
}

- (void)reloadCardData
{
    isReload = YES;
    [self requestLoad];
}

#pragma mark - 初始化控件
- (void)initViews
{
    //tableView
    _tableView = [[UITableView alloc] initForAutoLayout];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:_tableView];
    
    //充值按钮
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [payBtn setTitle:@"充值" forState:UIControlStateNormal];
    payBtn.titleLabel.font = WJFont16;
    [payBtn addTarget:self action:@selector(reChargeClick) forControlEvents:UIControlEventTouchUpInside];
    payBtn.backgroundColor = WJColorNavigationBar;
    [self.view addSubview:payBtn];
    
    [self.view addConstraints:[payBtn constraintsAssignBottom]];
    [self.view addConstraint:[payBtn constraintHeight:ALD(48)]];
    [self.view addConstraint:[_tableView constraintTopEqualToView:self.view]];
    [self.view addConstraints:[_tableView constraintsBottom:0 FromView:payBtn]];
    
    [self.view VFLToConstraints:@"H:|-0-[_tableView]-0-|" views:NSDictionaryOfVariableBindings(_tableView)];
    [self.view VFLToConstraints:@"H:|-0-[payBtn]-0-|" views:NSDictionaryOfVariableBindings(payBtn)];
    
}


#pragma mark - tableView-初始化
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    switch (indexPath.section) {
        case 0:
        {
            static NSString *cellName = @"cardDetail";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //背景图片
            cardImageView.frame = CGRectMake(ALD(40), ALD(20), kScreenWidth-ALD(40)*2, ALD(165));
            cardImageView.layer.cornerRadius = 5;
            [cell.contentView addSubview:cardImageView];
            
            //logo图片
                [iconIV sd_setImageWithURL:[NSURL URLWithString:_detailCard.cardLogo]
                      placeholderImage:[UIImage imageNamed:@"topic_default"]];
            iconIV.frame = CGRectMake(ALD(20), ALD(55), ALD(51), ALD(51));
            iconIV.backgroundColor = [UIColor clearColor];
            [iconIV.layer setCornerRadius:CGRectGetHeight([iconIV bounds]) / 2];
            iconIV.layer.masksToBounds = YES;
     
            UIView * alphaView = [[UIView alloc] initWithFrame:iconIV.frame];
            alphaView.backgroundColor = [UIColor whiteColor];
            alphaView.alpha = 0.2;
            [alphaView.layer setCornerRadius:CGRectGetHeight([iconIV bounds]) / 2];
            alphaView.layer.masksToBounds = YES;
            
            [cardImageView addSubview:alphaView];
            [cardImageView addSubview:iconIV];
                
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = WJColorViewBg;
            lineView.frame = CGRectMake(iconIV.right+ALD(15), ALD(55), 0.5, iconIV.height);
            [cardImageView addSubview:lineView];
        
            //卡名称
            titleLabel.font = WJFont14;
            titleLabel.frame = CGRectMake(lineView.right+ALD(15), ALD(60), ALD(195), ALD(16));
            titleLabel.textColor = [UIColor whiteColor];
            [cardImageView addSubview:titleLabel];

            //余额
            balanceLabel.frame = CGRectMake(lineView.right+ALD(15),titleLabel.bottom+ALD(10), ALD(200), ALD(19));
            balanceLabel.textColor = [UIColor whiteColor];
            [cardImageView addSubview:balanceLabel];
           
            }
            return cell;
        }
            break;
        case 1:
        {
            static NSString *cellName = @"cardDetail";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //享有特权
                privilegeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), ALD(13), ALD(150), ALD(17))];
                privilegeLabel.text = @"享有特权";
                privilegeLabel.textColor = WJColorDarkGray;
                privilegeLabel.font = WJFont14;
                [cell.contentView addSubview:privilegeLabel];
                [self enjoyWithPrivileges:self.detailCard.privilegeArray and:cell];
                
                arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-ALD(21), ALD(36),ALD(6), ALD(11))];
                arrowImageView.image =[UIImage imageNamed:@"details_rightArrowIcon"];
                [cell.contentView addSubview:arrowImageView];
                
            }
           
            if([self.detailCard.privilegeArray count] == 0)
            {
                privilegeLabel.hidden = YES;
                arrowImageView.hidden = YES;
            }else {
                privilegeLabel.hidden = NO;
                arrowImageView.hidden = NO;
            }
            return cell;
        }
            break;
        case 2:
        {
            static NSString *cellName = @"cardDetail";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
            //使用店铺
            UILabel *applyShopLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100,ALD(43))];
            applyShopLabel.text = @"适用店铺";
            applyShopLabel.textColor = WJColorDarkGray;
            applyShopLabel.font = WJFont14;
            [cell.contentView addSubview:applyShopLabel];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(ALD(10), ALD(43), kScreenWidth-ALD(10)*2, 1)];
                line.backgroundColor = WJColorViewBg;
                [cell.contentView addSubview:line];
            
                arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-ALD(21), ALD(16),ALD(6), ALD(11))];
                arrowImageView.image =[UIImage imageNamed:@"details_rightArrowIcon"];
                [cell.contentView addSubview:arrowImageView];            }
            return cell;
        }
            break;
        case 3:
        {
            static NSString *cellName = @"cardDetail";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            //消费记录
            UILabel *consumeRecoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), 0, ALD(200), ALD(43))];
            consumeRecoreLabel.text = @"消费记录";
            consumeRecoreLabel.textColor = WJColorDarkGray;
            consumeRecoreLabel.font = WJFont14;
            [cell.contentView addSubview:consumeRecoreLabel];
                arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-ALD(21), ALD(16),ALD(6), ALD(12))];
                arrowImageView.image =[UIImage imageNamed:@"details_rightArrowIcon"];
                [cell.contentView addSubview:arrowImageView];
            }
            return cell;
        }
            break;
        case 4:
        {
            static NSString *cellName = @"Instruction";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            
                UILabel *infoL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), 0, ALD(200), ALD(43))];
                infoL.text = @"使用说明";
                infoL.font = WJFont14;
                infoL.textColor = WJColorDarkGray;
                [cell.contentView addSubview:infoL];
            
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(ALD(10), ALD(43), kScreenWidth-ALD(10)*2, 1)];
                line.backgroundColor = WJColorViewBg;
                [cell.contentView addSubview:line];
                
                arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-ALD(21), ALD(16),ALD(6), ALD(12))];
                arrowImageView.image =[UIImage imageNamed:@"details_rightArrowIcon"];
                arrowImageView.transform = CGAffineTransformRotate(arrowImageView.transform, M_PI_2);
                [cell.contentView addSubview:arrowImageView];
                
//                UIWebView *introduceL = [[UIWebView alloc] initWithFrame:CGRectMake(ALD(10), ALD(14), self.tableView.width-ALD(20), ALD(10))];
//                [introduceL loadHTMLString:self.detailCard.useExplain baseURL:nil];
//                introduceL.scrollView.scrollEnabled = NO;
//                introduceL.delegate = self;
//                cell.clipsToBounds = YES;
//                [cell.contentView addSubview:introduceL];
                
                [desLabel setFrame:CGRectMake(ALD(10), ALD(56), kScreenWidth - ALD(20), 100)];
                desLabel.numberOfLines = 0;
                desLabel.lineBreakMode = NSLineBreakByWordWrapping;
                desLabel.font = WJFont14;
                desLabel.text = self.detailCard.ad?:@"";
                [desLabel sizeToFit];
                [cell.contentView addSubview:desLabel];

            }
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - 返回分组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - 返回行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            return ALD(205);
        }
            break;
        case 1:
        {
//            return ALD(83);
            if([self.detailCard.privilegeArray count] == 0)
            {
                return 0;
            }
            return ALD(83);
        }
            break;
        case 2:
        {
            return ALD(43);
        }
            break;
        case 3:
        {
            return ALD(43);
        }
            break;
        case 4:
            
        {
            instructionHeight = (CGFloat)coculationDesLableHeight(desLabel);
            
            return ALD(43)+instructionHeight;
        }
            break;
        default:
            return 100;
            break;
    }
}

#pragma mark - 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

#pragma mark - 头标
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0 || section == 3)
        return 0;
    else
        return 10;
}

#pragma mark - tableView选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
            if ([self.detailCard.privilegeArray count] == 0) {
                return;
            }
            
            WJModelPerson * person = [WJGlobalVariable sharedInstance].defaultPerson;
            NSString * token = person.token?:@"";
            NSString *merID = self.detailCard.merchantId;
            //享有特权
//            WJEnjoyPrivilegeViewController *enjoyPrivilegeVC = [[WJEnjoyPrivilegeViewController alloc] init];
//            enjoyPrivilegeVC.title = @"享有特权";
//            [self.navigationController pushViewController:enjoyPrivilegeVC animated:YES whetherJump:NO];
            WJWebViewController *web = [[WJWebViewController alloc] init];
            web.titleStr = @"享有特权";
            web.isShowPriManual = YES;
            web.merID = merID;
            [web loadWeb:[NSString stringWithFormat:@"http://e.wjika.com/tequan/?merchantId=%@&token=%@&privilegeType=user",merID,token]];
//            [self.navigationController pushViewController:web animated:YES];
            [self.navigationController pushViewController:web animated:YES whetherJump:NO];
           
        }
            break;
        case 2:
        {
            //适用店铺
            [self moreBranch];
        }
            break;
        case 3:
        {
            [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_ConsumptionRecord"];
            
            //消费记录
            WJMyConsumerController *consumeRecordVC = [[WJMyConsumerController alloc] init];
            consumeRecordVC.fromType = FromCardDetail;
            consumeRecordVC.merName = self.detailCard.cardName;
            consumeRecordVC.merchantId = self.card.merId;
            [self.navigationController pushViewController:consumeRecordVC animated:YES whetherJump:NO];
        }
            break;
            case 4:
        {
            //使用说明
            [self instructionShowClick];
        }
            break;
        default:
            break;
    }
}

- (void)requestLoad{
    [self showLoadingView];
    self.cardDetailManager.merId = self.card.freeCardID;
    [self.cardDetailManager loadData];
}


- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APICardDetailManager class]]) {
        [self hiddenLoadingView];
    
        self.detailCard = [manager fetchDataWithReformer:[[WJCardInPackReformer alloc] init]];
        
//        self.detailCard.useExplain = @"WJSignCreateManager.m : 63> +[WJSignCreateManager postSignWithDic:methodName:]2016-07-13 17:58:20.683 WanJiCard[4058:2085370] sid = =MjLx4SLuM2M2EGZiVmY5EzM1AjYldDM4kDNiVWMjZDN5kTOyUmNu0iL3czMu0iLx4yMukjLt4idJV2dQNmUOtmT5RXWQhDZaF3cSZVYIpkejNGMIN3S25SLuUmbvhGUp5SLuAjL14iMu0iLy8VM=MDIwLw3VzZXJDYXJkL3VzZXJDYXJkRGV0YWls=NTY2ZjJjMDU0YmE2OGE4NjIzNDEwNGFiNGFmMzE1MjVhYTIwMmM1Ng==WJSignCreateManager.m : 63> +[WJSignCreateManager postSignWithDic:methodName:]2016-07-13 17:58:20.683 WanJiCard[4058:2085370] sid = =MjLx4SLuM2M2EGZiVmY5EzM1AjYldDM4kDNiVWMjZDN5kTOyUmNu0iL3czMu0iLx4yMukjLt4idJV2dQNmUOtmT5RXWQhDZaF3cSZVYIpkejNGMIN3S25SLuUmbvhGUp5SLuAjL14iMu0iLy8VM=MDIwLw3VzZXJDYXJkL3VzZXJDYXJkRGV0YWls=NTY2ZjJjMDU0YmE2OGE4NjIzNDEwNGFiNGFmMzE1MjVhYTIwMmM1Ng==;WJSignCreateManager.m : 63> +[WJSignCreateManager postSignWithDic:methodName:]2016-07-13 17:58:20.683 WanJiCard[4058:2085370] sid = =MjLx4SLuM2M2EGZiVmY5EzM1AjYldDM4kDNiVWMjZDN5kTOyUmNu0iL3czMu0iLx4yMukjLt4idJV2dQNmUOtmT5RXWQhDZaF3cSZVYIpkejNGMIN3S25SLuUmbvhGUp5SLuAjL14iMu0iLy8VM=MDIwLw3VzZXJDYXJkL3VzZXJDYXJkRGV0YWls=NTY2ZjJjMDU0YmE2OGE4NjIzNDEwNGFiNGFmMzE1MjVhYTIwMmM1Ng==WJSignCreateManager.m : 63> +[WJSignCreateManager postSignWithDic:methodName:]2016-07-13 17:58:20.683 WanJiCard[4058:2085370] sid = =MjLx4SLuM2M2EGZiVmY5EzM1AjYldDM4kDNiVWMjZDN5kTOyUmNu0iL3czMu0iLx4yMukjLt4idJV2dQNmUOtmT5RXWQhDZaF3cSZVYIpkejNGMIN3S25SLuUmbvhGUp5SLuAjL14iMu0iLy8VM=MDIwLw3VzZXJDYXJkL3VzZXJDYXJkRGV0YWls=NTY2ZjJjMDU0YmE2OGE4NjIzNDEwNGFiNGFmMzE1MjVhYTIwMmM1Ng==";
        
        switch (self.detailCard.cType) {
                
            case 1:
            {
                cardImageView.backgroundColor = WJColorCardRed;
            }
                break;
            case 2:
            {
                cardImageView.backgroundColor = WJColorCardOrange;
            }
                break;
            case 3:
            {
                cardImageView.backgroundColor = WJColorCardBlue;
            }
                break;
            case 4:
            {
                cardImageView.backgroundColor = WJColorCardGreen;
            }
                break;
            default:
                cardImageView.backgroundColor = WJColorCardRed;
                break;
        }
        
        [self.shareImageView sd_setImageWithURL:[NSURL URLWithString:self.detailCard.cardLogo]
                               placeholderImage:[UIImage imageNamed:@"topic_default"]];
        
        [iconIV sd_setImageWithURL:[NSURL URLWithString:self.detailCard.cardLogo]];
        titleLabel.text = self.detailCard.cardName;
        balanceLabel.text = [NSString stringWithFormat:@"金额  %@元",[WJUtilityMethod floatNumberForMoneyFomatter:self.detailCard.balance]];
        if (balanceLabel != nil && balanceLabel.text.length > 0 ) {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:balanceLabel.text];
            [str addAttribute:NSFontAttributeName value:WJFont13 range:NSMakeRange(0,2)];
            [str addAttribute:NSFontAttributeName value:WJFont17 range:NSMakeRange(2,str.length-2)];
            balanceLabel.attributedText = str;
        }
                
        if (isReload) {
            
            [self.tableView reloadData];
        }else{
            [self initViews];
        }
    }
    
    

}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    [self hiddenLoadingView];
}


- (void)reloadTableViewByRows:(int)rowNumber
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:rowNumber inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)moreBranch
{
    WJRelationMerchantController *branchListC = [[WJRelationMerchantController alloc] init];
     branchListC.merId = self.detailCard.merchantId;
    branchListC.title = @"此卡劵适用的门店";
    [self.navigationController pushViewController:branchListC animated:YES];
}

#pragma mark - 享有特权
- (void)enjoyWithPrivileges:(NSArray *)privilegeArray and:(UITableViewCell *)cell
{
    if (privilegeArray == nil) {
        return;
    }
    
    int maxCount = (kScreenWidth - 60)/ALD(50);
    for (int i = 0; i < MIN(maxCount, [privilegeArray count]); i++) {
        PayPrivilegeModel *model = (PayPrivilegeModel *)privilegeArray[i];
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10+ALD(50)*i, ALD(43), ALD(30), ALD(30))];
        iv.backgroundColor = WJColorViewBg;
        iv.layer.cornerRadius = 3;
        [iv sd_setImageWithURL:[NSURL URLWithString:model.privilegePic?:@""]
                      placeholderImage:[UIImage imageNamed:@"topic_default"]];
        [cell.contentView addSubview:iv];
    }
    
}

#pragma mark - 展开关闭使用说明按钮
- (void)instructionShowClick
{
    CGFloat desLabelHeight = 0;
    CGFloat accowAngle = -M_PI_2;
    if(instructionHeight <= 0 || arrowShow)
    {
        desLabelHeight = instructionHeight;
        accowAngle = M_PI_2;
    }

    [UIView animateWithDuration:.25 animations:^{
        arrowImageView.transform = CGAffineTransformRotate(arrowImageView.transform, accowAngle);
        desLabel.height = desLabelHeight;
        if (desLabelHeight == 0) {
            desLabel.hidden = YES;
        }else{
            desLabel.hidden = NO;
        }
    }];

    arrowShow = !arrowShow;

  
}

float coculationDesLableHeight(UILabel *label){
    NSDictionary *attribute = @{NSFontAttributeName: label.font?:WJFont14};
    
    CGSize retSize = [label.text?:@"" boundingRectWithSize:CGSizeMake(kScreenWidth - 40, 100000)
                                                      options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                                   attributes:attribute
                                                      context:nil].size;
    return retSize.height;
}

#pragma mark - 核对实名认证
- (void)checkAuthentication
{
    WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
    
    if (defaultPerson.authentication == AuthenticationNo) {
        
        
        NSString *record = [[NSUserDefaults standardUserDefaults] valueForKey:@"RealNameReciveMoneyRecord"];
        
        if (!record) {
            WJRealNameAuthenticationViewController *realNameAuthenticationVC = [[WJRealNameAuthenticationViewController alloc] init];
            realNameAuthenticationVC.comefrom = ComeFromCardPackageDetail;
            realNameAuthenticationVC.isjumpOrderConfirmController = YES;
            [WJGlobalVariable sharedInstance].realAuthenfromController = self;
            [self.navigationController pushViewController:realNameAuthenticationVC animated:YES];
            
            __weak typeof(self) weakSelf = self;
            [realNameAuthenticationVC setRealNameAuthenticationSuc:^(void){
                
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf fromChargeToOrderConfirmController];
            }];
            
        } else {
            
            //收款金额验证
            WJVerificationReceiptMoneyController *verificationReceiptMoneyController = [[WJVerificationReceiptMoneyController alloc] init];
            [WJGlobalVariable sharedInstance].realAuthenfromController = self;
            verificationReceiptMoneyController.comefrom = ComeFromCardPackageDetail;
            verificationReceiptMoneyController.isjumpOrderConfirmController = YES;
            verificationReceiptMoneyController.BankCard = record;
            [self.navigationController pushViewController:verificationReceiptMoneyController animated:YES];
            
            
            __weak typeof(self) weakSelf = self;
            [verificationReceiptMoneyController setAuthenticationSuc:^(void){
                
                __strong typeof(self) strongSelf = weakSelf;
                
                [strongSelf fromChargeToOrderConfirmController];
                
            }];
            
        }

        
    } else {
    
        [self fromChargeToOrderConfirmController];
    }
}

#pragma mark - 跳转到充值订单确认页
- (void)fromChargeToOrderConfirmController
{
    [WJGlobalVariable sharedInstance].payfromController = self;

    WJOrderConfirmController *vc = [[WJOrderConfirmController alloc] initWithCardId:nil
                                                                           cardName:self.detailCard.cardName
                                                                              merID:self.detailCard.merchantId? :self.card.merId
                                                                            merName:self.card.merName? :self.detailCard.cardName
                                                                            buyType:BuyTypeCharge];

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 充值点击事件
- (void)reChargeClick
{
    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_recharge"];
    [self checkAuthentication];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIImageView *)shareImageView
{
    if (!_shareImageView) {
        _shareImageView = [[UIImageView alloc] init];
    }
    return _shareImageView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
//    CGFloat height = [webView.scrollView contentSize].height;
    CGFloat webViewHeight= [[webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]floatValue];
    instructionHeight = MAX(webViewHeight, 0);
    [self.tableView reloadData];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([request.URL.absoluteString isEqualToString:@"about:blank"] ) {
        return YES;
    }
    return NO;
}


- (APICardDetailManager *)cardDetailManager
{
    if (nil == _cardDetailManager) {
        _cardDetailManager = [[APICardDetailManager alloc] init];
        _cardDetailManager.delegate = self;
    }
    return _cardDetailManager;
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
