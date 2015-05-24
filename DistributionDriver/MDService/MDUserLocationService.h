//
//  MDUserLocationService.h
//  DistributionDriver
//
//  Created by Lsr on 5/24/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MDUserLocationService : NSObject

@property (nonatomic) MKCoordinateRegion currentUserRegion;
@property (strong, nonatomic) MKUserLocation *userLocation;

+(MDUserLocationService *)getInstance;

@end
