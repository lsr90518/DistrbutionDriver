//
//  MDRealmBankInfo.h
//  DistributionDriver
//
//  Created by Lsr on 5/24/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLMObject.h"
#import <Realm.h>

@class MDRealmBankInfo;

@interface MDRealmBankInfo : RLMObject

@property NSString *bank_number;
@property NSString *branch_number;
@property NSString *type;
@property NSString *account_number;
@property NSString *name;


@end

RLM_ARRAY_TYPE(MDRealmBankInfo)