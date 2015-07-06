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

-(void) initUserLocation{
    //set user to tokyo
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(MKCoordinateForMapPoint(MKMapPointMake(35.66919, 139.7413805)), 4000, 4000);
    _currentUserRegion = region;
    
}

@end
