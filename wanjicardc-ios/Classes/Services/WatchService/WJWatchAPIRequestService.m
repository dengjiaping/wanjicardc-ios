//
//  WJWatchAPIRequestService.m
//  WanJiCard
//
//  Created by Angie on 15/12/24.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJWatchAPIRequestService.h"
#import "APISearchManager.h"
#import "LocationManager.h"
#import "APICardPackageManager.h"

// #import "APIProductsListManager.h"

#import "APIMerchantDetailManager.h"

@interface WJWatchAPIRequestService ()<APIManagerCallBackDelegate>

@property (nonatomic, strong) APISearchManager *searchManager;

// @property (nonatomic,strong) APIProductsListManager * productManager;
@property (nonatomic,strong) APIMerchantDetailManager * merchantDetailManager;
@property (nonatomic,strong) APICardPackageManager * cardManager;
@end
//
@implementation WJWatchAPIRequestService

static WJWatchAPIRequestService * s = nil;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s = [[WJWatchAPIRequestService alloc] init];
    });
    return s;
}


- (void)getDataWithCategory:(NSString *)category longtitude:(double)longti latitude: (double)lati cityId:(NSString*) cityid{
    
    NSInteger categoryId = 0;
    if ([category isEqualToString:@"food"]) {
        categoryId = 1;
    }else if ([category isEqualToString:@"beauty"]) {
        categoryId = 10;
    }else if ([category isEqualToString:@"life"]) {
        categoryId = 4;
    }else{
        
    }
    self.searchManager = [APISearchManager new];
    self.searchManager.delegate = self;
    self.searchManager.shouldCleanData = 1;
    self.searchManager.categoryid = NumberToString(categoryId);
    self.searchManager.areaId = cityid;
    
    self.searchManager.pageCount = 10;
    self.searchManager.firstPageNo = 1;
    self.searchManager.latitude = lati;//[LocationManager sharedInstance].appLocation.latitude;
    self.searchManager.longitude = longti;//[LocationManager sharedInstance].appLocation.longitude;
    // self.searchManager.sort = @"distance";
    
   // self.searchManager.shouldParse = 0;
    [self.searchManager loadData];
    
}


- (void)getDataWithMerchantId:(NSString *)merchantId{

    self.merchantDetailManager = [APIMerchantDetailManager new];
    self.merchantDetailManager.delegate = self;
    
    self.merchantDetailManager.shouldCleanData = YES;
    self.merchantDetailManager.merID = merchantId;
    self.merchantDetailManager.merchantLongitude = @"0";
    self.merchantDetailManager.merchantLatitude  = @"0";
    [self.merchantDetailManager loadData];
}

- (void)getDataWithComplication:(NSString *)token{
    self.cardManager = [APICardPackageManager new];
    
    self.cardManager.delegate = self;
    //与这个无关系total
    self.cardManager.pageCount = 20;
    self.cardManager.firstPageNo = 1;
    
    [self.cardManager loadData];
}

#pragma mark - APIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager{
    if ([manager isKindOfClass:[APISearchManager class]]) {
        NSInteger code = manager.errorCode;
        NSString *errorMessage = manager.errorMessage;

        if (code == 0) {
            NSDictionary *dataDic = @{@"val"           : [manager fetchDataWithReformer:nil],
                                      @"responseCode"           : NumberToString(code),
                                      @"responseErrorMessage"   : errorMessage,
                                      @"Url"                    : @""};// url

                     
        NSData *data = [NSJSONSerialization dataWithJSONObject:dataDic options:kNilOptions error:nil];
            NSDictionary * tmp = [NSDictionary dictionaryWithObject:data forKey:@"code"];
            self.replyHandle(tmp);
        }
//        else{
//            // code!=0的情况
//        }
    }else if ([manager isKindOfClass:[APIMerchantDetailManager class]]){
        // 橱窗
        NSInteger code = manager.errorCode;
        NSString *errorMessage = manager.errorMessage;
       // NSString *url = manager.requestUrlString;
        if (code == 0) {
            NSDictionary *dataDic = @{@"val"           : [manager fetchDataWithReformer:nil],
                                      @"responseCode"           : NumberToString(code),
                                      @"responseErrorMessage"   : errorMessage,
                                      @"Url"                    : @""};
            
           
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:dataDic options:kNilOptions error:nil];
            NSDictionary * tmp = [NSDictionary dictionaryWithObject:data forKey:@"code"];
            
            self.replyHandle(tmp);
        }
//        else{
//            // code!=0的情况
//        }

        
    }else if ([manager isKindOfClass:[APICardPackageManager class]]) {
        NSInteger code = manager.errorCode;
        NSString *errorMessage = manager.errorMessage;
       // NSString *url = manager.requestUrlString;
        if (code == 0) {
            NSDictionary *dataDic = @{@"val"           : [manager fetchDataWithReformer:nil],
                                      @"responseCode"           : NumberToString(code),
                                      @"responseErrorMessage"   : errorMessage,
                                      @"Url"                    : @""};
            
            
            //NSData *data = [NSJSONSerialization dataWithJSONObject:dataDic options:kNilOptions error:nil];
           
            NSDictionary * tmp = [NSDictionary dictionaryWithObject:dataDic forKey:@"code"];
            self.replyHandle(tmp);
        }else{
             NSDictionary * tmp = [NSDictionary dictionaryWithObject:@"error" forKey:@"code"];
            self.replyHandle(tmp);
        }

    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager{
    //ALERT(@"请求失败");
    //构造一个字典，方便watch统一解析显示，数值为0
    if ([manager isKindOfClass:[APICardPackageManager class]]) {
        //NSDictionary * tmpdata = @{@"code" : @{@"val":@{@"total" : @"0"}}};
        NSDictionary * tmp = [NSDictionary dictionaryWithObject:@"0" forKey:@"code"];
        //dispatch_async(dispatch_get_main_queue(), ^{
            self.replyHandle(tmp);
        //});
        
    }

}

@end
