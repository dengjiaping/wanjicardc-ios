//
//  NSString+SHA.h
//  WanJiCard
//
//  Created by Angie on 15/11/4.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SHA)

- (NSString *)getHmac_sha1WithKey:(NSString *)key;

- (NSString *)getSha1String;

- (NSString *)getSha256String;

- (NSString *)getSha384String;

- (NSString *)getSha512String;

@end
