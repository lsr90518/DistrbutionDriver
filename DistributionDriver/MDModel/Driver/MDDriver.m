//
//  MDDriver.m
//  Distribution
//
//  Created by Lsr on 5/9/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDDriver.h"
#import "MDReview.h"
#import "MDUtil.h"

@implementation MDDriver


-(void) initWithData:(NSDictionary*)data{
    _driver_id = data[@"id"];
    _name = data[@"name"];
    _intro = data[@"intro"];
    _delivered_package = data[@"delivered_package"];
    _average_star = data[@"average_star"];
    _phoneNumber = [[MDUtil getInstance] japanesePhoneNumber:data[@"phone"]];
    _image = data[@"image"];
    _reviews = [[NSMutableArray alloc]init];
    NSArray *reviewData = data[@"Reviews"];
    
    [reviewData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MDReview *review = [[MDReview alloc]init];
        [review initWithData:obj];
        [_reviews addObject:review];
    }];
}

-(void) initWithUser:(MDUser *)user{
    _driver_id = user.user_id;
    _name = [NSString stringWithFormat:@"%@ %@",user.lastname, user.firstname];
    _intro = user.intro;
    _phoneNumber = [[MDUtil getInstance]japanesePhoneNumber:user.phoneNumber];
    _image = user.image;
}

@end