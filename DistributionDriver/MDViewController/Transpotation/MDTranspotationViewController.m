//
//  MDTranspotationViewController.m
//  DistributionDriver
//
//  Created by Lsr on 5/3/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDTranspotationViewController.h"
#import "MDTranspotation.h"
#import "MDUser.h"
#import <SVProgressHUD.h>
#import "MDAPI.h"

@interface MDTranspotationViewController (){
    MDTranspotation *transpotationView;
}

@end

@implementation MDTranspotationViewController

-(void) loadView{
    [super loadView];
    transpotationView = [[MDTranspotation alloc]initWithFrame:self.view.frame];
    [transpotationView initWithData:[MDUser getInstance]];
    [self.view addSubview:transpotationView];
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
-(void)initNavigationBar{
    //add right button item
    UIButton *_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setTitle:@"戻る" forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
    _backButton.frame = CGRectMake(0, 0, 25, 44);
    [_backButton addTarget:self action:@selector(backButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = leftButton;
}

-(void)backButtonPushed{
    //call api
    [SVProgressHUD showWithStatus:@"保存" maskType:SVProgressHUDMaskTypeClear];
    [[MDAPI sharedAPI] changeProfileByUser:[MDUser getInstance]
                                onComplete:^(MKNetworkOperation *complete) {
                                    [SVProgressHUD dismiss];
                                    if([[complete responseJSON][@"code"] intValue] == 0){
                                        
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }
                                }onError:^(MKNetworkOperation *operation, NSError *error) {
                                    NSLog(@"%@", error);
                                    [self.navigationController popViewControllerAnimated:YES];
                                }];
}

@end
