//
//  MDSettingViewController.m
//  Distribution
//
//  Created by Lsr on 3/27/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDSettingViewController.h"
#import "MDPhoneNumberSettingViewController.h"
#import "MDNameSettingViewController.h"
#import "MDPhoneViewController.h"
#import "MDRequestViewController.h"
#import "MDDeliveryViewController.h"
#import "MDProfileViewController.h"
#import "MDTranspotationViewController.h"
#import "MDIntroViewController.h"
#import "MDNotificationTable.h"
#import "MDReviewHistoryViewController.h"
#import "MDNotificationService.h"
#import "MDBankInfoSettingViewController.h"

@interface MDSettingViewController (){
}

@end

@implementation MDSettingViewController

-(void)loadView{
    [super loadView];
    self.navigationItem.title = @"設定";
    _settingView = [[MDSettingView alloc]initWithFrame:self.view.frame];
    _settingView.delegate = self;
    [self.view addSubview:_settingView];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [_settingView setViewData:[MDUser getInstance]];
    int count = (int)[[MDNotificationService getInstance].notificationList count];
    [_settingView setNotificationCount:count];
}

#pragma delegate methods
-(void) profileImagePushed{
    MDProfileViewController *pvc = [[MDProfileViewController alloc]init];
    [self.navigationController pushViewController:pvc animated:YES];
}

-(void) phoneNumberPushed {
    MDPhoneNumberSettingViewController *phoneNumberSettingViewController = [[MDPhoneNumberSettingViewController alloc]init];
    [self.navigationController pushViewController:phoneNumberSettingViewController animated:YES];
}

-(void) nameButtonPushed {
    MDNameSettingViewController *nameSettingViewController = [[MDNameSettingViewController alloc]init];
    [self.navigationController pushViewController:nameSettingViewController animated:YES];
}

-(void) gotoDeliveryView {
    MDDeliveryViewController *rvc = [[MDDeliveryViewController alloc]init];
    UINavigationController *rvcNavigationController = [[UINavigationController alloc]initWithRootViewController:rvc];
    [self presentViewController:rvcNavigationController animated:NO completion:nil];
}
-(void) gotoRequestView {
    MDRequestViewController *rvc = [[MDRequestViewController alloc]init];
    UINavigationController *rvcNavigationController = [[UINavigationController alloc]initWithRootViewController:rvc];
    [self presentViewController:rvcNavigationController animated:NO completion:nil];
}

-(void)gotoTansptationView{
    MDTranspotationViewController *tttvc = [[MDTranspotationViewController alloc]init];
    [self.navigationController pushViewController:tttvc animated:YES];
}

-(void) introButtonPushed{
    MDIntroViewController *ivc = [[MDIntroViewController alloc]init];
    [self.navigationController pushViewController:ivc animated:YES];
}

-(void) payButtonPushed{
    MDBankInfoSettingViewController *bsvc = [[MDBankInfoSettingViewController alloc]init];
    [self.navigationController pushViewController:bsvc animated:YES];
}

-(void) logoutButtonPushed{
    [SVProgressHUD showSuccessWithStatus:@"ログアウト中..."];
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    RLMResults *newconsiger = [MDConsignor allObjectsInRealm:realm];
    MDConsignor *consignor = [[MDConsignor alloc]init];
    
    for(MDConsignor *tmp in newconsiger){
        consignor.userid = tmp.userid;
        consignor.phonenumber = tmp.phonenumber;
    }
    consignor.password = @"";
    
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:consignor];
    [realm commitWriteTransaction];
    
    [[MDUser getInstance] clearData];
    
    [SVProgressHUD dismiss];
    MDIndexViewController *ivc = [[MDIndexViewController alloc]init];
    [self presentViewController:ivc animated:NO completion:nil];
    
}

-(void) notificationButtonPushed {
    MDNotificationTable *nt = [[MDNotificationTable alloc]init];
    
    nt.notificationList = [MDNotificationService getInstance].notificationList;
    [self.navigationController pushViewController:nt animated:YES];
}

-(void) averageButtonPushed{
    MDReviewHistoryViewController *rhvc = [[MDReviewHistoryViewController alloc]init];
    rhvc.completePakcageList = [MDMyPackageService getInstance].completePackageList;
    [self.navigationController pushViewController:rhvc animated:YES];
}

@end
