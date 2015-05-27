//
//  MDPhoneNumberSettingViewController.m
//  Distribution
//
//  Created by Lsr on 4/18/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDPhoneNumberSettingViewController.h"
#import "MDInput.h"
#import "MDUser.h"
#import "MDAPI.h"
#import "MDUtil.h"
#import <SVProgressHUD.h>
#import "MDPhoneViewController.h"

@interface MDPhoneNumberSettingViewController () {
    UIButton *postButton;
}

@end

@implementation MDPhoneNumberSettingViewController

-(void) loadView {
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _phoneInput = [[MDInput alloc]initWithFrame:CGRectMake(10, 74, self.view.frame.size.width-20, 50)];
    _phoneInput.title.text = @"携帯番号";
    [_phoneInput setUserInteractionEnabled:NO];
    _phoneInput.input.text = [MDUtil japanesePhoneNumber:[MDUser getInstance].phoneNumber];
    [_phoneInput.input setKeyboardType:UIKeyboardTypeNumberPad];
    [_phoneInput.title sizeToFit];
    [self.view addSubview:_phoneInput];
    
    postButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 134, self.view.frame.size.width-20, 50)];
    [postButton setBackgroundColor:[UIColor colorWithRed:226.0/255.0 green:138.0/255.0 blue:0 alpha:1]];
    [postButton setTitle:@"携帯番号の変更" forState:UIControlStateNormal];
    postButton.layer.cornerRadius = 2.5;
    [postButton addTarget:self action:@selector(changePhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:postButton];
    
    [self initNavigationBar];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavigationBar {
    self.navigationItem.title = @"携帯番号";
    //add right button item
    UIButton *_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setTitle:@"戻る" forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
    _backButton.frame = CGRectMake(0, 0, 25, 44);
    [_backButton addTarget:self action:@selector(backButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}

-(void) changePhoneNumber {
    //call api
    
    MDPhoneViewController *pvc = [[MDPhoneViewController alloc]init];
    [self.navigationController pushViewController:pvc animated:YES];
}

-(void) backButtonTouched {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
