//
//  Loin.m
//  GCD_gcd
//
//  Created by sumpay on 2017/7/17.
//  Copyright © 2017年 zhuzhilong. All rights reserved.
//

#import "Loin.h"

@implementation Loin
+(instancetype)instance{
    static dispatch_once_t onceToken;
    static Loin *single = nil;
    
    dispatch_once(&onceToken, ^{
        NSLog(@"init the GCDSingle");
        single  = [[Loin alloc]init];
    });
    return single;
}

@end
