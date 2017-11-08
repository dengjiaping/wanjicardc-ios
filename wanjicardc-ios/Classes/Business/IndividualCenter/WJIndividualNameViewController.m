//
//  WJIndividualNameViewController.m
//  WanJiCard
//
//  Created by wangzhangjie on 15/9/8.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJIndividualNameViewController.h"
#import "APIUserUpdateManager.h"
#import "WJIndividualNameReformer.h"
#import "WJIndividualNameModel.h"
#import "SecurityService.h"

@interface WJIndividualNameViewController () <UITextFieldDelegate,APIManagerCallBackDelegate>

@end

@implementation WJIndividualNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *saveButton=[UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame=CGRectMake(0, 0, 50, 40);
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton setTitle:@"存储" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveName) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    
    
    [self.view addSubview:self.nameField];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletapPressGesture)];
    [self.view  addGestureRecognizer:tapGesture];
     self.navigationItem.title=@"修改名称";
    // [self requestLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Request

- (void)requestLoad{
    [self showLoadingView];
    [self.updateManager loadData];
}
#pragma mark- CustomDelegate
// TODO:所有自定义协议的实现都写在这里。 mark 的协议名字要与 code 中的协议名字完全一样，方便查找。
#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    self.nameModel = [manager fetchDataWithReformer:[[WJIndividualNameReformer alloc] init]];
    
    [[TKAlertCenter defaultCenter]  postAlertWithMessage:@"更新成功！"];
    WJModelPerson *defaultPerson =[WJGlobalVariable sharedInstance].defaultPerson;
    defaultPerson.realName=self.nameField.text;
    [[WJDBPersonManager new] updatePerson:defaultPerson];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hasChangedNameNotification" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    [self hiddenLoadingView];
    [[TKAlertCenter defaultCenter]  postAlertWithMessage:@"更新失败了"];
}

#pragma mark- Event Response

-(void)handletapPressGesture {
    [_nameField resignFirstResponder];
}


-(void)saveName
{
    if (nil==self.nameField.text || [self.nameField.text isEqual:@""]) {
        ALERT(@"真实姓名不能为空");
    } else {
        WJModelPerson *defaultPerson =[WJGlobalVariable sharedInstance].defaultPerson;
         defaultPerson.realName=self.nameField.text;

         [[WJDBPersonManager new] updatePerson:defaultPerson];
        
        self.updateManager.name =self.nameField.text;

        self.updateManager.isMale = self.defaultperson.gender;

        //hzq 默认值，否则借口error
//        if (nil ==defaultPerson.country || [@"" isEqual:defaultPerson.country]) {
//            self.updateManager.country =@"中国";
//        }else{
//            self.updateManager.country = defaultPerson.country;
//        }
//        if (nil ==defaultPerson.province || [@"" isEqual:defaultPerson.province]) {
//            self.updateManager.province = @"北京";
//        }else
//        {
//            self.updateManager.province = defaultPerson.province;
//        }
//        if (nil ==defaultPerson.city || [@"" isEqual:defaultPerson.city]) {
//             self.updateManager.city = @"北京市";
//        }else
//        {
//             self.updateManager.city = defaultPerson.city;
//        }
//        if ([defaultPerson.birthdayYear intValue] ==0) {
//             self.updateManager.year = 1990;
//        }else
//        {
//           self.updateManager.year = [defaultPerson.birthdayYear intValue];
//        }
//       
//        if ([defaultPerson.birthdayMonth intValue] ==0) {
//            self.updateManager.month = 10;
//        }else
//        {
//             self.updateManager.month = [defaultPerson.birthdayMonth intValue];
//        }
//        if ([defaultPerson.birthdayDay intValue] ==0) {
//            self.updateManager.day = 10;
//        }else
//        {
//            self.updateManager.day = [defaultPerson.birthdayDay intValue];
//        }

        if (nil ==defaultPerson.country || [@"" isEqual:defaultPerson.country]) {
            
            if (nil == defaultPerson.province || [@"" isEqualToString:defaultPerson.province]) {
                
                if (nil == defaultPerson.city || [@"" isEqualToString:defaultPerson.city]) {
                    self.updateManager.address =@"中国,北京,北京市";
                    
                } else {
                    
                    self.updateManager.address = [NSString stringWithFormat:@"中国,北京,%@",defaultPerson.city];
                    
                }
                
            } else {
                
                if (nil == defaultPerson.city || [@"" isEqualToString:defaultPerson.city]) {
                    self.updateManager.address = [NSString stringWithFormat:@"中国,%@,北京市",defaultPerson.province];
                    
                    
                } else {
                    
                    self.updateManager.address = [NSString stringWithFormat:@"中国,%@,%@",defaultPerson.province,defaultPerson.city];
                    
                }
                
            }
            
        }  else{
            
            
            if (nil == defaultPerson.province || [@"" isEqualToString:defaultPerson.province]) {
                
                if (nil == defaultPerson.city || [@"" isEqualToString:defaultPerson.city]) {
                    self.updateManager.address = [NSString stringWithFormat:@"%@,北京,北京市",defaultPerson.country];
                    
                    
                } else {
                    
                    self.updateManager.address = [NSString stringWithFormat:@"%@,北京,%@",defaultPerson.country,defaultPerson.city];
                    
                }
                
            } else {
                
                if (nil == defaultPerson.city || [@"" isEqualToString:defaultPerson.city]) {
                    self.updateManager.address = [NSString stringWithFormat:@"%@,%@,北京市",defaultPerson.country,defaultPerson.province];
                    
                    
                } else {
                    
                    self.updateManager.address = [NSString stringWithFormat:@"%@,%@,%@",defaultPerson.country,defaultPerson.province,defaultPerson.city];
                    
                }
                
            }
            
        }
        
        
        
        if ([defaultPerson.birthdayYear intValue] == 0 ) {
            
            if ([defaultPerson.birthdayMonth intValue] == 0) {
                
                if ([defaultPerson.birthdayDay intValue] == 0) {
                    self.updateManager.userBirthday =@"1990,10,10";
                    
                } else {
                    
                    self.updateManager.userBirthday = [NSString stringWithFormat:@"1990,10,%@",defaultPerson.birthdayDay];
                    
                }
                
            } else {
                
                if ([defaultPerson.birthdayDay intValue] == 0) {
                    self.updateManager.userBirthday = [NSString stringWithFormat:@"1990,%@,10",defaultPerson.birthdayMonth];
                    
                    
                } else {
                    
                    self.updateManager.userBirthday = [NSString stringWithFormat:@"1990,%@,%@",defaultPerson.birthdayMonth,defaultPerson.birthdayMonth];
                }
                
            }
            
        }  else{
            
            
            if ([defaultPerson.birthdayMonth intValue] == 0) {
                
                if ([defaultPerson.birthdayDay intValue] == 0) {
                    self.updateManager.userBirthday = [NSString stringWithFormat:@"%@,10,10",defaultPerson.birthdayYear];
                    
                } else {
                    
                    self.updateManager.userBirthday = [NSString stringWithFormat:@"%@,10,%@",defaultPerson.birthdayYear,defaultPerson.birthdayDay];
                    
                }
                
            } else {
                
                if ([defaultPerson.birthdayDay intValue] == 0) {
                    self.updateManager.userBirthday = [NSString stringWithFormat:@"%@,%@,10",defaultPerson.birthdayYear,defaultPerson.birthdayMonth];
                    
                } else {
                    
                    self.updateManager.userBirthday = [NSString stringWithFormat:@"%@,%@,%@",defaultPerson.birthdayYear,defaultPerson.birthdayMonth,defaultPerson.birthdayDay];
                }
                
            }
            
        }
        
        self.updateManager.name = self.nameField.text;
        [self requestLoad];
        
        
        // xxx
       // [self.navigationController popToRootViewControllerAnimated:YES];
       // [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
}


#pragma mark- Private Methods
// TODO:理论上来说，此处不应有私有方法存在，都应该在上面找到归类。这里应该放置拆分的中间方法。

#pragma mark- Getter and Setter
// TODO:所有属性的初始化，都写在这。
-(UITextField *)nameField
{
    if(nil==_nameField)
    {
        _nameField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        _nameField.backgroundColor=[UIColor whiteColor];
        _nameField.placeholder=@"  请输入真实姓名";
        _nameField.secureTextEntry=NO;
        _nameField.delegate=self;
        
        _nameField.userInteractionEnabled = YES;
        _nameField.keyboardType = UIKeyboardTypeDefault;
        
    }
    return _nameField;
}


- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(WJIndividualNameModel *)nameModel
{
    if (nil==_nameModel) {
        _nameModel = [[WJIndividualNameModel alloc]init];
    }
    return _nameModel;
}
-(APIUserUpdateManager *)updateManager
{
    
    if (nil==_updateManager) {
        _updateManager = [[APIUserUpdateManager  alloc]init];
        _updateManager.delegate=self;
        
        
    }
    return _updateManager;
}
@end
