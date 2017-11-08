//
//  WJChoiceQuestionController.m
//  WanJiCard
//
//  Created by XT Xiong on 15/12/2.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJChoiceQuestionController.h"

#import "APIQuestionsListManager.h"

@interface WJChoiceQuestionController ()<UITableViewDataSource,UITableViewDelegate,APIManagerCallBackDelegate>

@property (strong,nonatomic) UITableView              * mainTableView;
@property (strong,nonatomic) NSMutableArray           * dataArray;

@property (strong,nonatomic) APIQuestionsListManager  * questionsListManager;

@end

@implementation WJChoiceQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.questionsListManager loadData];
    self.title = @"安全问题";
    [self.view addSubview:self.tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = @{NSFontAttributeName : WJFont16};
    CGRect rect = [[self.dataArray[indexPath.row] objectForKey:@"questionName"] boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height + ALD(20);
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell1"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < self.changeArray.count; i++) {
        NSString *notChoiceStr = [self.changeArray[i] objectForKey:@"number"];
        NSDictionary *quesDic = [self.dataArray objectAtIndex:indexPath.row];
        if (![notChoiceStr isEqualToString:@"0"] && [[quesDic objectForKey:@"id"] isEqualToString:notChoiceStr]) {
            cell.userInteractionEnabled = NO;
        }

    }

    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"questionName"];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = WJFont16;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.changeArray objectAtIndex:self.num];
    [dic setValue:@{@"id":@"0",@"questionName":[_dataArray[indexPath.row] objectForKey:@"questionName"]} forKey:@"question"];
    [dic setValue:[dic objectForKey:@"answer"] forKey:@"answer"];
    [dic setValue:ToString([_dataArray[indexPath.row] objectForKey:@"id"]) forKey:@"number"];
    
    [self.changeArray replaceObjectAtIndex:self.num withObject:dic];
    self.choiceBlock(self.changeArray);
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - APIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    self.dataArray = [manager fetchDataWithReformer:nil];
    [self.tableView reloadData];
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    NSDictionary * dic = [manager fetchDataWithReformer:nil];
    NSLog(@"dic = %@",dic);
}


#pragma mark- Getter and Setter

-(UITableView* ) tableView
{
    if(nil == _mainTableView)
    {
        _mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorInset = UIEdgeInsetsZero;
        _mainTableView.backgroundColor = WJColorViewBg;
    }
    return _mainTableView;
}


- (APIQuestionsListManager *)questionsListManager
{
    if (nil == _questionsListManager) {
        _questionsListManager = [[APIQuestionsListManager alloc]init];
        _questionsListManager.delegate = self;
    }
    return _questionsListManager;
}

    
@end
