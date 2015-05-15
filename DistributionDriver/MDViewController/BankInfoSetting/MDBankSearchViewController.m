//
//  MDBankSearchViewController.m
//  DistributionDriver
//
//  Created by Lsr on 5/13/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDBankSearchViewController.h"

@implementation MDBankSearchViewController

-(void) loadView{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1]];
    
    UIWebView *wv = [[UIWebView alloc] init];
    wv.delegate = self;
    wv.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    wv.scalesPageToFit = YES;
    [self.view addSubview:wv];
    
    NSURL *url = [NSURL URLWithString:@"http://bkichiran.hikak.com"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [wv loadRequest:req];
    
    UIButton *_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setTitle:@"戻る" forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
    _backButton.frame = CGRectMake(18, 20, 25, 44);
    [self.view addSubview:_backButton];
    [_backButton addTarget:self action:@selector(backButtonTouched) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) backButtonTouched {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
