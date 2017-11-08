//
//  WJFindRealNameAuthenticationViewController.m
//  WanJiCard
//
//  Created by reborn on 16/6/28.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJFindRealNameAuthenticationViewController.h"
#import "WJPasswordSettingController.h"
#import "APIVerifyIdentityManager.h"
#define  spaceMargin                                    (iPhone6OrThan?(ALD(0)):(ALD(15)))

@interface WJFindRealNameAuthenticationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,APIManagerCallBackDelegate>
{
    UITextField *realNameTF;
    UITextField *cardNumberTF;
    UITextField *bankCardTF;
    UITextField *phoneTF;
    
    UIButton    *nextButton;
    BOOL        isNeedInput;
}
@property(nonatomic, strong)APIVerifyIdentityManager *verifyRealNameManager;
@property(nonatomic, strong)NSArray                  *listdataMiddle;
@property(nonatomic, strong)UITableView              *mTb;

@end

@implementation WJFindRealNameAuthenticationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"身份验证";
    self.view.backgroundColor = WJColorViewBg;
    [kDefaultCenter addObserver:self selector:@selector(checkInputState:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self initContentView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletapPressGesture)];
    [self.view  addGestureRecognizer:tapGesture];

}
- (void)initContentView
{
    [self.view addSubview:self.mTb];
    
    UIView  *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(30))];
    self.mTb.tableHeaderView = topView;

    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(15), (topView.height - ALD(15))/2, ALD(15), ALD(15))];
    leftImageView.image = [UIImage imageNamed:@"tip_safe_image"];
    [topView addSubview:leftImageView];
    

    UILabel *titleDesL = [[UILabel alloc] initWithFrame:CGRectMake(leftImageView.right + ALD(5), (topView.height - ALD(20))/2, kScreenWidth - ALD(30), ALD(20))];
    titleDesL.text = @"填写验证信息完成身份验证";
    titleDesL.font = WJFont12;
    titleDesL.textColor = WJColorLightGray;
    [topView addSubview:titleDesL];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    self.mTb.tableFooterView = bottomView;
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(ALD(15), ALD(30), kScreenWidth - ALD(30), ALD(45));
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorViewNotEditable] forState:UIControlStateDisabled];
    [nextButton setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorNavigationBar] forState:UIControlStateNormal];
    nextButton.enabled = NO;
    nextButton.titleLabel.font = [UIFont systemFontOfSize:16];
    nextButton.layer.cornerRadius = 5;
    nextButton.layer.masksToBounds = YES;
    [nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:nextButton];
    
    UILabel *desL=[[UILabel alloc]init];
    [desL setText:@"以上内容仅作为账户保障凭证，万集卡将严格保密"];
    [desL setFont:[UIFont systemFontOfSize:12]];
    desL.numberOfLines = 0;
    [desL setTextColor:WJColorAlert];
    desL.lineBreakMode = NSLineBreakByCharWrapping;
    
//    CGSize desTxtSize = [desL.text sizeWithAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    CGSize desTxtSize = [desL.text sizeWithAttributes:@{NSFontAttributeName:WJFont12} constrainedToSize:CGSizeMake(1000000, 20)];

    desL.frame=CGRectMake((kScreenWidth - desTxtSize.width)/2, nextButton.bottom + ALD(20), kScreenWidth - ALD(40), ALD(20));
    [bottomView addSubview:desL];

}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];

    if ([manager isKindOfClass:[APIVerifyIdentityManager class]]) {
        
        WJPasswordSettingController *pswSettingVC = [[WJPasswordSettingController alloc] init];
        pswSettingVC.from = ComeFromRetrievePsd;
        [self.navigationController pushViewController:pswSettingVC animated:YES];
        
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];

    if ([manager isKindOfClass:[APIVerifyIdentityManager class]]) {
        
        [[TKAlertCenter defaultCenter] postAlertWithMessage:manager.errorMessage];
    }
}

#pragma mark - Request

- (void)requestLoad{
    [self showLoadingView];
    [self.verifyRealNameManager loadData];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (0 == section) {
        return 2;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(45);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (0 == section) {
        return 0.01f;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [UIView new];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindRealNameCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FindRealNameCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        [cell.textLabel setTextColor:WJColorDardGray3];
        
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), 0, ALD(100), ALD(45))];
        nameL.textColor = WJColorDardGray6;
        nameL.tag = 2001;
        [cell.contentView addSubview:nameL];
        
        UITextField *contentL = [[UITextField alloc] initWithFrame:CGRectMake(nameL.right + spaceMargin, 0, kScreenWidth - ALD(115), ALD(45))];
        contentL.tag = 2002;
        contentL.textColor = WJColorDardGray6;
        contentL.clearButtonMode = UITextFieldViewModeWhileEditing;
        contentL.delegate = self;
        [cell.contentView addSubview:contentL];
        
    }
    
    UILabel *nameL = (UILabel *)[cell.contentView viewWithTag:2001];
    UITextField *contentTF = (UITextField *)[cell.contentView viewWithTag:2002];
    
    NSDictionary * dic = [NSDictionary dictionary];
    
    if (0 == indexPath.section) {
        
        if (0 == indexPath.row) {
            contentTF.keyboardType = UIKeyboardTypeDefault;

            dic = [self.listdataMiddle  objectAtIndex:0];
            nameL.text = dic[@"key"];

            if (self.realName.length > 0) {
                
                NSRange trange = NSMakeRange(1, 1);
                NSString *tRealNameStr;
                tRealNameStr = [self.realName stringByReplacingCharactersInRange:trange withString:@"*"];
                
                contentTF.text = tRealNameStr;
                contentTF.textColor = WJColorAlert;
                contentTF.enabled = NO;
                
                isNeedInput = NO;
                
            } else {
                
                contentTF.placeholder = dic[@"value"];
                isNeedInput = YES;
            }

            realNameTF = contentTF;
            
        } else if (1 == indexPath.row) {
            
            dic = [self.listdataMiddle  objectAtIndex:1];
            nameL.text = dic[@"key"];
            contentTF.placeholder = dic[@"value"];
    
            cardNumberTF = contentTF;
        }
        
    } else if (1 == indexPath.section) {
        
        if (0 == indexPath.row) {
            contentTF.keyboardType = UIKeyboardTypeNumberPad;
            
            dic = [self.listdataMiddle  objectAtIndex:2];
            nameL.text = dic[@"key"];
            contentTF.placeholder = dic[@"value"];
            
            bankCardTF = contentTF;
            
        } else if (1 == indexPath.row) {
            contentTF.keyboardType = UIKeyboardTypeNumberPad;
            
            dic = [self.listdataMiddle  objectAtIndex:3];
            nameL.text = dic[@"key"];
            contentTF.placeholder = dic[@"value"];
            
            phoneTF = contentTF;
            
        }
    }
    
    return cell;
}

#pragma mark -event
-(void)handletapPressGesture
{
    [realNameTF resignFirstResponder];
    [cardNumberTF resignFirstResponder];
    [bankCardTF resignFirstResponder];
    [phoneTF resignFirstResponder];
}

- (void)dealloc{
    
    [kDefaultCenter removeObserver:self];
}

#pragma mark - UITextFieldTextDidChangeNotification

- (void)checkInputState:(NSNotification *)notification
{
    if (realNameTF.text.length != 0 && cardNumberTF.text.length != 0 && bankCardTF.text.length != 0 && phoneTF.text.length != 0) {
        nextButton.enabled = YES;
        
    } else {
        nextButton.enabled = NO;
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == bankCardTF) {
        
        // 4位分隔银行卡卡号
        NSString *text = [textField text];
        
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        
        if ([newString stringByReplacingOccurrencesOfString:@" " withString:@""].length >= 21) {
            return NO;
        }
        
        [textField setText:newString];
        
        [self checkInputState:nil];

        return NO;
    }
    
    if (textField == phoneTF) {
        if ([string length] > 0) {
            if (textField.text.length >= 11) {
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)nextAction
{
    if (![cardNumberTF.text isIDCardNumber]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"身份证号格式不正确"];
        
    } else if (![bankCardTF.text isBankCardID]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"银行卡号格式不正确"];
        
    } else if (![WJUtilityMethod isValidatePhone:phoneTF.text]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入正确的手机号"];
        
    } else {
        
        [self requestLoad];
    }
}

-(NSArray *)listdataMiddle
{
    if(nil==_listdataMiddle)
    {
        _listdataMiddle=@[@{@"key":@"真实姓名",@"value":@"请输入您的真实姓名"},
                          @{@"key":@"身份证号",@"value":@"请输入您的身份证号码"},
                          @{@"key":@"银行卡号",@"value":@"请输入您的银行卡号"},
                          @{@"key":@"预留手机号",@"value":@"请填写银行预留手机号"}
                          ];
    }
    return _listdataMiddle;
}

#pragma mark - 属性方法
- (UITableView *)mTb{
    if (_mTb == nil) {
        _mTb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _mTb.delegate = self;
        _mTb.dataSource = self;
        _mTb.separatorInset = UIEdgeInsetsZero;
        _mTb.backgroundColor = WJColorViewBg;
        _mTb.scrollEnabled = NO;
        _mTb.separatorColor = WJColorSeparatorLine;
        _mTb.tableFooterView = [UIView new];
    }
    return _mTb;
}

-(APIVerifyIdentityManager *)verifyRealNameManager
{
    if (nil== _verifyRealNameManager) {
        _verifyRealNameManager = [[APIVerifyIdentityManager alloc]init];
        _verifyRealNameManager.delegate = self;

    }
    
    if (isNeedInput) {
        _verifyRealNameManager.trueName = realNameTF.text;

    } else {
        _verifyRealNameManager.trueName = self.realName;

    }
    _verifyRealNameManager.idNo = cardNumberTF.text;
    _verifyRealNameManager.cardNo = bankCardTF.text;
    _verifyRealNameManager.phone = phoneTF.text;
    
    return _verifyRealNameManager;
}

@end
