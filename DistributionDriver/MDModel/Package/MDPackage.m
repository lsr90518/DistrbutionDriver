//
//  MDPackage.m
//  Distribution
//
//  Created by Lsr on 4/13/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDPackage.h"

@implementation MDPackage

-(MDPackage *)initWithData:(NSDictionary *)data{
    _note = data[@"note"];
    _order = data[@"note"];
    _package_number = data[@"package_number"];
    _package_id = data[@"id"];
    _at_home_time = data[@"at_home_time"];
    _deliver_limit = data[@"deliver_limit"];
    _driver_id = data[@"driver_id"];
    _expire = data[@"expire"];
    _from_addr = data[@"from_addr"];
    _from_lat = data[@"from_lat"];
    _from_lng = data[@"from_lng"];
    _from_pref = data[@"from_pref"];
    _from_zip = data[@"from_zip"];
    _image = data[@"image"];
    _review = data[@"review"];
    _review_limit = data[@"review_limit"];
    _request_amount = data[@"request_amount"];
    _reward_amount = data[@"reward_amount"];
    _size = data[@"size"];
    _status = data[@"status"];
    _to_addr = data[@"to_addr"];
    _to_lat = data[@"to_lat"];
    _to_lng = data[@"to_lng"];
    _to_pref = data[@"to_pref"];
    _to_zip = data[@"to_zip"];
    _requestType = data[@"type"];
    _user_id = data[@"user_id"];

    return self;
}

@end
