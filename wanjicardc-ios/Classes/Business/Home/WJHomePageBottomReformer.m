//
//  WJHomePageBottomReformer.m
//  WanJiCard
//
//  Created by XT Xiong on 16/6/2.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJHomePageBottomReformer.h"
#import "WJHomePageBottomModel.h"
#import "WJECardModel.h"

@implementation WJHomePageBottomReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * branchArray  = [NSMutableArray array];
    
//    if ([data isKindOfClass:[NSDictionary class]]) {
//        for (id obj in [data objectForKey:@"branch"]) {
//            if ([obj isKindOfClass:[NSDictionary class]]) {
//                
//                WJHomePageBottomModel * branch = [[WJHomePageBottomModel alloc] initWithDictionary:obj];
//                [branchArray addObject:branch];
//            }
//        }
    
    if ([data isKindOfClass:[NSArray class]]) {
        for (id obj in data) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                                
                WJECardModel *model = [[WJECardModel alloc] initWithDictionary:obj];
                [branchArray addObject:model];
                
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
        NSString *filePath = [path stringByAppendingPathComponent:@"homeBottomData.txt"];
        NSFileManager *fileManager = [[NSFileManager alloc]init];
        [fileManager createFileAtPath:filePath contents:fileData attributes:nil];
    }
    return branchArray;
}

@end
