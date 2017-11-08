//
//  WJFindPsdWayViewController.m
//  WanJiCard
//
//  Created by 孙明月 on 15/12/1.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJFindPsdWayViewController.h"
#import "WJAppealViewController.h"
#import "WJFindSafetyQuestionController.h"
@interface WJFindPsdWayViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _appealStatus;
}
@end

@implementation WJFindPsdWayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"选择找回方式";
   
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
    //如果未登录
    if (nil == person) {
 
         _appealStatus = [[[[NSUserDefaults standardUserDefaults] objectForKey:kTokenForChangePhone] objectForKey:@"appealStatus"] integerValue];
       
    }else{
        
        _appealStatus = person.appealStatus;
    }
   
    UITableView *mTb = [[UITableView alloc] initForAutoLayout];
    mTb.delegate = self;
    mTb.dataSource = self;
    mTb.separatorInset = UIEdgeInsetsZero;
    mTb.tableFooterView = [UIView new];
    mTb.scrollEnabled = NO;
    mTb.backgroundColor = WJColorViewBg;
    [self.view addSubview:mTb];
    
    [self.view VFLToConstraints:@"H:|[mTb]|" views:NSDictionaryOfVariableBindings(mTb)];
    [self.view VFLToConstraints:@"V:|[mTb]|" views:NSDictionaryOfVariableBindings(mTb)];
    
}


// Called when the parent application receives a memory warning. On iOS 6.0 it will no longer clear the view by default.
- (void)didReceiveMemoryWarning
{
    // TODO:内存警告时，要处理的逻辑代码写在这里。
}

#pragma mark- UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ALD(15);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(45);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;

    if (person) {
        
        if (person.isSetPsdQuestion) {
           
            return 2;
            
        }else{
            return 1;
        }
        
    }else{
    
        return 1;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WayCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WayCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.textLabel.textColor = WJColorDardGray3;
        cell.textLabel.font = WJFont14;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"使用账号申诉找回";
        
    }else {
        cell.textLabel.text = @"使用安全问题找回";
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        
        if(_appealStatus == AppealNoInfo){
        
            WJAppealViewController *findPswVC = [[WJAppealViewController alloc] init];
            [self.navigationController pushViewController:findPswVC animated:YES];
            
        }
       
        if (_appealStatus == AppealProcessing){
        
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"申诉处理中"];
        }
        
    }else{
        
        WJFindSafetyQuestionController *findSafeVC = [[WJFindSafetyQuestionController alloc] init];
        [self.navigationController pushViewController:findSafeVC animated:YES];
    
    }
}

- (void)backBarButton:(UIButton *)btn{
    
    WJViewController *vc = [[WJGlobalVariable sharedInstance] fromController];

    [self.navigationController popToViewController:vc animated:YES];
}

@end
