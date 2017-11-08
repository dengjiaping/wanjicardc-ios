//
//  WJViewController.m
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJViewController.h"


@interface WJViewController (){
    UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer;
}

@property (nonatomic, strong)UIPercentDrivenInteractiveTransition *percentDrivenTransition;

@end

@implementation WJViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addScreenEdgePanGesture];
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = WJColorViewBg;

    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 19, 19);
    [leftBtn setImage:[UIImage imageNamed:@"nav_btn_back_nor"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backBarButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

- (void)showLoadingView{

    [self.loadingView startAnimation];
}

- (void)hiddenLoadingView{

    [self.loadingView stopAnimationWithLoadText:@"" withType:YES];
}

- (void)requestLoad{
    [self showLoadingView];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[WJStatisticsManager sharedStatisManager] event:self.eventID];

}

// Called when the view is dismissed, covered or otherwise hidden. Default does nothing
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
}


#pragma mark - Logic Method

- (void)hiddenBackBarButtonItem{
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
}


#pragma mark - Button Action

- (void)backBarButton:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES]; 
}

- (void)addScreenEdgePanGesture{
    
    edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePanGesture:)];
    //设置从什么边界滑入
    edgePanGestureRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePanGestureRecognizer];
}


- (void)removeScreenEdgePanGesture{
    [self.view removeGestureRecognizer:edgePanGestureRecognizer];
}


- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)recognizer{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        
        CGFloat progress = [recognizer translationInView:self.view].x / self.view.bounds.size.width;
        progress = MIN(1.0, MAX(0.0, progress));//把这个百分比限制在0~1之间
        
        //当手势刚刚开始，我们创建一个 UIPercentDrivenInteractiveTransition 对象
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            self.percentDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
            [self.navigationController popViewControllerAnimated:YES];
        }else if (recognizer.state == UIGestureRecognizerStateChanged){
            //当手慢慢划入时，我们把总体手势划入的进度告诉 UIPercentDrivenInteractiveTransition 对象。
            [self.percentDrivenTransition updateInteractiveTransition:progress];
        }else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded){
            //当手势结束，我们根据用户的手势进度来判断过渡是应该完成还是取消并相应的调用 finishInteractiveTransition 或者 cancelInteractiveTransition 方法.
            if (progress > 0.5) {
                [self.percentDrivenTransition finishInteractiveTransition];
            }else{
                [self.percentDrivenTransition cancelInteractiveTransition];
            }
        }
    }
}


- (WJNavigationController *)navigationController{
    return (WJNavigationController *)super.navigationController;
}

- (void)dealloc{
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

- (WJLoadingView *)loadingView
{
    if (nil == _loadingView) {
        
//        _loadingView = [[WJLoadingView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-40, self.view.frame.size.height/2-40, 80, 80)];
//        [_loadingView setLoadText:@"正在加载..."];
       
        _loadingView = [[WJLoadingView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-30,(kScreenHeight -64)/2-40, 60, 80)];
        [self.view addSubview:_loadingView];
    }
    
    return _loadingView;

}
@end
