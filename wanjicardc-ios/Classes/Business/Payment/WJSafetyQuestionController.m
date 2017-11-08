//
//  WJSafetyQuestionController.m
//  WanJiCard
//
//  Created by XT Xiong on 15/12/1.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJSafetyQuestionController.h"
#import "WJChoiceQuestionController.h"
#import "WJPaySettingController.h"

#import "APIQuestionsCreateManager.h"
#import "WJSafetyQuestionCell.h"
#import "APIUserSecurityQuestionsManager.h"
#import "WJSystemAlertView.h"

#define kDefaultWidth       12

@interface WJSafetyQuestionController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,APIManagerCallBackDelegate>
{
    SafetyQuestionType   safetyQuestionType;
    UITableView        * mainTableView;
    NSInteger            choiceQuestionNum;
    NSInteger            answerNum;
    UIButton           * nextBtn;
    UIButton           * sureBtn;
    NSArray            * numberArray;
    
    BOOL                 isSetSafetyQuestion;
}

@property (strong,nonatomic) NSMutableArray                  * dataArray;

@property (strong,nonatomic) APIQuestionsCreateManager       * createQuestionsManager;
@property (strong,nonatomic) APIUserSecurityQuestionsManager * securityQuestionsManager;

@end

@implementation WJSafetyQuestionController

- (instancetype)initWithPsdType:(SafetyQuestionType)sqType
{
    if (self = [super init]) {
        safetyQuestionType = sqType;
    }
    return self;
}

- (void)initData
{
    
    WJModelPerson * person = [WJGlobalVariable sharedInstance].defaultPerson;
    isSetSafetyQuestion = person.isSetPsdQuestion;
    
    numberArray = @[@"一",@"二",@"三"];
    if (!isSetSafetyQuestion) {
        self.dataArray = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@{@"id":@"0",@"questionName":@"请选择问题"},@"question",[NSString stringWithFormat:@"%ld",(long)choiceQuestionNum],@"number",@"",@"answer",nil];
            [self.dataArray addObject:dic];
        }
        if (safetyQuestionType == SafetyQuestionTypeVerify) {
            self.dataArray = [NSMutableArray arrayWithArray:self.oldArray];
        }
        
    }else{
        [self.securityQuestionsManager loadData];

        self.dataArray = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@{@"id":@"0",@"questionName":@""},@"question",[NSString stringWithFormat:@"%ld",(long)choiceQuestionNum],@"number",@"",@"answer",nil];
            [self.dataArray addObject:dic];
        }
//        [self.dataArray removeAllObjects];
//        self.dataArray = [NSMutableArray arrayWithArray:self.oldArray];
    }
}


#pragma mark- Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];

    [self.view addSubview:self.tableView];
    
    switch (safetyQuestionType) {
        case SafetyQuestionTypeNew:
            self.title = @"安全设置";
            break;
        case SafetyQuestionTypeVerify:
            self.title = @"验证安全问题";
            break;
        default:
            break;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self registerForKeyboardNotifications];
}


- (void)dealloc
{
    [kDefaultCenter removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
//    if (safetyQuestionType == SafetyQuestionTypeVerify) {
//        return  0;
//    } else {
        switch (section) {
            case 0:
                return 0;
                break;
                
            default:
        return ALD(15);
                
                break;
        }
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(45);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(15))];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame) - 1, kScreenWidth, 1)];
    line.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"e6e7e8"];
    [headerView addSubview:line];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    footerView.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"e6e7e8"];
    
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.row == 0) {
            //问题样式
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell1"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell1"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                
                UILabel * queLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, kScreenWidth - 24, 44)];
                queLabel.tag = 10100 + indexPath.row;
                queLabel.font = WJFont15;
                
                queLabel.textColor = isSetSafetyQuestion ? [WJUtilityMethod colorWithHexColorString:@"c7c7cc"]:[WJUtilityMethod colorWithHexColorString:@"2f333b"];
                
                [cell.contentView addSubview:queLabel];
            }
            cell.indentationLevel = 1;
//            cell.textLabel.textColor = WJColorDardGray3;
//            cell.textLabel.font = WJFont15;
            
            if (safetyQuestionType == SafetyQuestionTypeVerify) {
                cell.backgroundColor = WJColorViewBg;
            } else {
                
                UIImageView * rightArrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - ALD(16), ALD(33)/2, ALD(6), ALD(11))];
                rightArrowIV.image = [UIImage imageNamed:@"details_rightArrowIcon"];
                [cell.contentView addSubview:rightArrowIV];
            }
            
            if (numberArray.count != 0 && numberArray != nil && self.dataArray != nil && self.dataArray.count != 0) {
                
                NSString *questionString =[[NSString stringWithFormat:@"问题%@：",numberArray[indexPath.section]] stringByAppendingString:[NSString stringWithFormat:@"%@",[[self.dataArray[indexPath.section] objectForKey:@"question"] objectForKey:@"questionName"]]];
                NSRange range = [questionString rangeOfString:questionString];
                UIColor * valueColoe = isSetSafetyQuestion ? [WJUtilityMethod colorWithHexColorString:@"c7c7cc"]:WJColorDardGray6;
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:questionString];
                [str addAttribute:NSForegroundColorAttributeName value:valueColoe range:NSMakeRange( 4, range.length - 4)];
                //            [cell.textLabel setAttributedText: str];
                UILabel * qLabel = (UILabel *)[cell.contentView viewWithTag:10100 + indexPath.row ];
                [qLabel setAttributedText:str];
            }
            
            return cell;
            
        } else {
            
            WJSafetyQuestionCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"myCell2"];
            if (nil == cell1) {
                cell1 = [[WJSafetyQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell2"];
                cell1.backgroundColor = [UIColor whiteColor];
                cell1.questionText.delegate = self;
                cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            }
           
            
            cell1.tipTextLabel.textColor =  isSetSafetyQuestion ? [WJUtilityMethod colorWithHexColorString:@"c7c7cc"]:[WJUtilityMethod colorWithHexColorString:@"2f333b"];
            
            cell1.questionText.tag = indexPath.section + 10000;
            
            if (self.dataArray != nil && self.dataArray.count != 0) {
                
                if ([[self.dataArray[indexPath.section] objectForKey:@"answer"] isEqualToString:@""] || safetyQuestionType == SafetyQuestionTypeVerify) {
                    cell1.questionText.placeholder = @"请输入您的答案";
                }else{
                    cell1.questionText.text = [self.dataArray[indexPath.section] objectForKey:@"answer"];
                }
            }
            
            if (isSetSafetyQuestion) {
                cell1.questionText.userInteractionEnabled = NO;
                cell1.questionText.text = @"● ● ● ● ● ●";
                cell1.questionText.textColor = [WJUtilityMethod colorWithHexColorString:@"c7c7cc"];
            }else {
                cell1.questionText.userInteractionEnabled = YES;
                cell1.questionText.textColor = [WJUtilityMethod colorWithHexColorString:@"2f333b"];

            }
            
            return cell1;
        }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0,12);
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0,12);
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0 && (safetyQuestionType == SafetyQuestionTypeNew) &!isSetSafetyQuestion)
    {
        WJChoiceQuestionController *cqC = [[WJChoiceQuestionController alloc]init];
        cqC.changeArray = self.dataArray;
        cqC.num = indexPath.section;
        cqC.choiceBlock = ^(NSMutableArray * changeArray)
        {
            self.dataArray = changeArray;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:cqC animated:YES];
    }
    
}

#pragma mark - UITextFieldDelegate

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (answerNum < 3 && safetyQuestionType == SafetyQuestionTypeVerify) {
        answerNum = textField.tag - 10000 + 1;
        UITextField *tf = [self.view viewWithTag:textField.tag + 1];
        [tf becomeFirstResponder];
    }
    
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (safetyQuestionType == SafetyQuestionTypeNew)
    {
        answerNum = textField.tag - 10000;
        NSDictionary *dic = [self.dataArray objectAtIndex:answerNum];
        [dic setValue:textField.text forKey:@"answer"];
        [self.dataArray replaceObjectAtIndex:answerNum withObject:dic];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    answerNum = textField.tag - 10000;
    return YES;
}

#pragma mark - APIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APIUserSecurityQuestionsManager class]]) {
        
        NSArray * array = [manager fetchDataWithReformer:nil];
        NSLog(@"%@",array);
        self.dataArray = [NSMutableArray array];
        for (int i = 0; i < [array count]; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[array objectAtIndex:i] ,@"question",[NSString stringWithFormat:@"%ld",(long)choiceQuestionNum],@"number",@"",@"answer",nil];
            [self.dataArray addObject:dic];
        }
        [self.tableView reloadData];
        
    } else if ([manager isKindOfClass:[APIQuestionsCreateManager class]])
    {
        NSLog(@"安全问题提交成功！");
        
        WJModelPerson * person = [WJGlobalVariable sharedInstance].defaultPerson;
        person.isSetPsdQuestion = YES;
        [[WJDBPersonManager new] updatePerson:person];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"safetyQuestion" object:nil];
        
        [self hiddenLoadingView];
        
        [self viewDismiss];
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APIUserSecurityQuestionsManager class]]) {
        NSLog(@"安全问题获取失败！");
        
        [self showAlertViewByCancelTitle:@"取消" otherTitle:nil message:@"获取安全问题失败，请稍后再试"];

        
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        
        
    } else if ([manager isKindOfClass:[APIQuestionsCreateManager class]])
    {
        NSLog(@"安全问题提交失败！");
        
        [self showAlertViewByCancelTitle:@"取消" otherTitle:nil message:@"问题提交失败，请稍后再试"];
        
        
    }
    
}

- (void)showAlertViewByCancelTitle:(NSString *)cancleTitle otherTitle:(NSString *)otherTitle message:(NSString *)message
{
    WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:cancleTitle
                                                      otherButtonTitles:otherTitle
                                                          textAlignment:NSTextAlignmentCenter];
    [alert showIn];
}


#pragma mark - UIButton Action

- (void)nextBtnAction{
    BOOL isPush = YES;
    for (int i = 0; i < 3; i++)
    {
        if (safetyQuestionType == SafetyQuestionTypeNew
            && [[self.dataArray[i] objectForKey:@"number"] isEqualToString: @"0"])
        {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请选择问题"];
            isPush = NO;
            break;
        }

        UITextField *textField = [self.view viewWithTag:10000+i];
        if ([textField.text length] <= 0) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"答案不能为空"];
            isPush = NO;
            break;

        }
        if (![self isValidateText:textField.text]) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"答案只能由字母、汉字和数字组成"];
            isPush = NO;
            break;
        }
        
    }
    if (isPush) {
        WJSafetyQuestionController *sqVC = [[WJSafetyQuestionController alloc] initWithPsdType:SafetyQuestionTypeVerify];
        sqVC.oldArray = self.dataArray;
        [self.navigationController pushViewController:sqVC animated:YES];
    }
}


- (void)sureBtnAction
{
    BOOL isPush = YES;
    for (int i = 0; i < 3; i++)
    {
        UITextField *tf = [self.view viewWithTag:10000 + i];
      
        if ([tf.text length] <= 0) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"答案不能为空"];
            isPush = NO;
            break;
        }
        
        if (![[self.oldArray[i] objectForKey:@"answer"] isEqualToString:tf.text]
            && safetyQuestionType == SafetyQuestionTypeVerify)
        {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"问题验证不正确，请返回上一页面确认"];
            isPush = NO;
            break;
        }
    }

    if (isPush) {
        [self.createQuestionsManager loadData];
        [self showLoadingView];
    }

}


#pragma mark- Private Methods
-(BOOL)isValidateText:(NSString *)text {
    
    NSString *regex = @"^[A-Za-z0-9\u4e00-\u9fa5]+$" ;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:text];
}


- (void)viewDismiss
{
    WJViewController *wvc;
    for (wvc in self.navigationController.viewControllers)
    {
        if ([wvc isKindOfClass:[WJPaySettingController class]])
        {
            [self.navigationController popToViewController:wvc animated:YES];
            break;
        }
    }
    
}

//- (void)clickImage{
//    
//    [self.view endEditing:YES];
//    
//    if (safetyQuestionType == SafetyQuestionTypeNew) {
//        
//        if ([self checkInput]) {
//            nextBtn.enabled = YES;
//            [nextBtn setBackgroundColor:WJColorNavigationBar];
//        }else{
//            nextBtn.enabled = NO;
//            [nextBtn setBackgroundColor:WJColorDardGray9];
//        }
//        
//    }else{
//        
//        if ([self checkInput]) {
//            sureBtn.enabled = YES;
//            [sureBtn setBackgroundColor:WJColorNavigationBar];
//        }else{
//            sureBtn.enabled = NO;
//            [sureBtn setBackgroundColor:WJColorDardGray9];
//        }
//        
//    }
//}


//- (BOOL)checkInput{
//    for (int i = 0; i < 3; i++) {
//        UITextField *tf = [self.view viewWithTag:10000 + i];
//        if ([tf.text isEqualToString:@""]) {
//            return NO;
//        }
//    }
//    return YES;
//}

- (void)keyboardWillShown:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    int discrepancy = ([UIScreen mainScreen].bounds.size.height - kbSize.height - 10 - 64) - (ALD(15)+ALD(45)*2) * (answerNum + 1) ;
    if (discrepancy < 0) {
        self.tableView.contentInset = UIEdgeInsetsMake(discrepancy,0,0,0);
    }else{
        self.tableView.contentInset = UIEdgeInsetsZero;
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.tableView.contentInset = UIEdgeInsetsZero;
}


#pragma mark- Getter and Setter

- (APIQuestionsCreateManager *)createQuestionsManager
{
    if (!_createQuestionsManager) {
        _createQuestionsManager = [[APIQuestionsCreateManager alloc] init];
        _createQuestionsManager.delegate = self;
        NSMutableArray * questionsArray = [NSMutableArray array];
        NSMutableArray * answersArray = [NSMutableArray array];
        for (int i = 0 ; i < 3; i++) {
            NSString * questionStr = [self.oldArray[i] objectForKey:@"number"];
            NSString * answersStr = [self.oldArray[i] objectForKey:@"answer"];
            [questionsArray addObject:questionStr];
            [answersArray addObject:answersStr];
        }
        _createQuestionsManager.questionsArray = questionsArray;
        _createQuestionsManager.answersArray = answersArray;
    }

    return _createQuestionsManager;
}

- (APIUserSecurityQuestionsManager *)securityQuestionsManager
{
    if (!_securityQuestionsManager) {
        _securityQuestionsManager = [[APIUserSecurityQuestionsManager alloc] init];
        _securityQuestionsManager.delegate = self;
    }
    return _securityQuestionsManager;
}

-(UITableView* ) tableView
{
    if(nil == mainTableView)
    {
        mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        mainTableView.delegate = self;
        mainTableView.dataSource = self;
        mainTableView.separatorInset = UIEdgeInsetsZero;
        mainTableView.separatorColor = [WJUtilityMethod colorWithHexColorString:@"e6e7e8"];
        mainTableView.backgroundColor = WJColorViewBg;
        mainTableView.tableFooterView = isSetSafetyQuestion?[[UIView alloc] init] : [self sectionFootView];
        
        if (safetyQuestionType == SafetyQuestionTypeNew) {
            UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 32)];
            headerView.backgroundColor = [UIColor clearColor];
            
            UIImageView * tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDefaultWidth, (32- ALD(15))/2.0, ALD(15), ALD(15))];
            //        tipImageView.backgroundColor = [WJUtilityMethod randomColor];
            tipImageView.image = [UIImage imageNamed:@"tip_safe_image"];
            UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tipImageView.frame) + 10,(32- ALD(15))/2.0, kScreenWidth - CGRectGetMaxX(tipImageView.frame) - kDefaultWidth, CGRectGetHeight(tipImageView.frame))];
            //        tipLabel.backgroundColor = [WJUtilityMethod randomColor];
            
            if (isSetSafetyQuestion) {
                tipLabel.text = @"您已设置安全问题";
            } else
            {
                tipLabel.text = @"设置安全问题，可帮助您找回密码";
            }
            
            tipLabel.font = WJFont12;
            tipLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"9099a6"];
            
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 31, kScreenWidth, 1)];
            line.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"e6e7e8"];
            
            [headerView addSubview:tipImageView];
            [headerView addSubview:tipLabel];
            [headerView addSubview:line];

            mainTableView.tableHeaderView = headerView;
        }
        
    }
    return mainTableView;
}

- (UIView *) sectionFootView
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(ALD(15), ALD(15), [UIScreen mainScreen].bounds.size.width, ALD(100))];
    footView.backgroundColor = [UIColor clearColor];
    if (safetyQuestionType == SafetyQuestionTypeNew) {
        UILabel *alterLabel = [[UILabel alloc]initWithFrame:CGRectMake(ALD(0), ALD(15),[UIScreen mainScreen].bounds.size.width, ALD(20))];
        alterLabel.text = @"提示：请尽量设置印象深刻且容易记忆的问题和答案";
        alterLabel.font = WJFont12;
        alterLabel.textColor = WJColorDardGray9;
        
        nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nextBtn.frame = CGRectMake(0,  ALD(30), ALD(345),ALD(48));
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        nextBtn.layer.cornerRadius = 4;
        [nextBtn setBackgroundColor:WJColorNavigationBar];
//        nextBtn.enabled = NO;
        [nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
//        [footView addSubview:alterLabel];
        [footView addSubview:nextBtn];
        
    } else {
        sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake(0,ALD(30), ALD(345),ALD(48));
        [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
        sureBtn.layer.cornerRadius = 4;
//        sureBtn.enabled = NO;
        [sureBtn setBackgroundColor:WJColorNavigationBar];
        [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [footView addSubview:sureBtn];
    }
    
    return footView;
}

@end
