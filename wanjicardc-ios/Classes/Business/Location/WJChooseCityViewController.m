//
//  WJChooseCityViewController.m
//  WanJiCard
//
//  Created by Lynn on 15/9/10.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJChooseCityViewController.h"
#import "WJRefreshTableView.h"
#import "WJDBAreaManager.h"
#import "WJTabsTableViewCell.h"
#import "WJDBAreaManager.h"
#import "WJModelArea.h"
#import "LocationManager.h"


@interface WJChooseCityViewController ()<UITableViewDataSource, UITableViewDelegate,WJTabSelectedDelegate>

@property (nonatomic, strong) WJRefreshTableView        *tableView;
@property (nonatomic, strong) NSArray                   *cityArray;
@property (nonatomic, strong) NSArray                   *sectionTitleArray;

@end

@implementation WJChooseCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self UISetup];
    
}


#pragma mark - WJTabsTableViewCellDelegate
- (void)tabsTableView:(WJTabsTableViewCell *) cell didSelectedByIndex:(int)index
{
    NSLog(@"%d",index);
    
    switch (cell.tag / 10000) {
        case 2:
            break;
            
        case 3:
        {
            WJModelArea * area = (WJModelArea *) [[self.cityArray objectAtIndex:1] objectAtIndex:index];

            //smy
            [LocationManager sharedInstance].choosedArea = area;
            
            [kDefaultCenter postNotificationName:kCityUpdate object:nil];
        }
            break;
        default:
            break;
    }
    
  
    
    [self backAction];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [WJTabsTableViewCell heightWightArray:[self.cityArray objectAtIndex:indexPath.section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJTabsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (nil == cell) {
        cell = [[WJTabsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.delegate = self;
    }
    
    if (indexPath.section == 0) {
        cell.userInteractionEnabled = NO;
        cell.tag = 20000;
    }else
    {
        cell.tag = 30000;
    }
    
    [cell setTabsArray:[self.cityArray objectAtIndex:indexPath.section]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ALD(30);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(30))];
    aView.backgroundColor = [UIColor whiteColor];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), 0, 200, 30)];
    titleLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = [self.sectionTitleArray objectAtIndex:section];
    
    UIView  * line = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(29), kScreenWidth, ALD(1))];
    line.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"e5e5e5"];
    [aView addSubview:titleLabel];
    [aView addSubview:line];
    return aView;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    NSLog(@"%s",__func__);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark- Event Response
// TODO:所有 button、gestureRecognizer、notification 的事件相应方法，与跳转到其他 controller 的出口方法都写在这里。

- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark- Rotation
// TODO:转屏处理写在这。
#pragma mark- Private Methods
// TODO:理论上来说，此处不应有私有方法存在，都应该在上面找到归类。这里应该放置拆分的中间方法。

- (void)UISetup
{
    [self.view addSubview:self.tableView];
    self.title = @"选择城市";
    self.eventID = @"iOS_act_choosecity";
    [self navSetUp];
    
}


- (void)navSetUp
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 22, 22)];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"back_x"] forState:UIControlStateNormal];
//    button.backgroundColor = [WJUtilityMethod randomColor];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}
#pragma mark- Getter and Setter
// TODO:所有属性的初始化，都写在这
- (UITableView  *)tableView
{
    if (nil == _tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain refreshNow:NO refreshViewType:WJRefreshViewTypeNone];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.automaticallyRefresh = YES;
    }
    return _tableView;
}

- (void)setCurrentCity:(NSString *)currentCity
{
    _currentCity = currentCity;

}

- (NSArray *)cityArray
{
    if (nil == _cityArray) {
        _cityArray = @[[self areaWithUserdefault], [[WJDBAreaManager new] getAreaByLevel:2]];
    }
    
    return _cityArray;
}

- (NSArray *)sectionTitleArray
{
    return @[@"当前城市",@"已开通城市"];
}

- (NSArray *)areaWithUserdefault
{
    WJModelArea * areaModel = [LocationManager sharedInstance].choosedArea;

    return @[areaModel];
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
