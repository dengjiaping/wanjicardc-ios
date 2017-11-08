//
//  WJAdvertiseViewController.m
//  WanJiCard
//
//  Created by 孙明月 on 16/5/17.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJAdvertiseViewController.h"
#import "AppDelegate.h"
#import "APIAdvertiseManager.h"

@interface WJAdvertiseViewController ()<APIManagerCallBackDelegate>
{
    NSTimer  *activationDelayTimer;
    NSString *oldAdvertisePicUrl;
    UIButton *skipButton;
    
    int      delayTime;
}
@property(nonatomic, strong) APIAdvertiseManager *advertiseManager;
@property(nonatomic, strong) UIImageView         *activityView;

@end

@implementation WJAdvertiseViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delayTime = 3;

    [self.view addSubview:self.activityView];

//    skipButton= [UIButton buttonWithType:UIButtonTypeCustom];
//    skipButton.frame = CGRectMake(SCREEN_WIDTH - 100, 50, 70, 30);
//    skipButton.backgroundColor = [UIColor yellowColor];
//    [skipButton setTitle:@"跳过" forState:UIControlStateNormal];
//    [skipButton.titleLabel setFont:WJFont12];
//    [activityView addSubview:skipButton];
//    [skipButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [skipButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];

    activationDelayTimer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:activationDelayTimer forMode:NSRunLoopCommonModes];
    [activationDelayTimer fire];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APIAdvertiseManager class]]) {
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            NSString *advertisePicUrl = [dic objectForKey:@"picUrl"];
            
            if (![advertisePicUrl isEqual:oldAdvertisePicUrl]) {
                
                [self saveAdvertiseDic:advertisePicUrl];
            }
        }
    }
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    NSLog(@"fail:%@",manager);
}


- (void)request
{
    [self.advertiseManager loadData];
}

- (void)countdown
{
    delayTime--;
    
    if (delayTime) {
        [skipButton setTitle:[NSString stringWithFormat:@"跳过%d",delayTime] forState:UIControlStateNormal];
    }else{
        [self dismissView];
    }
}

- (void)dismissView
{
    delayTime = 0;
    [activationDelayTimer invalidate];
    [_activityView removeFromSuperview];
    [(AppDelegate *)[UIApplication sharedApplication].delegate changeRootViewController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - writeToLocalFile
- (NSString *)rootAdvertisePicUrlCachePath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path firstObject];
    filePath = [filePath stringByAppendingPathComponent:@"LocalAdvertise.txt"];
    return filePath;
}

- (void)saveAdvertiseDic:(NSString *)url
{
    NSData *downData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:downData forKey:@"advertiseImage"];
    [dic setValue:url forKey:@"advertiseUrl"];
    
    [dic writeToFile:[self rootAdvertisePicUrlCachePath] atomically:YES];
    
}

- (NSMutableDictionary *)advertiseImageDic
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:[self rootAdvertisePicUrlCachePath]];

    return dic;
}

#pragma mark - 属性方法
-(APIAdvertiseManager *)advertiseManager
{
    if (nil == _advertiseManager) {
        _advertiseManager = [[APIAdvertiseManager alloc] init];
        _advertiseManager.delegate = self;

    }
    
    if (iPhone6OrThan) {
        _advertiseManager.picSize = @"1242*2208";

    } else {
        _advertiseManager.picSize = @"750*1334";

    }
    return _advertiseManager;
}

- (UIImageView *)activityView
{
    if (nil == _activityView) {
        
        _activityView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.view.backgroundColor = [UIColor whiteColor];
        
        UIImage *oldAdvertiseImage=  [UIImage imageWithData:[[self advertiseImageDic] objectForKey:@"advertiseImage"]] ;
        oldAdvertisePicUrl = [[self advertiseImageDic] objectForKey:@"advertiseUrl"];

        if (nil == oldAdvertiseImage) {
            _activityView.image = [UIImage imageNamed:@"SplashScreenDefault"];

        } else {

            _activityView.image = oldAdvertiseImage;
        }
        
    }
    return _activityView;
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
