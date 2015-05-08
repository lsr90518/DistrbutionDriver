//
//  MDAPI.h
//  Distribution
//
//  Created by Lsr on 4/8/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MKNetworkKit.h>
#import "MDUser.h"

#define API_DRIVERS_CREATE          @"drivers/create"
#define API_DRIVERS_CHECKNUMBER     @"drivers/check_number"
#define API_DRIVERS_NEWPROFILE      @"drivers/new_profile"
#define API_DRIVERS_LOGIN           @"drivers/login"
#define API_USERS_LOGIN             @"users/login"
#define API_USER_UPDATE_PHONE       @"users/request_phone_number_change"
#define API_GET_WAITING_PACKAGE     @"packages/driver/get_waiting_packages"

#define API_PACKAGE_RESIGER         @"packages/user/register"
#define API_PACKAGE_IMAGE           @"packages/user/upload_image"
#define API_GET_MY_PACKAGE          @"packages/driver/get_my_packages"
#define API_PACKAGE_ACCEPT          @"packages/driver/accept"
#define API_PACKAGE_RECEIVE         @"packages/driver/receive"
#define API_PACKAGE_DELIVERY        @"packages/driver/complete"

#define USER_DEVICE                 @"ios"


#define API_HOST_NAME @"modelordistribution-dev.elasticbeanstalk.com"

@interface MDAPI : NSObject

+(MDAPI *)sharedAPI;

-(void) createUserWithPhone:(NSString *)phone
                 onComplete:(void (^)(MKNetworkOperation *))complete
                    onError:(void (^)(MKNetworkOperation *, NSError *))error;

-(void) checkUserWithPhone:(NSString *)phone
                  withCode:(NSString *)code
                onComplete:(void (^)(MKNetworkOperation *))complete
                   onError:(void (^)(MKNetworkOperation *, NSError *))error;

-(void) newProfileByUser:(MDUser *)user
              onComplete:(void (^)(MKNetworkOperation *))complete
                 onError:(void (^)(MKNetworkOperation *, NSError *))error;

-(void) loginWithPhone:(NSString *)phoneNumber
              password:(NSString *)password
              onComplete:(void (^)(MKNetworkOperation *))complete
                 onError:(void (^)(MKNetworkOperation *, NSError *))error;

-(void) registerBaggageWithHash:(NSString *)hash
                     OnComplete:(void (^)(MKNetworkOperation *))complete
                          onError:(void (^)(MKNetworkOperation *, NSError *))error;

-(void) uploadImageWithHash:(NSString *)hash
                  packageId:(NSString *)package_id
                      image:(UIImage *)image
                 OnComplete:(void (^)(MKNetworkOperation *))complete
                    onError:(void (^)(MKNetworkOperation *, NSError *))error;
-(void) updatePhoneNumberWithOldPhoneNumber:(NSString *)oldPhoneNumber
                             newPhoneNumber:(NSString *)newPhoneNumber
                              OnComplete:(void (^)(MKNetworkOperation *))complete
                                 onError:(void (^)(MKNetworkOperation *, NSError *))error;

-(void) getMyPackageWithHash:(NSString *)hash
                  OnComplete:(void (^)(MKNetworkOperation *))complete
                     onError:(void (^)(MKNetworkOperation *, NSError *))error;

-(void) getWaitingPackageWithHash:(NSString *)hash
                       OnComplete:(void (^)(MKNetworkOperation *))complete
                          onError:(void (^)(MKNetworkOperation *, NSError *))error;

-(void) getWaitingPackageWithHash:(NSString *)hash
                         WithPref:(NSString *)pref
                       OnComplete:(void (^)(MKNetworkOperation *))complete
                          onError:(void (^)(MKNetworkOperation *, NSError *))error;

-(void) acceptPackageWithHash:(NSString *)hash
                    packageId:(NSString *)package_id
                   OnComplete:(void (^)(MKNetworkOperation *))complete
                      onError:(void (^)(MKNetworkOperation *, NSError *))error;

-(void) receviePackageWithHash:(NSString *)hash
                     packageId:(NSString *)package_id
                    OnComplete:(void (^)(MKNetworkOperation *))complete
                       onError:(void (^)(MKNetworkOperation *, NSError *))error;

-(void) deliveryPackageWithHash:(NSString *)hash
                      packageId:(NSString *)package_id
                     OnComplete:(void (^)(MKNetworkOperation *))complete
                        onError:(void (^)(MKNetworkOperation *, NSError *))error;

@end
