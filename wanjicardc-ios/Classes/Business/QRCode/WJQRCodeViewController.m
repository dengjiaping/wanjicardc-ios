//
//  WJQRCodeViewController.m
//  WanJiCard
//
//  Created by Lynn on 15/9/6.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJQRCodeViewController.h"
#import "APIQRCodeManager.h"

@interface WJQRCodeViewController ()<APIManagerCallBackDelegate>

@property (nonatomic, strong) APIQRCodeManager * kQRCodeManager;

@end

@implementation WJQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getQRCodeRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- ClassMethods
// TODO:这里实现类方法。
#pragma mark- Initialization
#pragma mark- Life cycle
#pragma mark- Delegate
#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{ 
    NSLog(@"%s",__func__);
    NSLog(@"%@",manager);
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    NSLog(@"%s",__func__);
    NSLog(@"%@",manager);
}

#pragma mark- Event Response
// TODO:所有 button、gestureRecognizer、notification 的事件相应方法，与跳转到其他 controller 的出口方法都写在这里。
#pragma mark- Rotation
// TODO:转屏处理写在这。
#pragma mark- Private Methods
// TODO:理论上来说，此处不应有私有方法存在，都应该在上面找到归类。这里应该放置拆分的中间方法。

- (void)getQRCodeRequest
{
    [self.kQRCodeManager loadData];
}

#pragma mark- Getter and Setter
// TODO:所有属性的初始化，都写在这
- (APIQRCodeManager *)kQRCodeManager
{
    if (nil == _kQRCodeManager) {
        _kQRCodeManager = [[APIQRCodeManager alloc] init];
        _kQRCodeManager.delegate = self;
        
    }
    return _kQRCodeManager;
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
