//
//  WJHomePageTopReformer.m
//  WanJiCard
//
//  Created by XT Xiong on 16/5/31.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJHomePageTopReformer.h"
#import "WJHomePageTopModel.h"
#import "WJHomePageCityActivityModel.h"
#import "WJHomePageCategoriesModel.h"
#import "WJMoreBrandesModel.h"
#import "WJHomePageActivitiesModel.h"

@implementation WJHomePageTopReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * activitiesArray    = [NSMutableArray array];
    NSMutableArray * brandsArray        = [NSMutableArray array];
    NSMutableArray * categoriesArray    = [NSMutableArray array];
    NSMutableArray * cityActivityArray  = [NSMutableArray array];
    
    if ([data isKindOfClass:[NSDictionary class]]) {

        for (id obj in [data objectForKey:@"activities"]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                WJHomePageActivitiesModel * activities = [[WJHomePageActivitiesModel alloc] initWithDictionary:obj];
                [activitiesArray addObject:activities];
            }
        }
        for (id obj in [data objectForKey:@"brands"]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                WJMoreBrandesModel * brands = [[WJMoreBrandesModel alloc] initWithDictionary:obj];
                [brandsArray addObject:brands];
            }
        }
        for (id obj in [data objectForKey:@"categories"]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                WJHomePageCategoriesModel * categories = [[WJHomePageCategoriesModel alloc] initWithDictionary:obj];
                [categoriesArray addObject:categories];
            }
        }
        for (id obj in [data objectForKey:@"cityActivity"]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                WJHomePageCityActivityModel * cityActivity = [[WJHomePageCityActivityModel alloc] initWithDictionary:obj];
                [cityActivityArray addObject:cityActivity];
            }
        }
        
        //数据
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSData *fileData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        //文件
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [path stringByAppendingPathComponent:@"homeTopData.txt"];
        NSFileManager *fileManager = [[NSFileManager alloc]init];
        [fileManager createFileAtPath:filePath contents:fileData attributes:nil];
        
    }
    
    NSMutableDictionary * resultDic  = [NSMutableDictionary dictionaryWithObjectsAndKeys:activitiesArray,@"activities",brandsArray,@"brands",categoriesArray,@"categories",cityActivityArray,@"cityActivity", nil];

    return resultDic;
}

@end
