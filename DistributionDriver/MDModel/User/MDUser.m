//
//  MDUser.m
//  Distribution
//
//  Created by Lsr on 4/12/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDUser.h"

@implementation MDUser

+(MDUser *)getInstance {
    
    static MDUser *sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[MDUser alloc] init];
    });
    return sharedInstance;
}

-(void) initDataClear {
    if(_phoneNumber.length < 1){
       _phoneNumber = @"";
    }
    if(_password.length < 1){
        _password = @"";
    }
    if(_creditNumber.length < 1){
        _creditNumber = @"";
    }
    if(_lastname.length < 1){
        _lastname = @"";
    }
    if(_firstname.length < 1){
        _firstname = @"";
    }
    if(_checknumber.length < 1){
        _checknumber = @"";
    }
    if(_walk.length < 1){
        _walk = @"";
    }
    if(_bike.length < 1){
        _bike = @"";
    }
    if(_motorBike.length < 1){
        _motorBike = @"";
    }
    if(_car.length < 1){
        _car = @"";
    }
    if(_intro.length < 1){
        _intro = @"";
    }
}

-(void) setData:(NSDictionary *)data{
    _phoneNumber = data[@"phone"];
    NSString *fullname = data[@"name"];
    _lastname = [fullname componentsSeparatedByString:@" "][0];
    _firstname = [fullname componentsSeparatedByString:@" "][1];
    _intro = data[@"intro"];
    _walk = data[@"walk"];
    _bike = data[@"bike"];
    _motorBike = data[@"motorbike"];
    _car = data[@"car"];
    _image = data[@"image"];
    _status = data[@"status"];
    _deposit = data[@"deposit"];
}

@end
