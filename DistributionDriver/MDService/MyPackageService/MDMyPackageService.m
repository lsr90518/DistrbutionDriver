//
//  MDMyPackageService.m
//  DistributionDriver
//
//  Created by Lsr on 5/10/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDMyPackageService.h"

@implementation MDMyPackageService

static MDMyPackageService *sharedInstance;

+(MDMyPackageService *)getInstance {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[MDMyPackageService alloc] init];
    });
    return sharedInstance;
}

-(void) initDataWithArray:(NSArray *)array{
    if(_packageList == nil){
        _packageList = [[NSMutableArray alloc]init];
        _reviewList  = [[NSMutableArray alloc]init];
    } else {
        [_packageList removeAllObjects];
        [_reviewList removeAllObjects];
    }
    
    for (int i = 0;i < array.count;i++) {
        MDPackage *tmpPackage = [[MDPackage alloc]initWithData:[array objectAtIndex:i]];
        [_packageList addObject:tmpPackage];
        
        NSString *star = [NSString stringWithFormat:@"%@", tmpPackage.userReview.star];
        if(![star isEqualToString:@"<null>"]){
            NSLog(@"%@", tmpPackage.userReview.star);
            [_reviewList addObject:tmpPackage.userReview];
        }
    }
}

-(int)getAverageStar{
    __block int allStar = 0;
    int average = 5;
    
    if([_reviewList count] > 0){
        [_reviewList enumerateObjectsUsingBlock:^(MDReview *obj, NSUInteger idx, BOOL *stop) {
            allStar = allStar + [obj.star intValue];
        }];
        
        average = (int)(allStar / [_reviewList count]);
        
        return average;
    } else {
        return 0;
    }
}

@end
