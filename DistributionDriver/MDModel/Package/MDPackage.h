//
//  MDPackage.h
//  Distribution
//
//  Created by Lsr on 4/13/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDReview.h"
#import "MDClient.h"

@interface MDPackage : NSObject

@property (strong, nonatomic) NSString *package_id;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *from_pref;
@property (strong, nonatomic) NSString *from_addr;
@property (strong, nonatomic) NSString *from_lat;
@property (strong, nonatomic) NSString *from_lng;
@property (strong, nonatomic) NSString *from_zip;
@property (strong, nonatomic) NSString *to_pref;
@property (strong, nonatomic) NSString *to_addr;
@property (strong, nonatomic) NSString *to_lat;
@property (strong, nonatomic) NSString *to_lng;
@property (strong, nonatomic) NSString *to_zip;
@property (strong, nonatomic) NSString *size;
@property (strong, nonatomic) NSString *request_amount;
@property (strong, nonatomic) NSString *deliver_limit;
@property (strong, nonatomic) NSString *expire;
@property (strong, nonatomic) NSString *note;
@property (strong, nonatomic) NSMutableArray *at_home_time; //預かり時刻
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *status;             //0:初期, 1:編集中, 2:発送した
@property (strong, nonatomic) NSString *driver_id;
@property (strong, nonatomic) NSString *package_number;
@property (strong, nonatomic) MDReview *driverReview;
@property (strong, nonatomic) MDReview *userReview;
@property (strong, nonatomic) NSString *review_limit;
@property (strong, nonatomic) NSString *requestType;
@property (strong, nonatomic) NSString *order;
@property (strong, nonatomic) NSString *reward_amount;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSString *created_time;

-(MDPackage *)initWithData:(NSDictionary *)data;

-(NSComparisonResult) compareByDate: (MDPackage *)otherData;
@end
