//
//  WJAppealViewController.m
//  WanJiCard
//
//  Created by 孙明月 on 15/12/1.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJAppealViewController.h"
#import "WJAppealTableViewCell.h"
#import "WJAppealSubmitViewController.h"

@interface WJAppealViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UITableView *mTb;
    NSString *_currentYear;
    NSString *_currentMonth;
    
    UIView * _maskView;//黑色底
    
    NSString *_selectYear;//选择的年
    NSString *_selectMoth;//选择的月
    NSInteger _yearIndex;
    NSInteger _monthIndex;
    UIButton *_nextButton;

    
}

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSMutableArray *yearsArray;
@property (strong, nonatomic) NSMutableArray *monthsArray;
@property (strong, nonatomic) NSMutableArray *currentYearMonthsArray;


@end

@implementation WJAppealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申诉信息";
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM"];
    
    _currentYear = [[dateFormater stringFromDate:currentDate] substringToIndex:4];
    _currentMonth = [[dateFormater stringFromDate:currentDate] substringFromIndex:5];
    
    _selectYear = [self.yearsArray firstObject];
    _selectMoth = [self.monthsArray firstObject];
    _yearIndex = 0;
    _monthIndex = 0;
    
    [self initSubviews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initSubviews
{
    mTb = [[UITableView alloc] initForAutoLayout];
    mTb.delegate = self;
    mTb.dataSource = self;
    mTb.separatorInset = UIEdgeInsetsZero;
    mTb.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    mTb.separatorColor = [WJUtilityMethod colorWithHexColorString:@"e6e7e8"];
    mTb.backgroundColor = WJColorViewBg;
    mTb.scrollEnabled = NO;
    [self.view addSubview:mTb];
    
    [self.view VFLToConstraints:@"H:|[mTb]|" views:NSDictionaryOfVariableBindings(mTb)];
    [self.view VFLToConstraints:@"V:|[mTb]|" views:NSDictionaryOfVariableBindings(mTb)];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(140))];
    backView.backgroundColor = [UIColor clearColor];
    
    UILabel * tipLabel = [[UILabel alloc] init];
    tipLabel.numberOfLines = 0;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipLabel.font = WJFont12;
    tipLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"9099a6"];
    [tipLabel setText:@"申诉结果会在48小时内通过短信发到您的手机\n\n申诉成功后请根据指引尽快修改支付密码"];
    
    CGSize desTxtSize = [tipLabel.text sizeWithAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    tipLabel.frame=CGRectMake((kScreenWidth - desTxtSize.width)/2,  ALD(30), kScreenWidth - ALD(40), ALD(40));
    
    [backView addSubview:tipLabel];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton.frame = CGRectMake(ALD(15), ALD(30) + CGRectGetMaxY(tipLabel.frame), kScreenWidth - ALD(30), ALD(40));
    _nextButton.layer.masksToBounds = YES;
    _nextButton.layer.cornerRadius = ALD(6);
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton.titleLabel setFont:WJFont14];
    _nextButton.enabled = NO;
    [_nextButton setBackgroundImage:[WJUtilityMethod imageFromColor:[WJUtilityMethod colorWithHexColorString:@"cccccc"] Width:1 Height:1] forState:UIControlStateDisabled];
    [_nextButton setBackgroundImage:[WJUtilityMethod imageFromColor:kBlueColor Width:1 Height:1] forState:UIControlStateNormal];
    [backView addSubview:_nextButton];
    [_nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    mTb.tableFooterView = backView;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletapPressGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    self.view.tag = 10009;
}

- (BOOL)buttonEnableAction
{
    int tem = 0b1;
    for (int i = 0; i < 4; i++) {
        UITextField * tf = (UITextField *)[mTb viewWithTag:(10000 + i)];
        
        if(tf.text.length>0)
        {
            tem = tem<<1;
        }else
        {
            tem = tem >> 1;
        }
    }
    
    if (tem == 0b10000) {
        return YES;
    }
    return NO;
}

#pragma mark- UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(45);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    footerView.backgroundColor = WJColorSeparatorLine;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJAppealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppealCell"];
    if (cell == nil) {
        cell = [[WJAppealTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppealCell"];
        cell.valueTF.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indentationLevel = 1;
    }
    
    cell.valueTF.textAlignment = NSTextAlignmentLeft;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.titleLabel.textColor = WJColorDarkGray;
    cell.valueTF.textColor = WJColorDarkGray;
    cell.valueTF.delegate = self;
    cell.valueTF.tag = 10000 + indexPath.row;
    
    
    if (indexPath.row == 3) {
        cell.titleLabel.text = @"注册时间";
        cell.valueTF.placeholder = @"选择注册时间";
        cell.rightIV.hidden = NO;
        
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.rightIV.hidden = YES;
        
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"真实姓名";
            cell.valueTF.placeholder = @"请输入您的真实姓名";
            
        }else if(indexPath.row == 1){
            cell.titleLabel.text = @"身份证号";
            cell.valueTF.placeholder = @"请输入您的身份证号码";
            
        }else{
            cell.titleLabel.text = @"手机号码";
            cell.valueTF.placeholder = @"请输入您的手机号";
            if (self.userPhone) {
                cell.valueTF.textColor = WJColorAlert;
                cell.valueTF.text = self.userPhone;
                cell.valueTF.enabled = NO;
            }
        }
    }
    
    return cell;
}


#pragma mark- pickview delegate &source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
   
    return 2;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (0 == component) {
        
        return [self.yearsArray count];
        
    }else{
        
        if (_selectYear < _currentYear) {
            
            return [self.monthsArray count];
            
        } else {
            
            return [self.currentYearMonthsArray count];
        }
//        return [self.monthsArray count];
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (0 == component) {
        
        return [NSString stringWithFormat:@"%@年",[self.yearsArray objectAtIndex:row]];
        
    }else{

        return [NSString stringWithFormat:@"%@月",[self.monthsArray objectAtIndex:row]];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (0 == component)
    {
        _selectYear = [self.yearsArray objectAtIndex:row];
        _yearIndex = row;
        _monthIndex = 0;
  
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        _selectMoth = [self.monthsArray objectAtIndex:0];
        
    }else{
            
        _monthIndex = row;
        _selectMoth = [self.monthsArray objectAtIndex:row];
    
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

#pragma mark- Event Response
- (void)nextAction:(UIButton *)button{
    
    WJAppealTableViewCell *namecell = (WJAppealTableViewCell *)[mTb cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    WJAppealTableViewCell *IDcell = (WJAppealTableViewCell *)[mTb cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    WJAppealTableViewCell *phonecell = (WJAppealTableViewCell *)[mTb cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    WJAppealTableViewCell *timecell = (WJAppealTableViewCell *)[mTb cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    if ([namecell.valueTF.text length] <= 0) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请填写真实姓名"];
        return;
    }
    if (![self isValidateName:namecell.valueTF.text]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"真实姓名只能由中文和字母组成"];
        return;
    }
    
    if ([IDcell.valueTF.text length] <= 0) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请填写身份证号"];
        return;
    }
    
    if (![IDcell.valueTF.text isIDCardNumber]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"身份证号不合法"];
        return;
    }

    if ([phonecell.valueTF.text length] <= 0) {
      
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请填写手机号"];
    }
   
    if (![phonecell.valueTF.text isMobilePhoneNumber]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入正确手机号"];
        return;
    }
    
    if ([timecell.valueTF.text length] <= 0) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请选择注册时间"];
        return;
    }
    
    [self handletapPressGesture:nil];
    
    NSString *month = _selectMoth;
    if ([_selectMoth intValue]<10) {
        month = [NSString stringWithFormat:@"0%@",_selectMoth];
    }
  
    NSDictionary *appealDic = [NSDictionary dictionaryWithObjects:@[namecell.valueTF.text, IDcell.valueTF.text, phonecell.valueTF.text, _selectYear, month] forKeys:@[@"name",@"idno",@"Phone",@"year",@"month"]];
    
    WJAppealSubmitViewController * submitVC = [[WJAppealSubmitViewController alloc] init];
    submitVC.appealInfo = appealDic;
    [self.navigationController pushViewController:submitVC animated:YES];
    
}


-(BOOL)isValidateName:(NSString *)nameText {
    
    NSString *regex = @"^[A-Za-z\u4e00-\u9fa5]+$" ;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    return [pred evaluateWithObject:nameText];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField.tag == 10001) {
        
        if (!string && textField.text.length >= 18) {
            return NO;
        }
        
    }
    if(textField.tag == 10002){
        
        if (!string && textField.text.length >= 11) {
            return NO;
        }
        
    }
    
    return YES;
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    _nextButton.enabled = [self buttonEnableAction];
    
    if (textField.tag == 10003) {
  
        [self handletapPressGesture:nil];
        
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [_maskView addSubview:self.pickerView];
        
        UIView * grayView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - self.pickerView.frame.size.height - 40 , kScreenWidth, 40)];
        grayView.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"aeaeae"];
        [_maskView addSubview:grayView];

        if([textField.text length] > 0){
            
            for (int i=0; i < self.yearsArray.count; i++) {
                NSString *year = [self.yearsArray objectAtIndex:i];
                NSString *ye = [textField.text substringToIndex:5];
                
                if ([ye isEqualToString:year]) {

                    _yearIndex = i;

                    for (int j=0; j < self.monthsArray.count; j++) {
                        NSString *month = [self.monthsArray objectAtIndex:j];
                        NSString *mon = [textField.text substringFromIndex:6];
                        if ([mon isEqualToString:month]) {
                            _monthIndex = j;
                        }
                    }
                }
            }

            [self.pickerView  reloadComponent:0];
            [self.pickerView  reloadComponent:1];
            [self.pickerView selectRow:_yearIndex inComponent:0 animated:YES];//设置某列选择某行
            [self.pickerView selectRow:_monthIndex inComponent:1 animated:YES];
    }
        
        // xxx
        UILabel *birthLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 0, kScreenWidth-120, 40)];
//        birthLabel.text = [NSString stringWithFormat:@"当前: %@年%@月",[self.yearsArray objectAtIndex:_yearIndex], [self.monthsArray objectAtIndex:_monthIndex]];
        birthLabel.text = @"设置时间";
        birthLabel.font = WJFont17;
        [birthLabel setTextColor:WJColorDardGray3];
        [birthLabel setTextAlignment:NSTextAlignmentCenter];
        birthLabel.backgroundColor=[UIColor whiteColor];
        [grayView addSubview:birthLabel];
        
        // 添加确定button
        UIButton *okButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-60, 0, 60, 40)];
        [okButton.titleLabel setFont:WJFont15];
        okButton.backgroundColor = [UIColor whiteColor];
        [okButton setTitle:@"确定" forState:UIControlStateNormal];
        [okButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(clickOk:) forControlEvents:UIControlEventTouchUpInside];
        [grayView addSubview:okButton];
        
        //  取消button
        UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        cancelButton.backgroundColor = [UIColor whiteColor];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:WJFont15];
        [cancelButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];
        [grayView addSubview:cancelButton];
        
        //添加手势
        UITapGestureRecognizer *tapGestureAddress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapgesture:)];
        [_maskView addGestureRecognizer:tapGestureAddress];
        [[UIApplication sharedApplication].keyWindow addSubview:_maskView];
        return NO;
        
    }else{
        
        return YES;
    }
}

- (void)handletapPressGesture:(UITapGestureRecognizer *)tap
{
    for (int i= 0; i<3; i++) {
        WJAppealTableViewCell *cell = [mTb cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell.valueTF resignFirstResponder];
    }
}


- (void)tapgesture:(UITapGestureRecognizer*) tap
{
    [tap.view removeFromSuperview];
}


- (void)clickOk:(UIButton *) button
{
    
//    [button.superview.superview removeFromSuperview];
    [_maskView removeFromSuperview];
    
    //刷新
    WJAppealTableViewCell *cell = (WJAppealTableViewCell *)[mTb cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    cell.valueTF.text = [NSString stringWithFormat:@"%@年%@月", _selectYear, _selectMoth];
    _nextButton.enabled = [self buttonEnableAction];
}

- (void)clickCancel:(UIButton *) button
{
 
//    [button.superview.superview removeFromSuperview];
    [_maskView removeFromSuperview];
}


- (UIPickerView *)pickerView
{
    if(nil==_pickerView)
    {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight-199.5,kScreenWidth, 199.5)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        
        CGFloat height = CGRectGetHeight(_pickerView.frame);
        [_pickerView setFrame:CGRectMake(0, kScreenHeight - height, kScreenWidth, height)];
    }
    return _pickerView;
}


- (NSMutableArray *)yearsArray
{
    if (nil == _yearsArray) {
        
        _yearsArray = [[NSMutableArray alloc]init];
        
        for (int i=2010; i<= [_currentYear intValue]; i++) {
            NSString *year = [NSString stringWithFormat:@"%d",i];
            [_yearsArray addObject:year];
        }
    }
    
    return _yearsArray;
}


- (NSMutableArray *)monthsArray
{
    
    if (nil == _monthsArray) {
        
        _monthsArray = [[NSMutableArray alloc]init];
        
        for (int i=1; i<13; i++) {
            NSString *month = [NSString stringWithFormat:@"%d",i];
            [_monthsArray addObject:month];
        }
    }
    return _monthsArray;
}


- (NSMutableArray *)currentYearMonthsArray
{
    
    if (nil == _currentYearMonthsArray) {
        
        _currentYearMonthsArray = [[NSMutableArray alloc]init];
        
        for (int i = 1; i<=[_currentMonth intValue]; i++) {
            NSString *month = [NSString stringWithFormat:@"%d",i];
            [_currentYearMonthsArray addObject:month];
        }
        
    }
    return _currentYearMonthsArray;
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
