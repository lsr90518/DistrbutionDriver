//
//  MDBankInfo.h
//  DistributionDriver
//
//  Created by Lsr on 5/12/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDBankInfo : NSObject

@property (strong, nonatomic) NSString *bank_number;
@property (strong, nonatomic) NSString *branch_number;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *account_number;
@property (strong, nonatomic) NSString *name;


-(NSString *)getType;

-(void) initWithData:(MDBankInfo *)bankInfo;

@end
