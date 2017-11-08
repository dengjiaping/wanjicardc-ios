//
//  WJMyBillViewController.m
//  WanJiCard
//
//  Created by reborn on 16/11/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJMyBillViewController.h"
#import "WJAllBillViewController.h"
#import "WJWaitingBillViewController.h"
#import "WJEndBillViewController.h"
#import "WJFinishBillViewController.h"
#import "UINavigationBar+Awesome.h"
#import "WJBillTypeView.h"

@interface WJMyBillViewController ()<UIScrollViewDelegate, APIManagerCallBackDelegate,WJBillTypeViewDelegate>
{
    UIScrollView                *baseScroll;
    WJAllBillViewController     *allBillVC;
    WJWaitingBillViewController *waitingBillVC;
    WJEndBillViewController     *endBillVC;
    WJFinishBillViewController  *finishBillVC;
    
    UIView        *rightView;
    UILabel       *billLabel;
    UIImageView   *chooseOrderImageView;
    BOOL          isBillTypeViewShow;

}
@property(nonatomic, strong)WJBillTypeView *billTypeView;

@end

@implementation WJMyBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isBillTypeViewShow = NO;
    
    [self navigationSetup];
    
    baseScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenHeight - 115))];
    baseScroll.pagingEnabled = YES;
    baseScroll.bounces = NO;
    baseScroll.scrollsToTop = NO;
    baseScroll.delegate = self;
    baseScroll.showsHorizontalScrollIndicator = NO;
    baseScroll.scrollEnabled = NO;
    [self.view addSubview:baseScroll];
    
    allBillVC = [[WJAllBillViewController alloc] init];
    allBillVC.view.frame = CGRectMake(0, 0, kScreenWidth, baseScroll.height);
    [self addChildViewController:allBillVC];
    [allBillVC didMoveToParentViewController:self];
    [baseScroll addSubview:allBillVC.view];
    
    waitingBillVC = [[WJWaitingBillViewController alloc] init];
    waitingBillVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, baseScroll.height);
    [self addChildViewController:waitingBillVC];
    [waitingBillVC didMoveToParentViewController:self];
    [baseScroll addSubview:waitingBillVC.view];
    
//    endBillVC = [[WJEndBillViewController alloc] init];
//    endBillVC.view.frame = CGRectMake(2*kScreenWidth, 0, kScreenWidth, baseScroll.height);
//    
//    [self addChildViewController:endBillVC];
//    [endBillVC didMoveToParentViewController:self];
//    [baseScroll addSubview:endBillVC.view];
    
    finishBillVC = [[WJFinishBillViewController alloc] init];
    finishBillVC.view.frame = CGRectMake(2*kScreenWidth, 0, kScreenWidth, baseScroll.height);
    [self addChildViewController:finishBillVC];
    [finishBillVC didMoveToParentViewController:self];
    [baseScroll addSubview:finishBillVC.view];
    
    baseScroll.contentSize = CGSizeMake(3*kScreenWidth, baseScroll.height);

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (void)navigationSetup
{
    self.view.backgroundColor = WJColorViewBg2;
    [self.navigationController.navigationBar lt_setBackgroundColor:[WJColorNavigationBar colorWithAlphaComponent:0]];
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 160)/2, 0, 160, ALD(25))];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseBillAction)];
    [rightView addGestureRecognizer:tap];
    
    billLabel                   = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, ALD(25))];
    billLabel.font              = WJFont18;
    billLabel.textAlignment     = NSTextAlignmentCenter;
    billLabel.textColor         = WJColorWhite;
    billLabel.text              = @"账单";
    CGFloat addWith = [UILabel getWidthWithTitle:billLabel.text font:WJFont18];
    billLabel.frame = CGRectMake(0, 0, addWith, ALD(25));
    rightView.frame = CGRectMake((kScreenWidth - ALD(13) - addWith)/2, 0, addWith, ALD(25));
    
    chooseOrderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_btn_location_nor"] highlightedImage:[UIImage imageNamed:@"Home_btn_location_pressed"]];
    chooseOrderImageView.frame = CGRectMake(billLabel.right + ALD(5), billLabel.y + ALD(9), ALD(8), ALD(8));
    
    [rightView addSubview:billLabel];
    [rightView addSubview:chooseOrderImageView];
    
    self.navigationItem.titleView = rightView;
    
}

#pragma mark - WJBillTypeViewDelegate
- (void)billTypeViewUpdateBill:(NSInteger)index section:(NSInteger)section
{
    if(isBillTypeViewShow){
        isBillTypeViewShow = NO;
        chooseOrderImageView.highlighted = NO;
        self.billTypeView.hidden = YES;
        
        rightView.frame =  CGRectMake((kScreenWidth - 160)/2, 0, 160, ALD(25));
        billLabel.frame = CGRectMake(0, 0, 300, ALD(25));
        
//        NSArray *array1 = [NSArray arrayWithObjects:@"全部账单",@"待支付账单",@"已关闭账单",@"已完成账单",nil];
        NSArray *array1 = [NSArray arrayWithObjects:@"全部账单",@"待支付账单",@"已完成账单",nil];

        
        switch (section) {
            case 0:
            {
                billLabel.text = [array1 objectAtIndex:index];
                
                if (index == 0) {
                    
                    [allBillVC.mTb startHeadRefresh];
                    
                } else if (index == 1) {
                    
                    [waitingBillVC.mTb startHeadRefresh];

                    
                }
//                else if (index == 2) {
//                    
//                    [endBillVC.mTb startHeadRefresh];
//                    
//                }
                else {
                    
                    [finishBillVC.mTb startHeadRefresh];
                }
                
                [self updateTopBillType:index];
                
            }
                break;
                
            default:
                break;
        }
        
    }
    
}

- (void)hideBackBillTypeView:(WJBillTypeView *)billTypeView
{
    [self chooseBillAction];
}

- (void)updateTopBillType:(NSInteger)index
{
    self.navigationItem.titleView = rightView;
    CGFloat addWith = [UILabel getWidthWithTitle:billLabel.text font:WJFont18];
    rightView.frame = CGRectMake((kScreenWidth - ALD(13) - addWith)/2, 0, addWith, ALD(25));
    billLabel.frame = CGRectMake(0, 0, addWith, ALD(25));
    chooseOrderImageView.frame = CGRectMake(billLabel.right + ALD(5), billLabel.y + ALD(9), ALD(8), ALD(8));
    
    [UIView animateWithDuration:0.3 animations:^{
        baseScroll.contentOffset = CGPointMake(kScreenWidth*index, 0);
    }];
}

#pragma mark - Action

- (void)chooseBillAction
{
    if (![self.view viewWithTag:4000]) {
        
        [self.view addSubview:self.billTypeView];
    }
    
    chooseOrderImageView.highlighted = !chooseOrderImageView.highlighted;
    
    isBillTypeViewShow = !isBillTypeViewShow;
    if (isBillTypeViewShow) {
        self.billTypeView.hidden = NO;
    } else {
        self.billTypeView.hidden = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (WJBillTypeView  *)billTypeView
{
    if (nil == _billTypeView) {
        
        _billTypeView= [[WJBillTypeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _billTypeView.delegate = self;
        _billTypeView.tag = 4000;
    }
    return _billTypeView;
}

@end
