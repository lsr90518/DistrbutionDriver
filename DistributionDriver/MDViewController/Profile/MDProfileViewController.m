//
//  MDProfileViewController.m
//  DistributionDriver
//
//  Created by Lsr on 4/26/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDProfileViewController.h"
#import "MDDriverHistoryViewController.h"
#import <SVProgressHUD.h>

@interface MDProfileViewController ()

@end

@implementation MDProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) loadView {
    [super loadView];
    _profileView = [[MDProfileView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_profileView];
    _profileView.delegate = self;
    [self initNavigationBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD show];
    //get driver data
    [[MDAPI sharedAPI] getMyPackageWithHash:[MDUser getInstance].userHash
                                 OnComplete:^(MKNetworkOperation *complete) {
                                 
                                     [[MDMyPackageService getInstance] initDataWithArray:[complete responseJSON][@"Packages"]];
                                     
                                     [self setupDriver];
                                     
                                     [_profileView setDriverData:_driver];
                                     [SVProgressHUD dismiss];
                                 } onError:^(MKNetworkOperation *operation, NSError *error) {
                                        
                                 }];
}

-(void) setupDriver {
    _driver = [[MDDriver alloc]init];
    [_driver initWithUser:[MDUser getInstance]];
    
    int average_star = [[MDMyPackageService getInstance] getAverageStar];
    _driver.average_star = [NSString stringWithFormat:@"%d",average_star];
    _driver.delivered_package = [NSString stringWithFormat:@"%lu", (unsigned long)[[MDMyPackageService getInstance].reviewList count]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initNavigationBar {
    self.navigationItem.title = @"プロフィール";
    //add right button item
    UIButton *_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setTitle:@"戻る" forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
    _backButton.frame = CGRectMake(0, 0, 25, 44);
    [_backButton addTarget:self action:@selector(backButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}
-(void) backButtonTouched {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) historyButtonPushed{
    MDDriverHistoryViewController * dhvc = [[MDDriverHistoryViewController alloc]init];
    dhvc.reviews = [MDMyPackageService getInstance].reviewList;
    [self.navigationController pushViewController:dhvc animated:YES];
}

-(void) editProfile{
    
}

@end
