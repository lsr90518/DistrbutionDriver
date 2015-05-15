//
//  MDDeliveryListViewController.m
//  DistributionDriver
//
//  Created by 劉 松然 on 2015/05/07.
//  Copyright (c) 2015年 Lsr. All rights reserved.
//

#import "MDDeliveryListViewController.h"
#import "MDDeliveryViewController.h"
#import "MDRequestDetailViewController.h"
#import "MDPackageService.h"

@implementation MDDeliveryListViewController

-(void)loadView{
    [super loadView];
    
    _listView = [[MDDeliveryListView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_listView];
    _listView.delegate = self;
    
    [self initNavigationBar];
}

-(void) viewWillAppear:(BOOL)animated{
    [_listView initWithArray:[MDPackageService getInstance].packageList];
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
    
}

-(void)goBackToMap{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) makeUpData:(MDPackage *)data{
    MDRequestDetailViewController *rdvc = [[MDRequestDetailViewController alloc]init];
    rdvc.package = data;
    [self.navigationController pushViewController:rdvc animated:YES];
}

@end
