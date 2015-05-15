//
//  MDBankInfo.m
//  DistributionDriver
//
//  Created by Lsr on 5/12/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDBankInfo.h"

@implementation MDBankInfo

-(void) initWithData:(MDBankInfo *)bankInfo{
    _bank_number = (bankInfo.bank_number.length > 0) ? bankInfo.bank_number : @"";
    _branch_number = (bankInfo.branch_number.length > 0) ? bankInfo.branch_number : @"";
    _type = (bankInfo.type.length > 0) ? bankInfo.type : @"";
    _account_number = (bankInfo.account_number.length > 0) ? bankInfo.account_number : @"";
    _name = (bankInfo.name.length > 0) ? bankInfo.name : @"";
}

-(void) setType:(NSString *)type{
    if([type isEqualToString:@"普通"]){
        _type = @"1";
    } else if([type isEqualToString:@"当座"]){
        _type = @"2";
    } else if([type isEqualToString:@"貯蓄"]){
        _type = @"4";
    } else {
        _type = @"0";
    }
}

@end

//bank_number

//branch_number

//type

//account_number

//name