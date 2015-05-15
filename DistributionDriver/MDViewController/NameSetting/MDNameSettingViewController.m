//
//  MDNameSettingViewController.m
//  Distribution
//
//  Created by Lsr on 4/18/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDNameSettingViewController.h"
#import "MDAPI.h"
#import <SVProgressHUD.h>

@interface MDNameSettingViewController ()

@end

@implementation MDNameSettingViewController

-(void) loadView {
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _lastnameInput = [[MDInput alloc]initWithFrame:CGRectMake(10, 74, self.view.frame.size.width-20, 50)];
    _lastnameInput.title.text = @"姓";
    [_lastnameInput.title sizeToFit];
    _lastnameInput.input.text = [MDUser getInstance].lastname;
    [self.view addSubview:_lastnameInput];
    
    _firstnameInput = [[MDInput alloc]initWithFrame:CGRectMake(10, 123, self.view.frame.size.width-20, 50)];
    [_firstnameInput setBackgroundColor:[UIColor whiteColor]];
    _firstnameInput.title.text = @"名";
    [_firstnameInput.title sizeToFit];
    _firstnameInput.input.text = [MDUser getInstance].firstname;
    [self.view addSubview:_firstnameInput];
    
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
    self.navigationItem.title = @"名前を設定";
    //add right button item
    UIButton *_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setTitle:@"戻る" forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
    _backButton.frame = CGRectMake(0, 0, 25, 44);
    [_backButton addTarget:self action:@selector(backButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = leftButton;
}

-(void) backButtonPushed{
    //call api
    MDUser *tmpUser = [[MDUser alloc]init];
    tmpUser = [MDUser getInstance];
    
    tmpUser.lastname = _lastnameInput.input.text;
    tmpUser.firstname = _firstnameInput.input.text;
    
    [SVProgressHUD showWithStatus:@"保存" maskType:SVProgressHUDMaskTypeClear];
    [[MDAPI sharedAPI] changeProfileByUser:tmpUser
                                onComplete:^(MKNetworkOperation *complete) {
                                    [SVProgressHUD dismiss];
                                    if([[complete responseJSON][@"code"] intValue] == 0){
                                        [MDUser getInstance].lastname = _lastnameInput.input.text;
                                        [MDUser getInstance].firstname = _firstnameInput.input.text;
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }
                                }onError:^(MKNetworkOperation *operation, NSError *error) {
                                    NSLog(@"%@", error);
                                    [self.navigationController popViewControllerAnimated:YES];
                                }];
}


@end
