//
//  ModelArea.m
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJModelArea.h"

@implementation WJModelArea

-(id)init{
    if (self = [super init]) {
        self.areaId=0;
        self.parentid=0;
        self.orderName=@"";
        self.level=0;
        self.name=@"";
        self.ishot=0;
        self.lat=0.0;
        self.lng=0.0;
        self.zoom=0;
    }
    return self;
}

-(id)initWithDic:(NSDictionary*)dic{
    if (self = [super init]) {
        self.areaId =   ToString([dic objectForKey:@"cityId"]);
        self.name =     [dic objectForKey:@"name"]?:@"";
        self.oname =    [dic objectForKey:@"cityAbbreviation"]?:@"";
        self.level =    [[dic objectForKey:@"level"] integerValue];
        self.parentid = ToString([dic objectForKey:@"parentId"]);
        self.isUse =    [[dic objectForKey:@"available"] integerValue];
        self.ishot =    [[dic objectForKey:@"isPopular"] integerValue];
        
        self.orderName = [dic objectForKey:@"ordername"]?:@"";
        self.lat =      [[dic objectForKey:@"lat"] doubleValue];
        self.lng =      [[dic objectForKey:@"lng"] doubleValue];
        self.zoom =     [[dic objectForKey:@"zoom"] integerValue];
        self.region =   [[dic objectForKey:@"region"] integerValue];

    }
    return self;
}
-(id)initWithCursor:(FMResultSet *)cursor{
    if (self = [super init]) {
        
        self.areaId =   [cursor stringForColumn:COL_AREA_ID];
        self.name =     [cursor stringForColumn:@"Name"];
        self.oname =    [cursor stringForColumn:@"Oname"];
        self.orderName = [cursor stringForColumn:@"OrderName"];
        self.level =    [cursor intForColumn:@"Level"];
        self.parentid = [cursor stringForColumn:@"Parentid"];
        self.ishot =    [cursor intForColumn:@"Ishot"];
        self.lat =      [cursor doubleForColumn:@"Lat"];
        self.lng =      [cursor doubleForColumn:@"Lng"];
        self.zoom =     [cursor intForColumn:@"Zoom"];
        self.region =   [cursor intForColumn:@"Region"];
        self.isUse =    [cursor intForColumn:@"IsUse"];
    
        
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"(areaid = %@ name = %@ oname = %@ level = %ld parentid = %@  isuse = %ld )",
            self.areaId,
            self.name,
            self.oname,
            (long)self.level,
            self.parentid,
            (long)self.isUse
            ];
}



@end
