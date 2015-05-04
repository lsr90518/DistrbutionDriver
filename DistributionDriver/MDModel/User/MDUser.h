//
//  MDUser.h
//  Distribution
//
//  Created by Lsr on 4/12/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MDUser : NSObject

@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *creditNumber;
@property (strong, nonatomic) NSString *lastname;
@property (strong, nonatomic) NSString *firstname;
@property (strong, nonatomic) NSString *checknumber;
@property (strong, nonatomic) NSString *userHash;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSData   *imageData;
@property (strong, nonatomic) NSData   *idImageData;
@property (strong, nonatomic) NSString *deposit;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *car;
@property (strong, nonatomic) NSString *motorBike;
@property (strong, nonatomic) NSString *bike;
@property (strong, nonatomic) NSString *walk;
@property (strong, nonatomic) NSString *intro;

+(MDUser *)getInstance;

-(void) initDataClear;
-(void) setData:(NSDictionary *)data;

//{
//    "code": 0,
//    "data": {
//        "id": "19",
//        "phone": "+819081593894",
//        "name": "Masashi Kakami",
//        "mail": null,
//        "intro": "初めまして、各務と申します。一所懸命させて頂きますので、よろしくお願い致します。初めまして、各務と申します。よろしくお願い致します。",
//        "walk": "0",
//        "bike": "1",
//        "motorbike": "0",
//        "car": "1",
//        "image": "https://distribution-dev.s3-ap-northeast-1.amazonaws.com/driver/images/19",
//        "status": "0",
//        "deposit": "0",
//        "created": "2015-04-05 03:00:52"
//    },
//    "hash": "geeLSvlzByLmSSOtr7A+0A=="
//}

@end
