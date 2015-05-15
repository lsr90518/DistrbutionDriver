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

@end
