//
//  MDAPI.m
//  Distribution
//
//  Created by Lsr on 4/8/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDAPI.h"
#import "MDUser.h"
#import "MDCurrentPackage.h"
#import "MDDevice.h"

@implementation MDAPI {
    MKNetworkEngine *_engine;
}

#pragma mark - Init
+ (MDAPI *)sharedAPI
{
    static MDAPI *sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[MDAPI alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initApi];
    }
    return self;
}

- (void)initApi
{
    _engine = [[MKNetworkEngine alloc] initWithHostName:API_HOST_NAME];
}

#pragma mark - Self Methods
- (void)callApi:(NSDictionary *)params
        withUrl:(NSString *)url
     withImages:(NSArray *)images
 withHttpMethod:(NSString *)method
     onComplete:(void (^)(MKNetworkOperation *completeOperation))response
        onError:(void (^)(MKNetworkOperation *completeOperarion, NSError *error))error
{
    MKNetworkOperation *op     = [_engine operationWithPath:url
                                                     params:params
                                                 httpMethod:method
                                                        ssl:YES];
    
    [images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSData *imageData;
                if (UIImagePNGRepresentation(obj) == nil)
                {
                    imageData = UIImageJPEGRepresentation(obj, 0.3);
                }
                else
                {
                    imageData = UIImagePNGRepresentation(obj);
                }
        [op addData:imageData forKey:@"image"];
    }];
    
    [op addCompletionHandler:response errorHandler:error];
    [_engine enqueueOperation:op];
}



#pragma methods
-(void) createUserWithPhone:(NSString *)phone
                 onComplete:(void (^)(MKNetworkOperation *))complete
                    onError:(void (^)(MKNetworkOperation *, NSError *))error {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:phone forKey:@"phone"];
    
    [self callApi:dic
          withUrl:API_DRIVERS_CREATE
       withImages:@[]
   withHttpMethod:@"POST"
       onComplete:complete
          onError:error];
}

-(void) checkUserWithPhone:(NSString *)phone
                  withCode:(NSString *)code
                onComplete:(void (^)(MKNetworkOperation *))complete
                   onError:(void (^)(MKNetworkOperation *, NSError *))error{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:phone forKey:@"phone"];
    [dic setValue:code forKey:@"check_number"];
    
    
    [self callApi:dic
          withUrl:API_DRIVERS_CHECKNUMBER
       withImages:@[]
   withHttpMethod:@"GET"
       onComplete:complete
          onError:error];
}

-(void) newProfileByUser:(MDUser *)user
              onComplete:(void (^)(MKNetworkOperation *))complete
                 onError:(void (^)(MKNetworkOperation *, NSError *))error{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:user.phoneNumber  forKey:@"phone"];
    [dic setValue:user.checknumber  forKey:@"check_number"];
    [dic setValue:[NSString stringWithFormat:@"%@ %@",user.lastname,user.firstname] forKey:@"name"];
    [dic setValue:user.password     forKey:@"password"];
    [dic setValue:user.walk         forKey:@"walk"];
    [dic setValue:user.bike         forKey:@"bike"];
    [dic setValue:user.motorBike    forKey:@"motorbike"];
    [dic setValue:user.car          forKey:@"car"];
    [dic setValue:@""               forKeyPath:@"intro"];
    [dic setValue:@"ios"            forKey:@"client"];
    [dic setValue:[MDDevice getInstance].token forKey:@"device_token"];

    MKNetworkOperation *op     = [_engine operationWithPath:API_DRIVERS_NEWPROFILE
                                                     params:dic
                                                 httpMethod:@"POST"
                                                        ssl:YES];
    
    [op addData:user.imageData forKey:@"image"];
    [op addData:user.idImageData forKey:@"id_image"];
    
    [op addCompletionHandler:complete errorHandler:error];
    [_engine enqueueOperation:op];
}

-(void) changeProfileByUser:(MDUser *)user
                 onComplete:(void (^)(MKNetworkOperation *))complete
                    onError:(void (^)(MKNetworkOperation *, NSError *))error{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:user.phoneNumber  forKey:@"phone"];
    [dic setValue:[NSString stringWithFormat:@"%@ %@",user.lastname,user.firstname] forKey:@"name"];
    [dic setValue:user.walk         forKey:@"walk"];
    [dic setValue:user.bike         forKey:@"bike"];
    [dic setValue:user.motorBike    forKey:@"motorbike"];
    [dic setValue:user.car          forKey:@"car"];
    [dic setValue:user.intro        forKeyPath:@"intro"];
    [dic setValue:user.userHash     forKey:@"hash"];
    [dic setValue:@"ios"            forKey:@"client"];
    [dic setValue:[MDDevice getInstance].token forKey:@"device_token"];
    
    MKNetworkOperation *op     = [_engine operationWithPath:API_DRIVERS_UPDATE_PROFILE
                                                     params:dic
                                                 httpMethod:@"POST"
                                                        ssl:YES];
    
    [op addCompletionHandler:complete errorHandler:error];
    [_engine enqueueOperation:op];
}

-(void) loginWithPhone:(NSString *)phoneNumber
              password:(NSString *)password
            onComplete:(void (^)(MKNetworkOperation *))complete
               onError:(void (^)(MKNetworkOperation *, NSError *))error {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:phoneNumber forKey:@"phone"];
    [dic setValue:password forKey:@"password"];
    [dic setValue:USER_DEVICE forKey:@"client"];
    
    [self callApi:dic
          withUrl:API_DRIVERS_LOGIN
       withImages:@[]
   withHttpMethod:@"POST"
       onComplete:complete
          onError:error];
}

-(void) registerBaggageWithHash:(NSString *)hash
                     OnComplete:(void (^)(MKNetworkOperation *))complete
                          onError:(void (^)(MKNetworkOperation *, NSError *))error {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:hash         forKey:@"hash"];
    [dic setObject:USER_DEVICE  forKey:@"client"];
    [dic setObject:[MDCurrentPackage getInstance].requestType       forKey:@"type"];
    [dic setObject:[MDCurrentPackage getInstance].from_addr         forKey:@"from_addr"];
    [dic setObject:[MDCurrentPackage getInstance].from_lat          forKey:@"from_lat"];
    [dic setObject:[MDCurrentPackage getInstance].from_lng          forKey:@"from_lng"];
    [dic setObject:[MDCurrentPackage getInstance].to_addr           forKey:@"to_addr"];
    [dic setObject:[MDCurrentPackage getInstance].to_lat            forKey:@"to_lat"];
    [dic setObject:[MDCurrentPackage getInstance].to_lng            forKey:@"to_lng"];
    [dic setObject:[MDCurrentPackage getInstance].request_amount    forKey:@"request_amount"];
    [dic setObject:[MDCurrentPackage getInstance].note              forKey:@"note"];
    [dic setObject:[MDCurrentPackage getInstance].size              forKey:@"size"];
    [dic setValue:[MDCurrentPackage getInstance].at_home_time       forKey:@"at_home_time"];
    [dic setObject:[MDCurrentPackage getInstance].deliver_limit     forKey:@"deliver_limit"];
    [dic setObject:[MDCurrentPackage getInstance].expire            forKey:@"expire"];
    
    [self callApi:dic
          withUrl:API_PACKAGE_RESIGER
       withImages:@[]
   withHttpMethod:@"POST"
       onComplete:complete
          onError:error];
}

-(void) uploadImageWithHash:(NSString *)hash
                  packageId:(NSString *)package_id
                      image:(UIImage *)image
                 OnComplete:(void (^)(MKNetworkOperation *))complete
                    onError:(void (^)(MKNetworkOperation *, NSError *))error{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:hash forKey:@"hash"];
    [dic setObject:USER_DEVICE forKey:@"client"];
    [dic setObject:package_id forKey:@"package_id"];
    
    [self callApi:dic
          withUrl:API_PACKAGE_IMAGE
       withImages:@[image]
   withHttpMethod:@"POST"
       onComplete:complete
          onError:error];
}

-(void) updatePhoneNumberWithOldPhoneNumber:(NSString *)oldPhoneNumber
                             newPhoneNumber:(NSString *)newPhoneNumber
                                 OnComplete:(void (^)(MKNetworkOperation *))complete
                                    onError:(void (^)(MKNetworkOperation *, NSError *))error {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:oldPhoneNumber   forKey:@"phone"];
    [dic setObject:newPhoneNumber   forKey:@"new_phone"];
    
    [self callApi:dic
          withUrl:API_DRIVERS_UPDATE_PHONE
       withImages:@[]
   withHttpMethod:@"POST"
       onComplete:complete
          onError:error];
}

-(void)getMyPackageWithHash:(NSString *)hash
                 OnComplete:(void (^)(MKNetworkOperation *))complete
                    onError:(void (^)(MKNetworkOperation *, NSError *))error{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:hash forKey:@"hash"];
    [dic setObject:USER_DEVICE forKey:@"client"];
    
    [self callApi:dic
          withUrl:API_GET_MY_PACKAGE
       withImages:@[]
   withHttpMethod:@"GET"
       onComplete:complete
          onError:error];
}

-(void) getWaitingPackageWithHash:(NSString *)hash
                       OnComplete:(void (^)(MKNetworkOperation *))complete
                          onError:(void (^)(MKNetworkOperation *, NSError *))error{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:hash forKey:@"hash"];
    [dic setObject:USER_DEVICE forKey:@"client"];
    
    [self callApi:dic
          withUrl:API_GET_WAITING_PACKAGE
       withImages:@[]
   withHttpMethod:@"GET"
       onComplete:complete
          onError:error];
}


-(void) getWaitingPackageWithHash:(NSString *)hash
                         WithPref:(NSString *)pref
                       OnComplete:(void (^)(MKNetworkOperation *))complete
                          onError:(void (^)(MKNetworkOperation *, NSError *))error{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:hash forKey:@"hash"];
    [dic setObject:pref forKey:@"search_pref"];
    [dic setObject:USER_DEVICE forKey:@"client"];
    
    [self callApi:dic
          withUrl:API_GET_WAITING_PACKAGE
       withImages:@[]
   withHttpMethod:@"GET"
       onComplete:complete
          onError:error];
}

-(void) acceptPackageWithHash:(NSString *)hash
                    packageId:(NSString *)package_id
                   OnComplete:(void (^)(MKNetworkOperation *))complete
                      onError:(void (^)(MKNetworkOperation *, NSError *))error{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:hash forKey:@"hash"];
    [dic setObject:USER_DEVICE forKey:@"client"];
    [dic setObject:package_id forKey:@"package_id"];
    
    
    [self callApi:dic
          withUrl:API_PACKAGE_ACCEPT
       withImages:@[]
   withHttpMethod:@"POST"
       onComplete:complete
          onError:error];
}

-(void) receviePackageWithHash:(NSString *)hash
                     packageId:(NSString *)package_id
                    OnComplete:(void (^)(MKNetworkOperation *))complete
                       onError:(void (^)(MKNetworkOperation *, NSError *))error{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:hash forKey:@"hash"];
    [dic setObject:USER_DEVICE forKey:@"client"];
    [dic setObject:package_id forKey:@"package_id"];
    
    
    [self callApi:dic
          withUrl:API_PACKAGE_RECEIVE
       withImages:@[]
   withHttpMethod:@"POST"
       onComplete:complete
          onError:error];
}

-(void) deliveryPackageWithHash:(NSString *)hash
                      packageId:(NSString *)package_id
                     OnComplete:(void (^)(MKNetworkOperation *))complete
                        onError:(void (^)(MKNetworkOperation *, NSError *))error{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:hash forKey:@"hash"];
    [dic setObject:USER_DEVICE forKey:@"client"];
    [dic setObject:package_id forKey:@"package_id"];
    
    
    [self callApi:dic
          withUrl:API_PACKAGE_DELIVERY
       withImages:@[]
   withHttpMethod:@"POST"
       onComplete:complete
          onError:error];
}

-(void) postReviewWithHash:(NSString *)hash
                 packageId:(NSString *)package_id
                      star:(NSString *)star
                      text:(NSString *)text
                OnComplete:(void (^)(MKNetworkOperation *))complete
                   onError:(void (^)(MKNetworkOperation *, NSError *))error{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:hash forKey:@"hash"];
    [dic setObject:USER_DEVICE forKey:@"client"];
    [dic setObject:package_id forKey:@"package_id"];
    [dic setObject:star forKey:@"star"];
    [dic setObject:text forKey:@"text"];
    
    
    [self callApi:dic
          withUrl:API_DRIVERS_REVIREW
       withImages:@[]
   withHttpMethod:@"POST"
       onComplete:complete
          onError:error];
}

-(void) getUserDataWithHash:(NSString *)hash
                     userId:(NSString *)user_id
                 OnComplete:(void (^)(MKNetworkOperation *))complete
                    onError:(void (^)(MKNetworkOperation *, NSError *))error{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:hash forKey:@"hash"];
    [dic setObject:USER_DEVICE forKey:@"client"];
    [dic setObject:user_id forKey:@"user_id"];
    
    
    [self callApi:dic
          withUrl:API_DRIVERS_GET_USER_DATA
       withImages:@[]
   withHttpMethod:@"GET"
       onComplete:complete
          onError:error];
}

-(void) getPackageByPakcageId:(NSString *)package_id
                   OnComplete:(void (^)(MKNetworkOperation *))complete
                      onError:(void (^)(MKNetworkOperation *, NSError *))error{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:package_id forKey:@"package_id"];
    
    [self callApi:dic
          withUrl:API_GET_PACKAGE_DATA
       withImages:@[]
   withHttpMethod:@"GET"
       onComplete:complete
          onError:error];
}

-(void) getDriverDataWithHash:(NSString *)hash
                     driverId:(NSString *)driver_id
                   OnComplete:(void (^)(MKNetworkOperation *))complete
                      onError:(void (^)(MKNetworkOperation *, NSError *))error{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:hash forKey:@"hash"];
    [dic setObject:USER_DEVICE forKey:@"client"];
    [dic setObject:driver_id forKey:@"driver_id"];
    
    [self callApi:dic
          withUrl:API_USER_GET_DRIVER_DATA
       withImages:@[]
   withHttpMethod:@"GET"
       onComplete:complete
          onError:error];
}

-(void) setBankAccountWithHash:(NSString *)hash
                      bankInfo:(MDBankInfo *)bankInfo
                    OnComplete:(void (^)(MKNetworkOperation *))complete
                       onError:(void (^)(MKNetworkOperation *, NSError *))error{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:hash forKey:@"hash"];
    [dic setObject:USER_DEVICE forKey:@"client"];
    [dic setObject:bankInfo.bank_number forKey:@"bank_number"];
    [dic setObject:bankInfo.branch_number forKey:@"branch_number"];
    [dic setObject:bankInfo.type forKey:@"type"];
    [dic setObject:bankInfo.account_number forKey:@"account_number"];
    [dic setObject:bankInfo.name forKey:@"name"];
    
    
    [self callApi:dic
          withUrl:API_SET_BANK_ACCOUNT
       withImages:@[]
   withHttpMethod:@"POST"
       onComplete:complete
          onError:error];
}

-(void) requestWithDrawDepositWithHash:(NSString *)hash
                                amount:(NSString *)amount
                            OnComplete:(void (^)(MKNetworkOperation *))complete
                               onError:(void (^)(MKNetworkOperation *, NSError *))error{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:hash forKey:@"hash"];
    [dic setObject:USER_DEVICE forKey:@"client"];
    [dic setObject:amount forKey:@"amount"];
    
    
    [self callApi:dic
          withUrl:API_REQUEST_WITHDRAW_DEPOSIT
       withImages:@[]
   withHttpMethod:@"POST"
       onComplete:complete
          onError:error];
}

-(void) getAllNotificationWithHash:(NSString *)hash
                        OnComplete:(void (^)(MKNetworkOperation *))complete
                           onError:(void (^)(MKNetworkOperation *, NSError *))error{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:hash forKey:@"hash"];
    [dic setObject:USER_DEVICE forKey:@"client"];
    [dic setObject:@"0" forKey:@"last_id"];
    
    [self callApi:dic
          withUrl:API_GET_NOTIFICATION
       withImages:@[]
   withHttpMethod:@"GET"
       onComplete:complete
          onError:error];
}

@end
