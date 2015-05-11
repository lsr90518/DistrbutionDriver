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

@interface MDMyPackageService : NSObject

@property (strong, nonatomic) NSMutableArray *packageList;
@property (strong, nonatomic) NSMutableArray *reviewList;

+(MDMyPackageService *)getInstance;

-(void) initDataWithArray:(NSArray *)array;
-(int) getAverageStar;

@end
