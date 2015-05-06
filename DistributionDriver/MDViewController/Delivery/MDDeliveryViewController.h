//
//  MDDeliveryViewController.h
//  Distribution
//
//  Created by Lsr on 3/27/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDDeliveryView.h"
#import "MDPreparePayViewController.h"
#import "MDAPI.h"
#import <MKNetworkKit.h>
#import <MKNetworkEngine.h>
#import <MKNetworkOperation.h>
#import "MDCurrentPackage.h"
#import "MDInputDestinationViewController.h"
#import "MDInputRequestViewController.h"
#import "MDSizeInputViewController.h"
#import "MDNoteViewController.h"
#import "MDRequestAmountViewController.h"
#import "MDRecieveTimeViewController.h"
#import "MDExpireViewController.h"
#import "MDDeliveryLimitViewController.h"
#import "MDDeliveryMapView.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MDPinCallout.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface MDDeliveryViewController : UIViewController <MKMapViewDelegate,MKAnnotation,MKOverlay,CLLocationManagerDelegate>

@property (strong, nonatomic) MDDeliveryMapView *deliveryView;
@property (strong, nonatomic) MDPinCallout *currentAnnotationView;
@property (strong, nonatomic) UIView        *tabbar;

//地图
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) MKMapView *fromAnnotationsMapView;
@property (strong, nonatomic) MKMapView *toAnnotationsMapView;
//自己经度
@property (strong, nonatomic) NSString *longitude;
//自己纬度
@property (strong, nonatomic) NSString *latitude;

@property(nonatomic, retain) CLLocationManager *locationManager;

@end
