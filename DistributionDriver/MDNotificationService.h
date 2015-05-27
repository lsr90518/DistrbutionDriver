//
//  MDNotificationService.h
//  Distribution
//
//  Created by Lsr on 5/17/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDNotifacation.h"

@interface MDNotificationService : NSObject

@property (nonatomic) NSMutableArray *notificationList;
@property (nonatomic) NSMutableArray *oldNotificationList;

+(MDNotificationService *)getInstance;

-(void) initWithDataArray:(NSArray *)dataArray;

@end
