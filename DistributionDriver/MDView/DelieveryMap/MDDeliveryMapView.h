//
//  MDDeliveryMapView.h
//  DistributionDriver
//
//  Created by Lsr on 5/2/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface MDDeliveryMapView : UIView<MKMapViewDelegate,MKAnnotation,MKOverlay,CLLocationManagerDelegate>

//地图
@property (strong, nonatomic) MKMapView *mapView;
//自己经度
@property (strong, nonatomic) NSString *longitude;
//自己纬度
@property (strong, nonatomic) NSString *latitude;

@property(nonatomic, retain) CLLocationManager *locationManager;

@end
