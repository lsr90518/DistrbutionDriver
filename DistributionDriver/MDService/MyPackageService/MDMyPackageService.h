//
//  MDMyPackageService.h
//  DistributionDriver
//
//  Created by Lsr on 5/10/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDPackage.h"
#import "MDReview.h"
#import "MDClient.h"
#import "MDCurrentPackage.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MDMyPackageService : NSObject

@property (strong, nonatomic) NSMutableArray *packageList;
@property (strong, nonatomic) NSMutableArray *completePackageList;
@property (strong, nonatomic) NSMutableArray *reviewList;

+(MDMyPackageService *)getInstance;

-(void) initData;
-(void) initDataWithArray:(NSArray *)array;
-(void) initDataWithArray:(NSArray *)array SortByDate:(BOOL)sort;
-(void) initDataWithArray:(NSArray *)array
             WithDistance:(CLLocation *)location;
-(NSMutableArray *)getPackageListByPackage:(MDCurrentPackage *)package;
-(int) getAverageStar;

-(MDPackage *) getPackageByPackageId:(NSString *)packageId;

@end
