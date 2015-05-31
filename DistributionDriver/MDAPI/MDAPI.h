//
//  MDAPI.h
//  Distribution
//
//  Created by Lsr on 4/8/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MKNetworkKit.h>
#import "MDBankInfo.h"
#import "MDUser.h"

#define API_DRIVERS_CREATE          @"drivers/create"
#define API_DRIVERS_CHECKNUMBER     @"drivers/check_number"
#define API_DRIVERS_NEWPROFILE      @"drivers/new_profile"
#define API_DRIVERS_LOGIN           @"drivers/login"
#define API_DRIVERS_REVIREW         @"drivers/post_review"
#define API_DRIVERS_UPDATE_PROFILE  @"drivers/update_profile"
#define API_USERS_LOGIN             @"users/login"
#define API_DRIVERS_UPDATE_PHONE       @"drivers/request_phone_number_change"
#define API_GET_WAITING_PACKAGE     @"packages/driver/get_waiting_packages"
#define API_DRIVERS_GET_USER_DATA   @"drivers/get_user_data"
#define API_GET_NOTIFICATION        @"drivers/get_notifications"

#define API_GET_PACKAGE_DATA        @"packages/get_package_data"
#define API_PACKAGE_RESIGER         @"packages/user/register"
#define API_PACKAGE_IMAGE           @"packages/user/upload_image"
#define API_GET_MY_PACKAGE          @"packages/driver/get_my_packages"
#define API_PACKAGE_ACCEPT          @"packages/driver/accept"
#define API_PACKAGE_RECEIVE         @"packages/driver/receive"
#define API_PACKAGE_DELIVERY        @"packages/driver/complete"
#define API_CANCEL_PACKAGE          @"packages/driver/cancel"

#define API_SET_BANK_ACCOUNT        @"drivers/set_bank_account"
#define API_REQUEST_WITHDRAW_DEPOSIT @"drivers/request_withdraw_deposit"

#define API_USER_GET_DRIVER_DATA    @"users/get_driver_data"

#define USER_DEVICE                 @"ios"


#define API_HOST_NAME               @"modelordistribution-dev.elasticbeanstalk.com"
#define API_HOST_HELP               @"http://trux.life/help/"
#define API_HOST_FAQ                @"http://trux.life/help/faq.html"
#define API_HOST_PRIVACY            @"http://trux.life/help/privacypolicy.html"
#define API_HOST_TERMOFUSE          @"http://trux.life/help/term_of_use.html"





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


-(void) changeProfileByUser:(MDUser *)user
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

-(void) postReviewWithHash:(NSString *)hash
                 packageId:(NSString *)package_id
                      star:(NSString *)star
                      text:(NSString *)text
                OnComplete:(void (^)(MKNetworkOperation *))complete
                   onError:(void (^)(MKNetworkOperation *, NSError *))error;

-(void) getUserDataWithHash:(NSString *)hash
                     userId:(NSString *)user_id
                 OnComplete:(void (^)(MKNetworkOperation *))complete
                    onError:(void (^)(MKNetworkOperation *, NSError *))error;

-(void) getPackageByPakcageId:(NSString *)package_id
                   OnComplete:(void (^)(MKNetworkOperation *))complete
                      onError:(void (^)(MKNetworkOperation *, NSError *))error;

-(void) getDriverDataWithHash:(NSString *)hash
                     driverId:(NSString *)driver_id
                   OnComplete:(void (^)(MKNetworkOperation *))complete
                      onError:(void (^)(MKNetworkOperation *, NSError *))error;

-(void) setBankAccountWithHash:(NSString *)hash
                      bankInfo:(MDBankInfo *)bankInfo
                    OnComplete:(void (^)(MKNetworkOperation *))complete
                       onError:(void (^)(MKNetworkOperation *, NSError *))error;

-(void) requestWithDrawDepositWithHash:(NSString *)hash
                                amount:(NSString *)amount
                            OnComplete:(void (^)(MKNetworkOperation *))complete
                               onError:(void (^)(MKNetworkOperation *, NSError *))error;

-(void) getAllNotificationWithHash:(NSString *)hash
                        OnComplete:(void (^)(MKNetworkOperation *))complete
                           onError:(void (^)(MKNetworkOperation *, NSError *))error;

-(void) getNotificationWithHash:(NSString *)hash
                         lastId:(NSString *)lastId
                     OnComplete:(void (^)(MKNetworkOperation *))complete
                        onError:(void (^)(MKNetworkOperation *, NSError *))error;

-(void) cancelMyPackageWithHash:(NSString *)hash
                      packageId:(NSString *)packageId
                     OnComplete:(void (^)(MKNetworkOperation *))complete
                        onError:(void (^)(MKNetworkOperation *, NSError *))error;

@end
