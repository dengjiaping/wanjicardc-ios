//
//  WJSettingViewController.m
//  HuPlus
//
//  Created by reborn on 17/1/5.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJSettingViewController.h"
#import "WJSystemAlertView.h"

@interface WJSettingViewController ()<UITableViewDelegate,UITableViewDataSource,WJSystemAlertViewDelegate>
{
    UIButton *logoutButton;
}
@property(nonatomic,strong)UITableView     *tableView;

@end

@implementation WJSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self UISetup];
    // Do any additional setup after loading the view.
}

-(void)UISetup
{
    [self.view addSubview:self.tableView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(100))];
    bgView.backgroundColor = WJColorViewBg;
    [self.view addSubview:bgView];

    logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.frame = CGRectMake(ALD(20), ALD(20), kScreenWidth - ALD(40), ALD(40));
    [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    logoutButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [logoutButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    logoutButton.backgroundColor = WJColorNavigationBar;
    logoutButton.layer.cornerRadius = 4;
    logoutButton.layer.masksToBounds = YES;
    logoutButton.titleLabel.font = WJFont14;
    [bgView addSubview:logoutButton];
    
    WJModelPerson * person = [WJGlobalVariable sharedInstance].defaultPerson;
    if (person) {
        logoutButton.hidden = NO;

    } else {
        logoutButton.hidden = YES;
    }
    
    [logoutButton addTarget:self action:@selector(logoutButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = bgView;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return ALD(44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), 0, ALD(100), ALD(44))];
        titleL.font = WJFont13;
        titleL.tag = 3000;
        titleL.textColor = WJColorBlack;
        [cell.contentView addSubview:titleL];
        
        UIImage *arrawImage = [UIImage imageNamed:@"icon_arrow_right"];
        UIImageView *rightArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - arrawImage.size.width, (ALD(44) - arrawImage.size.height)/2, arrawImage.size.width, arrawImage.size.height)];
        rightArrowImageView.image = [UIImage imageNamed:@"icon_arrow_right"];
        [cell.contentView addSubview:rightArrowImageView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), ALD(44) - 1, kScreenWidth - ALD(24), 1)];
        lineView.backgroundColor = WJColorSeparatorLine;
        [cell.contentView addSubview:lineView];
        
    }
    
    UILabel *titleL = (UILabel *)[cell.contentView viewWithTag:3000];
    if (indexPath.row == 0) {
        titleL.text = @"清除缓存";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        
        NSString * cacheSize = [NSString stringWithFormat:@"你的缓存大小为:%.2fMB,确定清除？",[self filePath] ];

        WJSystemAlertView *alertView = [[WJSystemAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"提示\n%@",cacheSize] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" textAlignment:NSTextAlignmentCenter];
        [alertView showIn];
        
        
    }
}

#pragma mark - WJSystemAlertViewDelegate
-(void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        [self clearFile];
    }
}

#pragma mark - Action
-(void)logoutButtonAction
{
    
    WJModelPerson * person = [WJGlobalVariable sharedInstance].defaultPerson;
    if (person) {
        [person logout];
    }
    ALERT(@"成功退出");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IndividualCenterRefresh" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - caculateFileSize
-(unsigned long long)fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }
    
    return 0;
}

//遍历文件夹获得文件夹大小
-(float)folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    
    return folderSize/(1024.0*1024.0);
}


//显示缓存大小
-(float)filePath
{
    NSString * cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    return [self folderSizeAtPath:cachPath];
    
}

//清理缓存
-(void)clearFile
{
    NSString * cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSArray * files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    
    NSLog(@"cachpath = %@", cachPath);
    
    for (NSString * p in files) {
        
        NSError * error = nil;
        
        NSString * path = [cachPath stringByAppendingPathComponent:p];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            
        }
    }
    
    [self clearCachSuccess];
}


-(void)clearCachSuccess
{
    NSLog(@"清理成功");
    WJSystemAlertView *alertView = [[WJSystemAlertView alloc] initWithTitle:nil message:@"提示\n缓存清理完毕" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil textAlignment:NSTextAlignmentCenter];
    [alertView showIn];
    
}

#pragma mark - setter&getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        
    }
    return _tableView;
}


@end
