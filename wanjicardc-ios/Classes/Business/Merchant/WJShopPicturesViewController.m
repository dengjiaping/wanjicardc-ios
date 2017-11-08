//
//  WJShopPicturesViewController.m
//  WanJiCard
//
//  Created by silinman on 16/6/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJShopPicturesViewController.h"
#import "WJMerchantDetailModel.h"


#define KDeviceWidth [UIScreen mainScreen].bounds.size.width//屏幕宽
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height//屏幕高
#define KCS_Width scrollView.contentSize.width
#define KCS_Height scrollView.contentSize.height
#define KS_Width scrollView.frame.size.width
#define KS_Height scrollView.frame.size.height
#define KImgNum self.detailModel.imageArray.count



@interface WJShopPicturesViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>


@property (nonatomic, assign) NSInteger currentNum;//记录当前页
@property (nonatomic, retain) UIScrollView *bigScrollView;//底部滑动视图
@property (nonatomic, assign) BOOL zoomTapClick;//记录双击缩放图片


@end

@implementation WJShopPicturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubviewAndUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)initSubviewAndUI{
    self.view.backgroundColor = WJColorBlack;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundColor:WJColorNavBarTranslucent];
    self.title = [NSString stringWithFormat:@"%d/%lu",self.currentImageIndex + 1,(unsigned long)KImgNum];
    self.zoomTapClick = NO;
    [self setupImageView];
}

#pragma mark -- 创建ScrollView 以及imageView
- (void)setupImageView {
    //创建底部滑动视图
    self.bigScrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _bigScrollView.delegate = self;//设置代理
    _bigScrollView.contentSize = CGSizeMake(KDeviceWidth * KImgNum,0);//滑动区域大小
    _bigScrollView.contentOffset = CGPointMake(KDeviceWidth * self.currentImageIndex, 0);//偏移量
    for (int i = 0; i < KImgNum; i++) {
        //创建缩放滑动视图
        UIScrollView *zoomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(KDeviceWidth * i , 0, KDeviceWidth, KDeviceHeight)];
        zoomScrollView.delegate = self;//代理
        zoomScrollView.minimumZoomScale = 0.3;//最小缩放比
        zoomScrollView.maximumZoomScale = 3.0;//最大缩放比
        zoomScrollView.zoomScale = 1.0;//默认值
        zoomScrollView.directionalLockEnabled = NO;//方向锁定关闭
        //创建imgView
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(KDeviceWidth * i, 0, KDeviceWidth, 235)];
        imageView.center = self.view.center;
        imageView.tag = 111 + i;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[self.detailModel.imageArray[i] imgUrl]] placeholderImage:[UIImage imageNamed:@"merchant_detail_default"]];
        imageView.userInteractionEnabled = YES;
        
        //添加双击缩放手势
        UITapGestureRecognizer *zoomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomTapAction:)];
        zoomTap.numberOfTapsRequired = 2;
        [imageView addGestureRecognizer:zoomTap];
        
        [zoomScrollView addSubview:imageView];
        [_bigScrollView addSubview:zoomScrollView];
    }
    _bigScrollView.pagingEnabled = YES;//按页滑动
    [self.view addSubview:_bigScrollView];
}

#pragma mark -- zoomTapAction
-(void)zoomTapAction:(UITapGestureRecognizer *)tap{
    UIScrollView *smallScrollView = (UIScrollView *)tap.view.superview;
    if (!_zoomTapClick) {
        [UIView animateWithDuration:0.3 animations:^{
            smallScrollView.zoomScale = 3.0;
            _zoomTapClick = YES;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            smallScrollView.zoomScale = 1.0;
            _zoomTapClick = NO;
        }];
    }
}
#pragma mark -- ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.bigScrollView]) {
        NSInteger currentPage = scrollView.contentOffset.x / KDeviceWidth;
        if (self.currentNum!=currentPage) {
            self.currentNum = currentPage;
            for (UIView *view in scrollView.subviews) {
                if ([view isKindOfClass:[UIScrollView class]]) {
                    UIScrollView *scrollView = (UIScrollView *)view;
                    scrollView.zoomScale = 1.0;
                }
            }
        }
        self.title = [NSString stringWithFormat:@"%ld/%lu",currentPage + 1,(unsigned long)KImgNum];
        _zoomTapClick = NO;
    }
}

//返回要缩放的视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    NSInteger currentIndex = _bigScrollView.contentOffset.x / KDeviceWidth;
    return [scrollView viewWithTag:111 + currentIndex];
}
//视图已经缩放
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSInteger currentIndex = _bigScrollView.contentOffset.x/KDeviceWidth;
    UIImageView *imageview = (UIImageView *) [scrollView viewWithTag:111 + currentIndex];
    //先提前获取中心点的x
    CGFloat distance_x = KS_Width > KCS_Width ? (KS_Width - KCS_Width) / 2 : 0;
    //y
    CGFloat distance_y = KS_Height > KCS_Height ? (KS_Height - KCS_Height) / 2 : 0;
    //最后一步 居中
    imageview.center = CGPointMake(KCS_Width / 2 + distance_x, KCS_Height / 2 + distance_y);
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
