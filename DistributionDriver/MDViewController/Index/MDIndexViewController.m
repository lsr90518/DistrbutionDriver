//
//  MDIndexViewController.m
//  Distribution
//
//  Created by Lsr on 4/11/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDIndexViewController.h"
#import "MDViewController.h"
#import "MDUtil.h"
#import "MDDeliveryViewController.h"
#import "MDCreateProfileViewController.h"

@interface MDIndexViewController ()

@end

@implementation MDIndexViewController

- (void) loadView {
    [super loadView];
    
    UIImageView *backGroundView = [[UIImageView alloc]initWithFrame:self.view.frame];
    [backGroundView setImage:[UIImage imageNamed:@"firstBG"]];
    [self.view addSubview:backGroundView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    MDUser *user = [MDUser getInstance];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    RLMResults *newconsiger = [MDConsignor allObjectsInRealm:realm];
    if([newconsiger count] == 0){
        
        user.phoneNumber = @"";
        user.password = @"";
        [self initIndexView];
        
    } else {
        
        for(MDConsignor *tmp in newconsiger){
            MDUser *user = [MDUser getInstance];
            [user initDataWithConsignor:tmp];
        }
        
        //call login api
        [[MDAPI sharedAPI]loginWithPhone:[MDUser getInstance].phoneNumber
                                password:[MDUser getInstance].password
                              onComplete:^(MKNetworkOperation *complete) {
                                  if([[complete responseJSON][@"code"] intValue] == 0){
                                      
                                      
                                      MDUser *user = [MDUser getInstance];
                                      user.userHash = [complete responseJSON][@"hash"];
                                      [user setData:[complete responseJSON][@"data"]];
                                      
                                      [[MDUser getInstance] setLogin];
                                      
                                      [self gotoDelivery];
                                  } else {
                                      [self initIndexView];
                                  }
                                  
                              }onError:^(MKNetworkOperation *operation, NSError *error) {
                                  //
                                  NSLog(@"error %@", error);
                              }];
    }

}

-(void) initIndexView{
    _indexView = [[MDIndexView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _indexView.delegate = self;
    [self.view addSubview:_indexView];
}

#pragma indexDelegate
-(void)signTouched {
//    MDPhoneViewController *phoneViewController = [[MDPhoneViewController alloc]init];
//    UINavigationController *signNavigationController = [[UINavigationController alloc]initWithRootViewController:phoneViewController];
//    [self presentViewController:signNavigationController animated:YES completion:nil];
    MDCreateProfileViewController *cpvc = [[MDCreateProfileViewController alloc]init];
    [self presentViewController:cpvc animated:YES completion:nil];
}

-(void)loginTouched {
    MDLoginViewController *loginViewController = [[MDLoginViewController alloc]init];
    UINavigationController *loginNavigationController = [[UINavigationController alloc]initWithRootViewController:loginViewController];
    [self presentViewController:loginNavigationController animated:YES completion:nil];
}

-(void)gotoDelivery{
    MDDeliveryViewController *deliveryViewController = [[MDDeliveryViewController alloc]init];
    UINavigationController *deliveryNavigationController = [[UINavigationController alloc]initWithRootViewController:deliveryViewController];
    [self presentViewController:deliveryNavigationController animated:YES completion:nil];
}


@end
