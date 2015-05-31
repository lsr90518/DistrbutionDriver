//
//  MDLocationManager.h
//  DistributionDriver
//
//  Created by Lsr on 5/30/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MDLocationManager : NSObject

@property (strong, nonatomic) CLLocationManager *locationManager;

+(MDLocationManager *)getInstance;

@end
