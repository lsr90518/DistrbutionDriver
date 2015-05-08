//
//  MDRequestViewController.m
//  Distribution
//
//  Created by Lsr on 3/27/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDRequestViewController.h"
#import "MDDeliveryViewController.h"
#import "MDSettingViewController.h"
#import "MDRequestDetailViewController.h"

@interface MDRequestViewController ()

@end

@implementation MDRequestViewController

-(void)loadView{
    [super loadView];
    
    self.navigationItem.title = @"引き受け依頼";
    _requestView = [[MDRequestView alloc]initWithFrame:self.view.frame];
    _requestView.delegate = self;
    [self.view addSubview:_requestView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //call api
    [SVProgressHUD show];
    [[MDAPI sharedAPI] getMyPackageWithHash:[MDUser getInstance].userHash
                                 OnComplete:^(MKNetworkOperation *complete){
                                     if([[complete responseJSON][@"code"] integerValue] == 0){
                                         [_requestView initWithArray:[complete responseJSON][@"Packages"]];
                                     }
                                     [SVProgressHUD dismiss];
                                 }
                                    onError:^(MKNetworkOperation *complete, NSError *error){
                                        NSLog(@"error ------------------------ %@", error);
                                        [SVProgressHUD dismiss];
                                    }];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) gotoDeliveryView{
    MDDeliveryViewController *dvc = [[MDDeliveryViewController alloc]init];
    UINavigationController *dvcNavigationController = [[UINavigationController alloc]initWithRootViewController:dvc];
    [self presentViewController:dvcNavigationController animated:NO completion:nil];
}

-(void) gotoSettingView {
    MDSettingViewController *dvc = [[MDSettingViewController alloc]init];
    UINavigationController *dvcNavigationController = [[UINavigationController alloc]initWithRootViewController:dvc];
    [self presentViewController:dvcNavigationController animated:NO completion:nil];
    
}

-(void) makeUpData:(NSDictionary *)data{
    NSLog(@"kita");
    MDRequestDetailViewController *rdvc = [[MDRequestDetailViewController alloc]init];
    MDPackage *tmpPackage = [[MDPackage alloc]initWithData:data];
    rdvc.package = tmpPackage;
    [self.navigationController pushViewController:rdvc animated:YES];
}


@end
