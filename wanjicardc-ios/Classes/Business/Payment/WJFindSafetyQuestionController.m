//
//  WJFindSafetyQuestionController.m
//  WanJiCard
//
//  Created by XT Xiong on 15/12/4.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJFindSafetyQuestionController.h"
#import "WJVerifyPasswordController.h"
#import "WJAppealViewController.h"
#import "APIUserQuestionManager.h"
#import "WJSecurityQuestionModel.h"
#import "WJSecurityQuestionReformer.h"
#import "APIVerifyQuestionManager.h"
#import "WJSystemAlertView.h"
#import "WJPasswordSettingController.h"

#define LockTime 10
@interface WJFindSafetyQuestionController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,WJSystemAlertViewDelegate>

@property (strong, nonatomic) UITableView *quesTable;
@property (strong, nonatomic) APIUserQuestionManager *getQusManager;
@property (strong, nonatomic) NSMutableArray *questionsArr;
@property (strong, nonatomic) APIVerifyQuestionManager *verifyManager;
@end

@implementation WJFindSafetyQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改/找回支付密码";
  
//    WJModelPerson * person = [WJGlobalVariable sharedInstance].defaultPerson;
    
//    if (person.isSetPsdQuestion) {
//        [self.verifyManager loadData];
//    } else {
        [self.getQusManager loadData];
//    }
    
    [self.view addSubview:self.quesTable];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.questionsArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 
    if (section == 0) {
       
        return 0;
        
    }else{
     
//        return ALD(15);
        return 0;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = WJColorViewBg;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(45);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell1"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }

        cell.textLabel.textColor = WJColorDardGray3;
        cell.textLabel.font = WJFont16;
        cell.backgroundColor = WJColorViewBg;
        WJSecurityQuestionModel *question = (WJSecurityQuestionModel *)[self.questionsArr objectAtIndex:indexPath.section];
        cell.textLabel.text = [NSString stringWithFormat:@"问题%@:%@", @(indexPath.section+1), [question question]];
    
        return cell;
        
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell2"];
       
        if (nil == cell) {
        
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"myCell2"];
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(ALD(15), 0, kScreenWidth - ALD(15), ALD(45))];
            textField.delegate = self;
            textField.borderStyle = UITextBorderStyleNone;
            textField.placeholder = @"答案";
            textField.tag = indexPath.section + 1000;
            [cell.contentView addSubview:textField];

        }
        
        return cell;
    }
}


- (void)handletapPressGesture:(UITapGestureRecognizer *)gesture
{

    for (int i= 0; i<3; i++) {
        UITableViewCell *cell = [self.quesTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:i]];
        [[cell viewWithTag:1000+i] resignFirstResponder];
    }
}


#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    
    if ([manager isKindOfClass:[self.getQusManager class]]) {
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletapPressGesture:)];
        [self.quesTable addGestureRecognizer:tapGesture];
        
        self.questionsArr = [manager fetchDataWithReformer:[[WJSecurityQuestionReformer alloc] init]];
        
        if ([self.questionsArr count] == 0) {
            [self  managerCallAPIDidFailed:manager];
            _quesTable.tableFooterView = [[UIView alloc] init];


        } else {
            [self.quesTable reloadData];
            _quesTable.tableFooterView = [self sectionFootView];
        }
    }else if ([manager isKindOfClass:[self.verifyManager class]]) {
      
        WJPasswordSettingController *pswSettingVC = [[WJPasswordSettingController alloc] init];
        pswSettingVC.from = ComeFromRetrievePsd;
        [self.navigationController pushViewController:pswSettingVC animated:YES];
        
    }

}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{

    NSLog(@"errorMessage == %@",manager.errorMessage);
   
    if ([manager isKindOfClass:[self.verifyManager class]])
    {
        [self showAlertViewByVerify];
    } else if ([manager isKindOfClass:[self.getQusManager class]]){
        [self showAlertViewByGetQus];
    }
  
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
    
    
#pragma mark - UIButton Action
- (void)sureBtnAction
{
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (WJSecurityQuestionModel *model in self.questionsArr) {
        [array addObject:model.questionId];
    }
    self.verifyManager.questionsArray =(NSArray *)array;
    
    
    UITableViewCell *cell1 = [self.quesTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITableViewCell *cell2 = [self.quesTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
   
    UITextField *text1 = [cell1 viewWithTag:1000];
    UITextField *text2 = [cell2 viewWithTag:1001];
    
    [text1 resignFirstResponder];
    [text2 resignFirstResponder];
   
    if ([text1.text length] <= 0 || [text2.text length] <= 0) {
       
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"答案不能为空"];
        return;
    }
   
    if (![self isValidateText:text1.text] || ![self isValidateText:text2.text]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"答案只能由字母、汉字和数字组成"];
        return;
    }
    

    self.verifyManager.answersArray = [NSArray arrayWithObjects:text1.text, text2.text, nil];
    self.verifyManager.phone = self.phoneNumber;
    [self.verifyManager loadData];
    
}


- (void)showAlertViewByVerify
{
    WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil
                                                                message:[NSString stringWithFormat:@"安全问题验证失败！\n若多次验证失败建议您使用申诉功能进行申诉找回"]
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"账户申诉"
                                                          textAlignment:NSTextAlignmentCenter];
    [alert showIn];
    
}

- (void)showAlertViewByGetQus
{
    
    WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil
                                                                message:[NSString stringWithFormat:@"获取安全问题失败，请稍后再试！"]
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:nil
                                                          textAlignment:NSTextAlignmentCenter];
    [alert showIn];
    
}

- (void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSInteger appealStatus = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppealStatus"] integerValue];
        
        if (appealStatus == AppealNoInfo) {
            WJAppealViewController *findPswVC = [[WJAppealViewController alloc] init];
            
            if (self.phoneNumber) {
                if (self.phoneNumber.length > 0) {
                    findPswVC.userPhone = self.phoneNumber;
                }
            }
            [self.navigationController pushViewController:findPswVC animated:YES];
        }
        if (appealStatus == AppealProcessing) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"申诉处理中"];
        }
    }
}

- (UIView *) sectionFootView
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, ALD(15), [UIScreen mainScreen].bounds.size.width, ALD(100))];
    footView.backgroundColor = [UIColor clearColor];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    line.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"e6e7e8"];
    [footView addSubview:line];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(ALD(15),ALD(30), kScreenWidth - ALD(30),ALD(40));
    [sureBtn setTitle:@"立即验证" forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 4;
    [sureBtn setBackgroundColor:WJColorNavigationBar];
    [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:sureBtn];

    return footView;
}


-(BOOL)isValidateText:(NSString *)text {
    
    NSString *regex = @"^[A-Za-z0-9\u4e00-\u9fa5]+$" ;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:text];
}


- (UITableView* )quesTable
{
    if(nil == _quesTable)
    {
        _quesTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _quesTable.delegate = self;
        _quesTable.dataSource = self;
        _quesTable.separatorInset = UIEdgeInsetsZero;
        _quesTable.separatorColor = [WJUtilityMethod colorWithHexColorString:@"e6e7e8"];
        _quesTable.backgroundColor = WJColorViewBg;
    }
    return _quesTable;
}


- (APIUserQuestionManager *)getQusManager
{
    
    if (nil == _getQusManager) {
        
        _getQusManager = [[APIUserQuestionManager alloc]init];
        _getQusManager.delegate = self;
        _getQusManager.phone = self.phoneNumber;
    }
    
    return _getQusManager;
}


- (APIVerifyQuestionManager *)verifyManager
{
    
    if (nil == _verifyManager) {
        
        _verifyManager = [[APIVerifyQuestionManager alloc]init];
        _verifyManager.delegate = self;
    }
    
    return _verifyManager;
}


- (NSMutableArray *)questionsArr{
    
    if (nil == _questionsArr) {
        
        _questionsArr = [NSMutableArray array];
    }
    return _questionsArr;
}


@end
