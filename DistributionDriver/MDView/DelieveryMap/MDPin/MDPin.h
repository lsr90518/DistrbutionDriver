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
@property (nonatomic) CLLocationCoordinate2D coordinate;
//标注的标题
@property (nonatomic,copy) NSString    *title;
//标注的子标题
@property (nonatomic,copy) NSString    *subtitle;
@property (strong, nonatomic) MDPackage         *package;
@property (strong, nonatomic) NSString          *packageType;


@property (nonatomic, strong) MDPin *clusterAnnotation;
@property (nonatomic, strong) NSArray *containedAnnotations;



-(id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                   title:(NSString *)paramTitle
                subTitle:(NSString *)paramTitle
                    type:(NSString *)type;
- (void)updateSubtitleIfNeeded;

@end
