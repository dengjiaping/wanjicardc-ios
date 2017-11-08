//
//  WJCityView.m
//  WanJiCard
//
//  Created by 孙明月 on 16/5/20.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJCityView.h"
#import "WJRefreshTableView.h"
#import "WJDBAreaManager.h"
#import "WJTabsTableViewCell.h"
#import "WJDBAreaManager.h"
#import "WJModelArea.h"
#import "LocationManager.h"

@interface WJCityView() <UITableViewDelegate,UITableViewDataSource,WJTabSelectedDelegate>

@property (nonatomic, strong) NSArray *cityArray;
@property (nonatomic, strong) NSArray *sectionTitleArray;
@property (nonatomic, assign)CGFloat tableHeight;

@end

@implementation WJCityView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor clearColor];
        self.eventID = @"iOS_act_choosecity";
        
        UIView *backView = [[UIView alloc] initWithFrame:frame];
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self addSubview:backView];
        
//        CGFloat tableH = MIN(self.tableHeight, SCREEN_HEIGHT - 64 - kTabbarHeight);

        self.cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ALD(250)) style:UITableViewStylePlain];
        self.cityTableView.delegate = self;
        self.cityTableView.dataSource = self;
        self.cityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.cityTableView.backgroundColor = [UIColor clearColor];
        self.cityTableView.bounces = NO;
        [self addSubview:self.cityTableView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takeBack:)];
        [backView addGestureRecognizer:tapGesture];
    }
    
    return self;
}


#pragma mark - WJTabsTableViewCellDelegate

- (void)tabsTableView:(WJTabsTableViewCell *) cell didSelectedByIndex:(int)index
{
    NSLog(@"%d",index);
    
    switch (cell.tag / 100) {
        case 2:
            break;
            
        case 3:
        {
            WJModelArea * area = (WJModelArea *) [[self.cityArray objectAtIndex:1] objectAtIndex:index];
            
            [LocationManager sharedInstance].choosedArea = area;
            [self.cityTableView reloadData];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateCity:)]) {
                [self.delegate updateCity:self];
            }

        }
            break;
        default:
            break;
    }
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
    if (indexPath.section == 0) {
        return [WJTabsTableViewCell heightWightArray:[self.cityArray objectAtIndex:indexPath.section]] - ALD(10);
    }else{
        return [WJTabsTableViewCell heightWightArray:[self.cityArray objectAtIndex:indexPath.section]] + ALD(10);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJTabsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CityCellID"];
    if (nil == cell) {
        cell = [[WJTabsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CityCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.delegate = self;
    }
    
    if (indexPath.section == 0) {
        cell.userInteractionEnabled = NO;
        cell.tag = 200;
    }else
    {
        cell.tag = 300;
    }
    
    [cell setTabsArray:[self.cityArray objectAtIndex:indexPath.section]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ALD(40);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(40))];
    aView.backgroundColor = WJColorViewBg;
   
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), 0, 200, ALD(40))];
    titleLabel.textColor = WJColorLightGray;
    titleLabel.font = WJFont14;
    titleLabel.text = [self.sectionTitleArray objectAtIndex:section];
    titleLabel.backgroundColor = [UIColor clearColor];
    [aView addSubview:titleLabel];

    return aView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//点击空白处
- (void)takeBack:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(takeBackView:)]) {
        [self.delegate takeBackView:self];
    }
}


#pragma mark- Getter and Setter

- (void)setCurrentCity:(NSString *)currentCity
{
    _currentCity = currentCity;
    
}


- (NSArray *)cityArray
{
    _cityArray = @[[self areaWithUserdefault], [[WJDBAreaManager new] getAreaByLevel:2]];
    
    return _cityArray;
}


- (NSArray *)sectionTitleArray
{
    return @[@"当前城市",@"热门城市"];
}


- (NSArray *)areaWithUserdefault
{
    WJModelArea * areaModel = [LocationManager sharedInstance].choosedArea;
    
    return @[areaModel];
}


- (CGFloat )tableHeight
{
    _tableHeight = [WJTabsTableViewCell heightWightArray:[self.cityArray objectAtIndex:0]] +
                    [WJTabsTableViewCell heightWightArray:[self.cityArray objectAtIndex:1]] + ALD(80);
    
    return _tableHeight;
}

@end
