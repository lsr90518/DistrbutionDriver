//
//  MDIntroViewController.m
//  DistributionDriver
//
//  Created by Lsr on 5/10/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDIntroViewController.h"
#import "MDAPI.h"
#import <SVProgressHUD.h>

@interface MDIntroViewController ()

@end

@implementation MDIntroViewController

-(void) loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.serviceInputView = [[UITextView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height -250)];
    [self.serviceInputView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    self.serviceInputView.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1].CGColor;
    self.serviceInputView.returnKeyType = UIReturnKeyDefault;
    self.serviceInputView.keyboardType = UIKeyboardTypeDefault;
    self.serviceInputView.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:14];
    [self.view addSubview:self.serviceInputView];
    
    [self.serviceInputView becomeFirstResponder];
    [self initNavigationBar];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    [self.serviceInputView setFrame:CGRectMake(10, 74, self.view.frame.size.width-20, 200)];
}

-(void) initNavigationBar {
    self.navigationItem.title = @"自己紹介";
    
    UIButton *_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setTitle:@"戻る" forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
    _backButton.frame = CGRectMake(0, 0, 25, 44);
    [_backButton addTarget:self action:@selector(backButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIButton *_postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_postButton setTitle:@"保存" forState:UIControlStateNormal];
    _postButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
    _postButton.frame = CGRectMake(0, 0, 25, 44);
    [_postButton addTarget:self action:@selector(saveDetail) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:_postButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

-(void) viewWillAppear:(BOOL)animated{
    _serviceInputView.text = [MDUser getInstance].intro;
}

-(void) backButtonTouched {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) saveDetail{
    [self.serviceInputView resignFirstResponder];
    [MDUser getInstance].intro = _serviceInputView.text;
    //call api
    [SVProgressHUD showWithStatus:@"保存" maskType:SVProgressHUDMaskTypeClear];
    [[MDAPI sharedAPI] changeProfileByUser:[MDUser getInstance]
                                onComplete:^(MKNetworkOperation *complete) {
                                    NSLog(@"%@",[complete responseJSON]);
                                    if ([[complete responseJSON][@"code"] intValue] == 0) {
                                        [SVProgressHUD dismiss];
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }
                                 } onError:^(MKNetworkOperation *operation, NSError *error) {
        
                                 }];
}

-(void) setText:(NSString *)text{
    self.serviceInputView.text = text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
