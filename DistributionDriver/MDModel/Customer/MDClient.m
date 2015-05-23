//
//  MDCustomer.m
//  DistributionDriver
//
//  Created by Lsr on 5/10/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDClient.h"
#import "MDReview.h"
#import "MDUtil.h"

@implementation MDClient

-(void) initWithData:(NSDictionary*)data{
    _user_id = data[@"id"];
    _name = data[@"name"];
    _delivered_package = data[@"delivered_package"];
    _average_star = data[@"average_star"];
    _phone = [MDUtil japanesePhoneNumber:data[@"phone"]];
    _reviews = [[NSMutableArray alloc]init];
    NSArray *reviewData = data[@"Reviews"];
    
    [reviewData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MDReview *review = [[MDReview alloc]init];
        [review initWithData:obj];
        [_reviews addObject:review];
    }];
}

@end
