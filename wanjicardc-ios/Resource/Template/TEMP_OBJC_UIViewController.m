//
//  TEMP_OBJC_UIViewController.m
//  MySports
//
//  Created by zOne on 23/5/15.
//  Copyright (c) 2015 zOne. All rights reserved.
//

#import "TEMP_OBJC_UIViewController.h"


/* 延展(extension) */
/* 
 延展又叫匿名类目(category)，用来定义私有成员变量(private member)和私有成员方法(private method)。
 每个类只能有一个延展。
 延展中定义的私有方法必须实现，否则编译报错。
 */
@interface TEMP_OBJC_UIViewController()
{
    /* 
     使用花括号对成员变量包括，提高代码可读性。
     TODO:私有成员变量写在这里。
     例如周岁成员变量是不暴露给外部类使用的。
     在私有成员变量添加下划线，是苹果编程的风格。
     */
    
    // unsigned int _fullYearOld;
}

/* TODO:私有方法定义写在这里。 */

//- (void)privateMethod;
@end


@implementation TEMP_OBJC_UIViewController

#pragma mark- ClassMethods
// TODO:这里实现类方法。

#pragma mark- Initialization
- (instancetype)init
{
    if(self = [super init])
    {
        // TODO:这里对所有私有成员变量赋值。
        // _fullYearOld = 0;
        
        // TODO:这里注册非改变UI类的通知。
        // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:@"test" object:nil];
        
    }
    
    return self;
}

#pragma mark- Life cycle
// This is where subclasses should create their custom view hierarchy if they aren't using a nib. Should never be called directly.
- (void)loadView
{
    
}


// Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TODO:这里只做 addSubview 操作。
    
//    self.view.backgroundColor = [UIColor whiteColor];
//    
//    [self.view addSubview:self.firstTableView];
//    [self.view addSubview:self.secondTableView];
//    [self.view addSubview:self.firstFilterLabel];
//    [self.view addSubview:self.secondFilterLabel];
//    [self.view addSubview:self.cleanButton];
//    [self.view addSubview:self.originImageView];
//    [self.view addSubview:self.processedImageView];
//    [self.view addSubview:self.activityIndicator];
//    [self.view addSubview:self.takeImageButton];
    
    
    [self layoutPageSubviews];
}


- (void)layoutPageSubviews
{
    // TODO:在这里添加约束(Constraints)
    
//    [self.view addConstraints:xxxConstraints];
//    [self.view addConstraints:yyyConstraints];
//    [self.view addConstraints:zzzConstraints];
}


// Called when the view is about to made visible. Default does nothing
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /* 
     TODO:这里用来更新表单数据，但不做 UI 位置的修改。
     TODO:改变UI类的通知加这里。
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:@"test" object:nil];
     */
}


// Called when the view has been fully transitioned onto the screen. Default does nothing
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // TODO:
}


// Called when the view is dismissed, covered or otherwise hidden. Default does nothing
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // TODO:改变UI类的通知在这里移除。
    // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"test" object:nil];
}


// Called after the view was dismissed, covered or otherwise hidden. Default does nothing
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // TODO:
}


// Called just before the view controller's view's layoutSubviews method is invoked. Subclasses can implement as necessary. The default is a nop.
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // TODO:在这里更新 UI 的位置。
}


// Called just after the view controller's view's layoutSubviews method is invoked. Subclasses can implement as necessary. The default is a nop.
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // TODO:UI 位置确定后，在这里设置 autolayout。
}


// Called when the parent application receives a memory warning. On iOS 6.0 it will no longer clear the view by default.
- (void)didReceiveMemoryWarning
{
    // TODO:内存警告时，要处理的逻辑代码写在这里。
}


- (void)dealloc
{
    // TODO:这里移除非改变UI类的通知。
    // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"test" object:nil];

//    [super dealloc];
}


#pragma mark- UITableViewDelegate & UITableViewDataSource
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark- CustomDelegate
// TODO:所有自定义协议的实现都写在这里。 mark 的协议名字要与 code 中的协议名字完全一样，方便查找。

#pragma mark- Event Response
// TODO:所有 button、gestureRecognizer、notification 的事件相应方法，与跳转到其他 controller 的出口方法都写在这里。

#pragma mark- Rotation
// TODO:转屏处理写在这。

// 是否允许自动转屏
- (BOOL)shouldAutorotate
{
    return NO;   // 不允许自动转屏。（即不做转屏相应，或则自定义转屏操作）
    return YES;  // 允许自动转屏。（即让系统自适应转屏操作）
}


// 支持哪些方向的旋转
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationLandscapeLeft;
}


- (void)didRotated:(id)sender
{
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    
    CGAffineTransform transform = CGAffineTransformMakeRotation([self archForOrientation:orientation]);
    
    self.view.transform = transform;
    
    // subView 的中心点与 view 中心点对齐
//    self.subView.center = self.view.center;
    
    // 这里，后面的两个参数，是旋转后，subView UI的宽，高跟初始化时候的比例，会根据这个比例，来重新拉伸UI来呈现
//    self.subView.transform = CGAffineTransformScale(transform, 1.0, 1.0);
}


// 获取旋转角度
- (CGFloat)archForOrientation:(UIInterfaceOrientation)orientation
{
    CGFloat result = 0.0f;
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
        {
            result = 0.0f;
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
            result = M_PI_2;
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        {
            result = -M_PI_2;
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            result = 0.0f;
        }
            break;
        default:
            break;
    }
    
    
    return result;
}

#pragma mark- Private Methods
// TODO:理论上来说，此处不应有私有方法存在，都应该在上面找到归类。这里应该放置拆分的中间方法。

#pragma mark- Getter and Setter
// TODO:所有属性的初始化，都写在这。


- (UILabel *)label
{
    // IF 语句里做变量的初始化。
    if(nil == _label)
    {
        _label = [[UILabel alloc] init];
        _label.text = @"1234";
    }
    
    return _label;
}


- (UIButton *)button
{
    if(nil == _button)
    {
        _button = [[UIButton alloc] init];
        _button.frame = CGRectMake(0, 0, 100, 100);
    }
    
    return _button;
}
@end
