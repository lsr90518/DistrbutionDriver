//
//  MDLoginViewController.m
//  Distribution
//
//  Created by Lsr on 4/11/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDLoginViewController.h"
#import "MDViewController.h"
#import "MDAPI.h"
#import <SVProgressHUD.h>
#import "MDUtil.h"
#import "MDJudgmentViewController.h"
#import "MDDeliveryViewController.h"

@interface MDLoginViewController ()

@end

@implementation MDLoginViewController


-(void)loadView {
    [super loadView];
    _loginView = [[MDLoginView alloc]initWithFrame:self.view.frame];
    _loginView.delegate = self;
    [self.view addSubview:_loginView];
    
    [self initNavigationBar];
}

-(void)initNavigationBar {
    self.navigationItem.title = @"ログイン";
    //add right button item
    UIButton *_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setTitle:@"戻る" forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
    _backButton.frame = CGRectMake(0, 0, 25, 44);
    [_backButton addTarget:self action:@selector(backButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)postData:(MDLoginView *)loginView {
    
    if(loginView.phoneInput.input.text.length > 3 && loginView.passwordInput.input.text > 0){
        
        NSString *phoneNumber = [MDUtil internationalPhoneNumber:loginView.phoneInput.input.text];
        NSString *password = loginView.passwordInput.input.text;
        
        [SVProgressHUD show];
        [[MDAPI sharedAPI] loginWithPhone:phoneNumber
                                 password:password
                               onComplete:^(MKNetworkOperation *completeOperation) {
                                   [SVProgressHUD dismiss];
                                   if([[completeOperation responseJSON][@"code"] integerValue] == 0){
                                       
                                       NSString *status = [completeOperation responseJSON][@"data"][@"status"];
                                       if([status isEqualToString:@"-1"]){
                                           
                                           [MDUtil makeAlertWithTitle:@"審査で拒否" message:@"審査で拒否されました。" done:@"OK" viewController:self];
                                       } else if([status isEqualToString:@"-2"]){
                                           
                                           [MDUtil makeAlertWithTitle:@"途中で解雇" message:@"解雇されました。" done:@"OK" viewController:self];
                                       } else if([status isEqualToString:@"0"]){
                                           
                                           [MDUtil makeAlertWithTitle:@"審査中" message:@"審査中で、お待ちください。" done:@"OK" viewController:self];
                                           
                                       } else {
                                           MDUser *user = [MDUser getInstance];
                                           user.password = password;
                                           user.userHash = [completeOperation responseJSON][@"hash"];
                                           [user setData:[completeOperation responseJSON][@"data"]];
                                           
                                           [[MDUser getInstance] setLogin];
                                           //send token
                                           [self sendToken];
                                           
                                           [self saveUserToDB];
                                           
                                           MDDeliveryViewController *deliveryViewController = [[MDDeliveryViewController alloc]init];
                                           UINavigationController *deliveryNavigationController = [[UINavigationController alloc]initWithRootViewController:deliveryViewController];
                                           [[MDUser getInstance] setLogin];
                                           [self presentViewController:deliveryNavigationController animated:YES completion:nil];
                                           
                                       }
                                       
                                   } else if([[completeOperation responseJSON][@"code"] integerValue] == 2){
                                    
                                       [MDUtil makeAlertWithTitle:@"不正番号" message:@"パスワードは正しくありません。" done:@"OK" viewController:self];
                                   }
                                   
                               } onError:^(MKNetworkOperation *completeOperarion, NSError *error){
                                   NSLog(@"error --------------  %@", error);
                                   [SVProgressHUD dismiss];
                               }];
    } else {
        [MDUtil makeAlertWithTitle:@"不正番号" message:@"入力した番号が正しくありません。" done:@"OK" viewController:self];
    }
}
-(void) backButtonTouched {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) sendToken{
    [[MDAPI sharedAPI] changeProfileByUser:[MDUser getInstance]
                                onComplete:^(MKNetworkOperation *complete) {
                                    //
                                } onError:^(MKNetworkOperation *operation, NSError *error) {
                                    //token error
                                }];
}

-(void) saveUserToDB {
    [[NSFileManager defaultManager] removeItemAtPath:[RLMRealm defaultRealmPath] error:nil];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    MDConsignor *consignor = [[MDConsignor alloc]init];
    consignor.userid = [NSString stringWithFormat:@"%lu",(unsigned long)[MDUser getInstance].user_id];
    consignor.password = [MDUser getInstance].password;
    consignor.phonenumber = [MDUtil internationalPhoneNumber:[MDUser getInstance].phoneNumber];
    
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:consignor];
    [realm commitWriteTransaction];
}

-(void) goJudgment{
    MDJudgmentViewController *jvc = [[MDJudgmentViewController alloc]init];
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:jvc animated:YES completion:nil];
}

@end
