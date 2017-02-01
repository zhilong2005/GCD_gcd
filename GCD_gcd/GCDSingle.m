//
//  GCDSingle.m
//  GCD_gcd
//
//  Created by zhuzhilong on 17/2/1.
//  Copyright © 2017年 zhuzhilong. All rights reserved.
//

#import "GCDSingle.h"

@implementation GCDSingle
+(instancetype)instance{
    static dispatch_once_t onceToken;
    static GCDSingle *single = nil;

    dispatch_once(&onceToken, ^{
        NSLog(@"init the GCDSingle");
        single  = [[GCDSingle alloc]init];
    });
    return single;
}
@end
