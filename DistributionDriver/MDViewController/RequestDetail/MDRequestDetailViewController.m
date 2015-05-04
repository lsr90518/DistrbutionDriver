//
//  MDRequestDetailViewController.m
//  Distribution
//
//  Created by Lsr on 4/19/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDRequestDetailViewController.h"
#import "MDAPI.h"
#import <SVProgressHUD.h>
#import "MDUtil.h"

@interface MDRequestDetailViewController ()

@end

@implementation MDRequestDetailViewController

-(void) loadView {
    [super loadView];
    _requestDetailView = [[MDRequestDetailView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_requestDetailView];
    
    [_requestDetailView setStatus:[_package.status intValue]];
    
    [_requestDetailView makeupByData:_package];
    
}

-(void)initNavigationBar {
    NSString *number = [NSString stringWithFormat:@"%@",_package.package_number];
    int length = number.length/2;
    NSString *numberLeft = [number substringToIndex:length];
    NSString *numberRight = [number substringFromIndex:length];
    self.navigationItem.title = [NSString stringWithFormat:@"番号: %@ - %@",numberLeft, numberRight];
    //add right button item
    UIButton *_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setTitle:@"戻る" forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
    _backButton.frame = CGRectMake(0, 0, 25, 44);
    [_backButton addTarget:self action:@selector(backButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //add right button item
    
    if ([_package.status intValue] == 0) {
        UIButton *_postButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_postButton setTitle:@"受ける" forState:UIControlStateNormal];
        _postButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
        _postButton.frame = CGRectMake(0, 0, 40, 44);
        [_postButton addTarget:self action:@selector(reciveOrder) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:_postButton];
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void) viewWillAppear:(BOOL)animated{
    [self initNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) backButtonPushed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) reciveOrder {
    //call api
    [SVProgressHUD show];
    [[MDAPI sharedAPI] acceptPackageWithHash:[MDUser getInstance].userHash
                                   packageId:_package.package_id
                                  OnComplete:^(MKNetworkOperation *operation) {
                                      NSLog(@"%@", [operation responseJSON]);
                                      
                                      if([[operation responseJSON][@"code"] intValue] == 3){
                                          [MDUtil makeAlertWithTitle:@"惜しい" message:@"他のドライバーに決まられた。" done:@"OK" viewController:self];
                                      } else if([[operation responseJSON][@"code"] intValue] == 2){
                                          [MDUtil makeAlertWithTitle:@"不正番号" message:@"改めてログインしてください。" done:@"OK" viewController:self];
                                      } else {
                                      }
                                      
                                      [SVProgressHUD dismiss];
                                  } onError:^(MKNetworkOperation *operation, NSError *error) {
    
                                  }];
}

@end
