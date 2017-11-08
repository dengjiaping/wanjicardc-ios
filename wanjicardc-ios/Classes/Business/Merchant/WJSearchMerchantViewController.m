//
//  WJSearchMerchantViewController.m
//  WanJiCard
//
//  Created by Lynn on 15/9/11.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJSearchMerchantViewController.h"
#import "APIHotKeysManager.h"
#import "WJHotKeysReformer.h"
#import "WJRefreshTableView.h"
#import "WJSearchTableViewCell.h"
#import "WJMerchantListViewController.h"
#import "WJHotKeysModel.h"
#import "WJSearchHistoryTableCell.h"
#import "WJClearHistoryTableCell.h"

#define kHistoryNumberMax       10

@interface WJSearchMerchantViewController ()<UISearchBarDelegate,APIManagerCallBackDelegate,UITableViewDataSource,UITableViewDelegate,WJSearchTableViewCellDelegate, WJClearHistoryTableCellDelegate>
{
    UISearchBar * wjsearchBar;
}
@property (nonatomic, strong)APIHotKeysManager      *hotKeysManager;
@property (nonatomic, strong)NSArray                *hotKeysArray;
@property (nonatomic, strong)WJRefreshTableView     *tableView;

@property (nonatomic, strong)NSMutableArray         *historyArray;
@property (nonatomic, strong)NSArray                *sectionTitleArray;
@end

@implementation WJSearchMerchantViewController

#pragma mark- Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.eventID = @"iOS_act_search";
    [self hiddenBackBarButtonItem];
    [self UISetup];
    [self.hotKeysManager loadData];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.historyArray = nil;
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - SearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [wjsearchBar becomeFirstResponder];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
   
    BOOL hasEmp = NO;
    
    if ([searchBar.text length] > 0) {
        for (int i =0; i<[searchBar.text length]; i++) {
            NSString *s = [searchBar.text substringWithRange:NSMakeRange(i, 1)];
            if ([s isEqualToString:@" "]) {
                hasEmp = YES;
                break;
            }
        }
        //如果有空格
        if (hasEmp) {
            
            NSString *searchStr = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];

            if ([searchStr length] > 0) {
                
                [self searchMerchant:searchStr];
                
            }else{
                ALERT(@"搜索内容不能为空");
            }
           
        }else{
            
            [self searchMerchant:searchBar.text];
        }
        
    }else{
    
        ALERT(@"搜索内容不能为空");
    }
    
}

- (void)searchMerchant:(NSString *)text
{
    [self editHistoryList:text];
    [wjsearchBar resignFirstResponder];
    
    WJMerchantListViewController * merchantListVC = [[WJMerchantListViewController alloc] init];
    merchantListVC.eventID = @"iOS_act_searchresult";
    merchantListVC.from = EnterFromSearch;     
    merchantListVC.searchManager.merName = text;
    [self.navigationController pushViewController:merchantListVC animated:YES];
}


#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APIHotKeysManager class]]) {
        self.hotKeysArray =  [manager fetchDataWithReformer:[[WJHotKeysReformer alloc] init]];
        [self.tableView reloadData];
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    NSLog(@"fail:%s", __FUNCTION__);
    NSLog(@"fail:%@",manager);
}


#pragma mark - WJTabSelectedDelegate
- (void)tabsTableView:(WJSearchTableViewCell *)cell didSelectedByIndex:(int)index
{
    [self searchMerchant:((WJHotKeysModel *)[self.hotKeysArray objectAtIndex:index]).name];
}

#pragma mark - WJClearHistoryTableCellDelegate
- (void)clearHistoryWithCell:(WJClearHistoryTableCell *)cell
{
   
    [self.historyArray removeAllObjects];
    
    WJModelPerson * persion = [WJGlobalVariable sharedInstance].defaultPerson;
    
    if (persion) {
        
        [[NSUserDefaults standardUserDefaults] setObject:self.historyArray forKey:[NSString stringWithFormat:@"%@history",persion.phone]];
        
    }else{
        
        [[NSUserDefaults standardUserDefaults] setObject:self.historyArray forKey:[NSString stringWithFormat:@"searchHistory"]];
    }
    
    [self.tableView reloadData];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [wjsearchBar resignFirstResponder];
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    switch (section) {
      
        case 0:
        {
            if(self.hotKeysArray.count > 0){
               
                return 2;
                
            }else{
                
                return 0;
            }
        }
            break;
        case 1:
        {
            if (self.historyArray.count > 0) {
               
                return [self.historyArray count] + 2;
                
            }else{
                
                return 0;
            }
        }
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
         return ALD(32);
    }else{
    
        if (indexPath.section == 0) {
            return [WJSearchTableViewCell heightWightArray:self.hotKeysArray];
        }else{
            return ALD(44);
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleCell"];
            cell.backgroundColor = WJColorViewBg;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = [self.sectionTitleArray objectAtIndex:indexPath.section];
        cell.textLabel.textColor = WJColorDarkGray;
        cell.textLabel.font = WJFont14;
        return cell;
        
    }else{
       
        if (indexPath.section == 0) {
            WJSearchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"hotkeyCell"];
            if (!cell) {
                cell = [[WJSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotkeyCell"];
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell setTabsArray:self.hotKeysArray];
            return cell;
            
        }else{
            if (self.historyArray.count > 0) {
               
                if (indexPath.row <= self.historyArray.count) {
                    WJSearchHistoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell"];
                    if (!cell) {
                        cell = [[WJSearchHistoryTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"historyCell"];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.backgroundColor = WJColorWhite;
                        if (indexPath.row == 1) {
                            UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
                            upLine.backgroundColor = WJColorSeparatorLine;
                            [cell.contentView addSubview:upLine];
                        }
                    }
                 
                    cell.nameLabel.text = [self.historyArray objectAtIndex:indexPath.row-1];
                    
                    return cell;
 
                }else{
                   
                    WJClearHistoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clearCell"];
                    if (!cell) {
                        cell = [[WJClearHistoryTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"clearCell"];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.backgroundColor = WJColorWhite;
                        cell.delegate = self;
                    }
                    
                    return cell;
                }
            }else{
                
                return nil;
            }
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    NSLog(@"%s",__func__);
    
    [wjsearchBar resignFirstResponder];

    if (indexPath.section == 1) {
        if (self.historyArray.count >0) {
            if (indexPath.row >0 && indexPath.row <= self.historyArray.count) {
                [self searchMerchant:[self.historyArray objectAtIndex:indexPath.row-1]];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001;
}

#pragma mark- Private Methods
// TODO:理论上来说，此处不应有私有方法存在，都应该在上面找到归类。这里应该放置拆分的中间方法。

- (void)editHistoryList:(NSString *)text
{
    WJModelPerson * persion = [WJGlobalVariable sharedInstance].defaultPerson;
    BOOL isLogin = NO;
    NSMutableArray * hisArray = nil;
    if (persion) {
        isLogin = YES;
        hisArray = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@history",persion.phone]];
    }else{
        isLogin = NO;
        hisArray = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"searchHistory"]];
    }
    
    if (hisArray.count > 0) {
        
        self.historyArray = [NSMutableArray arrayWithArray:hisArray];
        
        for (int i = 0; i< [hisArray count]; i++) {
            if ([[hisArray objectAtIndex:i] isEqualToString:text]) {
                
                [self.historyArray removeObject: [hisArray objectAtIndex:i]];
            }
        }
       
        [self.historyArray insertObject:text atIndex:0];

        //最多显示10条
        while ([self.historyArray count] > 10) {
            [self.historyArray removeLastObject];
        }
        
    }else{
     
        [self.historyArray addObject:text];
    }

    if(isLogin){
        
        [[NSUserDefaults standardUserDefaults] setObject:self.historyArray forKey:[NSString stringWithFormat:@"%@history",persion.phone]];
        
    }else{
        
        [[NSUserDefaults standardUserDefaults] setObject:self.historyArray forKey:[NSString stringWithFormat:@"searchHistory"]];
    }

  
}


- (void)UISetup
{
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:WJFont14];
    [cancelButton setFrame:CGRectMake(0, 0, ALD(40), ALD(30))];
    [cancelButton addTarget:self action:@selector(backToLast) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.rightBarButtonItem = cancelItem;
    
    wjsearchBar = [[UISearchBar alloc] init];
    wjsearchBar.delegate = self;
    wjsearchBar.barStyle = UIBarStyleDefault;
    wjsearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    wjsearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    wjsearchBar.placeholder = @"请输入店铺名称";
    wjsearchBar.keyboardType =  UIKeyboardTypeDefault;
    [wjsearchBar becomeFirstResponder];
    self.navigationItem.titleView = wjsearchBar;
}


- (void)backToLast
{
    [wjsearchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark- Getter and Setter

- (APIHotKeysManager *)hotKeysManager
{
    if (nil == _hotKeysManager) {
        _hotKeysManager = [[APIHotKeysManager alloc] init];
        _hotKeysManager.delegate = self;
        _hotKeysManager.keyCount = 9;
    }
    return _hotKeysManager;
}

- (NSArray *)hotKeysArray
{
    if (nil == _hotKeysArray ) {
        _hotKeysArray = [NSArray array];
    }
    return _hotKeysArray;
}

- (WJRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain refreshNow:NO refreshViewType:WJRefreshViewTypeNone];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.separatorColor = WJColorDarkGrayLine;
        _tableView.tableHeaderView = nil;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;

    }
    return _tableView;
}
    
- (NSMutableArray *)historyArray
{
    WJModelPerson * persion = [WJGlobalVariable sharedInstance].defaultPerson;
    if (nil == _historyArray) {
        _historyArray = [NSMutableArray array];

        if (nil == persion) {
             [_historyArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"searchHistory"]]];
        }else{
        
            [_historyArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@history",persion.phone]]];
        }
    }
    return _historyArray;
}

- (NSArray *)sectionTitleArray
{
    return @[@"热门搜索",@"历史搜索"];
}
    
// TODO:所有属性的初始化，都写在这
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
