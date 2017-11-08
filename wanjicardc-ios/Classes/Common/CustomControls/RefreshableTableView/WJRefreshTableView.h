//
//  WJRefreshTableView.h
//  LESport
//
//  Created by Harry Hu on 15/3/18.
//  Copyright (c) 2015年 LETV. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WJRefreshViewType){
    WJRefreshViewTypeNone,
    WJRefreshViewTypeHeader,
    WJRefreshViewTypeFooter,
    WJRefreshViewTypeBoth
};

typedef NS_ENUM(NSInteger, WJRefreshViewStatus) {
    WJRefreshViewStatusIdle = 1, // 普通闲置状态
    WJRefreshViewStatusPulling,    //松手（下拉中才有）
    WJRefreshViewStatusRefreshing, // 正在刷新中的状态
    WJRefreshStateWillRefresh,      //即将刷新的状态
    WJRefreshViewStatusNoMoreData // 所有数据加载完毕，没有更多的数据了（上拉加载更多）
};



@interface WJRefreshTableView : UITableView

@property (nonatomic, assign) BOOL automaticallyRefresh;        //默认yes, 上拉自动加载


- (id)initWithFrame:(CGRect)frame
              style:(UITableViewStyle)style
         refreshNow:(BOOL)isRefresh
    refreshViewType:(WJRefreshViewType)type;

- (void)setRefreshingImages:(NSArray *)images
                  withState:(WJRefreshViewStatus)viewState
                   position:(WJRefreshViewType)position;

- (void)startHeadRefresh;
- (void)endHeadRefresh;
- (void)startFootRefresh;
- (void)endFootFefresh;

- (void)hiddenHeader;
- (void)showHeader;

- (void)hiddenFooter;
- (void)showFooter;

- (void)setView:(WJRefreshViewType)type
           text:(NSString *)text
         status:(WJRefreshViewStatus)status;

@end



@protocol WJRefreshTableViewDelegate <NSObject>

@optional
- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView;
- (void)startFootRefreshToDo:(WJRefreshTableView *)tableView;

@end
