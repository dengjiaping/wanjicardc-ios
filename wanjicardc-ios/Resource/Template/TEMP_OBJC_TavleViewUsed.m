//
//  TEMP_OBJC_TavleViewUsed.m
//  LESports
//
//  Created by HuHarry on 15/6/15.
//  Copyright (c) 2015年 LETV. All rights reserved.
//

#import "TEMP_OBJC_TavleViewUsed.h"


@interface TEMP_OBJC_TavleViewUsed (){
    UITableViewCell *_baseCell;
}

@end

@implementation TEMP_OBJC_TavleViewUsed

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    if (IOS8_LATER) {
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        //cell高度相近的话使用此语句，否则使用- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath;
        self.tableView.estimatedRowHeight = 70.0;
        
    }else{
        
        _baseCell = [UITableViewCell new];
        
    }
}


#pragma mark - ios8 使用

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //每个cell高度不同的话，使用该方法来定制估算的高度；
    return (indexPath.row%3+1) * 40;
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IOS8_LATER) {
        return UITableViewAutomaticDimension;
    }
    
//    根据数据更新cell界面
//    [self configureCell:_baseCell atIndexPath:indexPath];
    [_baseCell layoutSubviews];
    
    CGFloat height = [_baseCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    return height + 1;//由于分割线，所以contentView的高度要小于row 一个像素。
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
//    根据数据更新cell界面
//    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
