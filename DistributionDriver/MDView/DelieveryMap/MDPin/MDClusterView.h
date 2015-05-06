//
//  MDClusterView.h
//  DistributionDriver
//
//  Created by Lsr on 5/4/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MDPin.h"

@interface MDClusterView : MKAnnotationView

-(void) setNumber:(NSInteger)number;
-(void) updatePinAnnotationByType:(MDPin *)pin;
-(void) updateClusterAnnotationByType:(MDPin *)pin;
-(void) showInfo:(MDPackage*)package;
-(void) hideInfo;

@end
