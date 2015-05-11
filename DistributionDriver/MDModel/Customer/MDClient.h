//
//  MDCustomer.h
//  DistributionDriver
//
//  Created by Lsr on 5/10/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDClient : NSObject

@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *delivered_package;
@property (strong, nonatomic) NSString *average_star;
@property (strong, nonatomic) NSMutableArray *reviews;

-(void) initWithData:(NSDictionary*)data;

@end


//"User": {
//    "id": "44",
//    "name": "liu songran",
//    "phone": "+819028280392",
//    "delivered_package": 11,
//    "average_star": 3.5,
//    "Reviews": [
//                {
//                    "driver_id": "24",
//                    "driver_name": "Masashi KakamiD",
//                    "star": "4",
//                    "text": "testes"
//                },
//                {
//                    "driver_id": "25",
//                    "driver_name": "リュウ ショウゼン",
//                    "star": "0",
//                    "text": "あむ"
//                },
//                {
//                    "driver_id": "25",
//                    "driver_name": "リュウ ショウゼン",
//                    "star": "5",
//                    "text": "にこ"
//                },
//                {
//                    "driver_id": "25",
//                    "driver_name": "リュウ ショウゼン",
//                    "star": "5",
//                    "text": "いい人だった！"
//                }
//                ]
//}