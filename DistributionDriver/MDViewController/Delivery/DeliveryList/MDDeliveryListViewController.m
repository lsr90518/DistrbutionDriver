//
//  MDDeliveryListViewController.m
//  DistributionDriver
//
//  Created by 劉 松然 on 2015/05/07.
//  Copyright (c) 2015年 Lsr. All rights reserved.
//

#import "MDDeliveryListViewController.h"
#import "MDDeliveryViewController.h"

@implementation MDDeliveryListViewController

-(void)loadView{
    [super loadView];
    
    _listView = [[MDDeliveryListView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_listView];
}

-(void) viewWillAppear:(BOOL)animated{
    
    //call api
    [SVProgressHUD show];
    [[MDAPI sharedAPI] getMyPackageWithHash:[MDUser getInstance].userHash
                                 OnComplete:^(MKNetworkOperation *complete){
                                     if([[complete responseJSON][@"code"] integerValue] == 0){
                                         
                                         [_listView initWithArray:[complete responseJSON][@"Packages"]];
                                     }
                                     [SVProgressHUD dismiss];
                                 }
                                    onError:^(MKNetworkOperation *complete, NSError *error){
                                        NSLog(@"error ------------------------ %@", error);
                                        [SVProgressHUD dismiss];
                                    }];
}

-(void) initNavigationBar {
    self.navigationItem.title = @"配送の依頼";
    //add right button item
    UIButton *_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setTitle:@"戻る" forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
    _backButton.frame = CGRectMake(0, 0, 25, 44);
    [_backButton addTarget:self action:@selector(goBackToMap) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //right button
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setTitle:@"リスト" forState:UIControlStateNormal];
//    rightButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
//    rightButton.frame = CGRectMake(0, 0, 25, 44);
//    [rightButton addTarget:self action:@selector(gotoListView) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = rightBtn;
}

-(void)goBackToMap{
    MDDeliveryViewController *dvc = [[MDDeliveryViewController alloc]init];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
