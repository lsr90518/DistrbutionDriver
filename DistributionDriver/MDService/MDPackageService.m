//
//  MDPackageService.m
//  DistributionDriver
//
//  Created by Lsr on 5/2/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDPackageService.h"

@implementation MDPackageService

+(MDPackageService *)getInstance {
    
    static MDPackageService *sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[MDPackageService alloc] init];
    });
    return sharedInstance;
}

-(void) initData{
    if(_packageList == nil){
        _packageList = [[NSMutableArray alloc]init];
    }
}

-(void) initDataWithArray:(NSArray *)array{
    if(_packageList == nil){
        _packageList = [[NSMutableArray alloc]init];
    } else {
        [_packageList removeAllObjects];
    }
    
    for (int i = 0;i < array.count;i++) {
        NSString *image = [array objectAtIndex:i][@"image"];
        if(![image isEqual:[NSNull null]]){
            MDPackage *tmpPackage = [[MDPackage alloc]initWithData:[array objectAtIndex:i]];
            [_packageList addObject:tmpPackage];
        }
    }
}

@end
