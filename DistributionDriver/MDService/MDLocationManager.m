//
//  MDLocationManager.m
//  DistributionDriver
//
//  Created by Lsr on 5/30/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDLocationManager.h"

@implementation MDLocationManager

+(MDLocationManager *)getInstance {
    
    static MDLocationManager *sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[MDLocationManager alloc] init];
    });
    return sharedInstance;
}

@end
