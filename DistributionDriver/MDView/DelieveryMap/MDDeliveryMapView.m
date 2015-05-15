//
//  MDDeliveryMapView.m
//  DistributionDriver
//
//  Created by Lsr on 5/2/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDDeliveryMapView.h"
#import "MDPackageService.h"
#import "MDPin.h"

@implementation MDDeliveryMapView


-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if ( self ){
        //add code
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _mapView = [[MKMapView alloc]initWithFrame:frame];
        [self configMap];
        [self addSubview:_mapView];
        
        
        
    }
    return self;
}

-(void) configMap{
    _mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    
    [self.locationManager startUpdatingLocation];
    
    _mapView.showsUserLocation = YES;
    [_mapView setMapType:MKMapTypeStandard];
    [_mapView setZoomEnabled:YES];
    [_mapView setScrollEnabled:YES];
    [_mapView setUserTrackingMode:MKUserTrackingModeNone];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    //View Area
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span.longitudeDelta = 0.005f;
    region.span.longitudeDelta = 0.005f;
    [self.mapView setRegion:region animated:YES];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"run");
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}
- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceLat {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
}
- (NSString *)deviceLon {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceAlt {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.altitude];
}


#pragma mkannotation


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if ([annotation isKindOfClass:[MDPin class]]) {
        static NSString* travellerAnnotationIdentifier = @"TravellerAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [_mapView dequeueReusableAnnotationViewWithIdentifier:travellerAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKAnnotationView* customPinView = [[MKAnnotationView alloc]
                                                initWithAnnotation:annotation reuseIdentifier:travellerAnnotationIdentifier];
            UIImage *image = [UIImage imageNamed:@"pinOn"];
            customPinView.image = image;  //
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

@end
