//
//  MDPackageService.h
//  DistributionDriver
//
//  Created by Lsr on 5/2/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDPackage.h"

@interface MDPackageService : NSObject

@property (strong, nonatomic) NSMutableArray *packageList;

+(MDPackageService *)getInstance;

-(void) initData;
-(void) initDataWithArray:(NSArray *)array;

@end
