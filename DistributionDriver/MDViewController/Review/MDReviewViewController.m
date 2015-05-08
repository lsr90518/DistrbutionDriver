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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}


-(void) postButtonPushed:(MDReviewView *)reviewView{
    //call api
    [SVProgressHUD show];
    [[MDAPI sharedAPI] postReviewWithHash:[MDUser getInstance].userHash
                                packageId:_package.package_id
                                     star:reviewView.rating
                                     text:reviewView.reviewText
                               OnComplete:^(MKNetworkOperation *operation) {
                                   [SVProgressHUD showSuccessWithStatus:@"評価完成!"];
                                   
                                   [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(backToTop) name:SVProgressHUDDidDisappearNotification object: nil];
                               } onError:^(MKNetworkOperation *operation, NSError *error) {

                               }];
    
}

@end
