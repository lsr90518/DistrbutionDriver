//
//  MDPinCallout.h
//  DistributionDriver
//
//  Created by Lsr on 5/2/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDPin.h"
#import "MDPackage.h"

@interface MDPinCallout : MKAnnotationView

@property (strong, nonatomic) UIView *tmpCalloutView;

@property (strong, nonatomic) MDPackage *package;

- (CGRect)infoWindowFrame;

@end
