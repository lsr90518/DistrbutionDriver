//
//  MDUserLocationService.m
//  DistributionDriver
//
//  Created by Lsr on 5/24/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDUserLocationService.h"

@implementation MDUserLocationService

+(MDUserLocationService *)getInstance {
    
    static MDUserLocationService *sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[MDUserLocationService alloc] init];
    });
    return sharedInstance;
}

@end
