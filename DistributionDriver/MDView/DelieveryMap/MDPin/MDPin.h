//
//  MDPin.h
//  DistributionDriver
//
//  Created by Lsr on 5/2/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MDPackage.h"

@interface MDPin : NSObject <MKAnnotation>
//显示标注的经纬度
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
//标注的标题
@property (nonatomic,copy,readonly) NSString    *title;
//标注的子标题
@property (nonatomic,copy,readonly) NSString    *subtitle;
@property (strong, nonatomic) MDPackage         *package;
@property (strong, nonatomic) NSString          *packageType;

-(id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                   title:(NSString *)paramTitle
                subTitle:(NSString *)paramTitle
                    type:(NSString *)type;

@end
