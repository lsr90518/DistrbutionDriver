//
//  MDReviewViewController.m
//  DistributionDriver
//
//  Created by 劉 松然 on 2015/05/08.
//  Copyright (c) 2015年 Lsr. All rights reserved.
//

#import "MDReviewViewController.h"
#import "MDAPI.h"
#import <SVProgressHUD.h>

@implementation MDReviewViewController

-(void) loadView{
    [super loadView];
    _reviewView = [[MDReviewView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_reviewView];
    _reviewView.delegate = self;
//    [_reviewView initWithData:_package.driverReview];
    [self initNavigationBar];
}

-(void) initNavigationBar {
    self.navigationItem.title = @"依頼者への評価";
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
-(void) backToTop {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void) postButtonPushed{
//    [self backToTop];
    //call api
    [SVProgressHUD show];
    [[MDAPI sharedAPI]postReviewWithHash:[MDUser getInstance].userHash
                                packageId:_package.package_id
                                     star:_reviewView.rating
                                     text:_reviewView.reviewText
                              OnComplete:^(MKNetworkOperation *completeOperation){
                                  //call api
                                  [SVProgressHUD showSuccessWithStatus:@"評価完了!"];
                                  
                                  [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(backToTop) name:SVProgressHUDDidDisappearNotification object: nil];

                              }onError:^(MKNetworkOperation *operation, NSError *error) {
                                  NSLog(@"%@  error %@", [operation responseJSON], error);
                              }];
}

@end
