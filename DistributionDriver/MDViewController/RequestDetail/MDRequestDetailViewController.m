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
#import "MDSelect.h"
#import "MDReviewViewController.h"

@interface MDRequestDetailViewController ()

@end

@implementation MDRequestDetailViewController

-(void) loadView {
    [super loadView];
    _requestDetailView = [[MDRequestDetailView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_requestDetailView];
    
    _requestDetailView.delegate = self;
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
    
    UIButton *_postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([_package.status intValue] == 1) {
        [_postButton setTitle:@"預かった" forState:UIControlStateNormal];
        _postButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
        _postButton.frame = CGRectMake(0, 0, 50, 44);
        [_postButton addTarget:self action:@selector(haveReceived) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:_postButton];
        self.navigationItem.rightBarButtonItem = rightBarButton;
        
    } else if ([_package.status intValue] == 2) {
        [_postButton setTitle:@"配達完了" forState:UIControlStateNormal];
        _postButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
        _postButton.frame = CGRectMake(0, 0, 50, 44);
        [_postButton addTarget:self action:@selector(haveDelivered) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:_postButton];
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavigationBar];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) backButtonPushed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) haveDelivered{
    //call api
    [SVProgressHUD show];
    [[MDAPI sharedAPI] deliveryPackageWithHash:[MDUser getInstance].userHash
                                     packageId:_package.package_id
                                    OnComplete:^(MKNetworkOperation *operation) {
                                        NSLog(@"%@", [operation responseJSON]);
                                      
                                        if([[operation responseJSON][@"code"] intValue] == 2){
                                            [MDUtil makeAlertWithTitle:@"不正番号" message:@"改めてログインしてください。" done:@"OK" viewController:self];
                                        } else {
                                            [SVProgressHUD showSuccessWithStatus:@"お疲れ様です。"];
                                            [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(goBack) name:SVProgressHUDDidDisappearNotification object: nil];
                                        }
                                      
                                    } onError:^(MKNetworkOperation *operation, NSError *error) {
                                      
                                    }];
}

-(void) haveReceived{
    //call api
    [SVProgressHUD show];
    [[MDAPI sharedAPI] receviePackageWithHash:[MDUser getInstance].userHash
                                   packageId:_package.package_id
                                  OnComplete:^(MKNetworkOperation *operation) {
                                      
                                      if([[operation responseJSON][@"code"] intValue] == 2){
                                          [MDUtil makeAlertWithTitle:@"不正番号" message:@"改めてログインしてください。" done:@"OK" viewController:self];
                                      } else {
                                          [SVProgressHUD showSuccessWithStatus:@"荷物預かりました。"];
                                          [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(goBack) name:SVProgressHUDDidDisappearNotification object: nil];
                                      }
                                      
                                  } onError:^(MKNetworkOperation *operation, NSError *error) {
                                      
                                  }];
}

-(void)recieveButtonPushed{
    [self reciveOrder];
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
                                          [SVProgressHUD showSuccessWithStatus:@"荷物を受けました。"];
                                          [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(goBack) name:SVProgressHUDDidDisappearNotification object: nil];

                                      }
                                      
                                  } onError:^(MKNetworkOperation *operation, NSError *error) {
    
                                  }];
}

-(void) goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) cameraButtonPushed {
    //open camera or カメラロール
    [self expendImage];
}

-(void) expendImage{
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView setImage:[_requestDetailView getUploadedImage].image];
    
    
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    
    [backgroundView addSubview:imageView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
        imageView.center = backgroundView.center;
        [self.view addSubview:backgroundView];
    } completion:^(BOOL finished) {
        
    }];
}
-(void)hideImage:(UITapGestureRecognizer*)tap{
    
    UIView *backgroundView=tap.view;
    [UIView animateWithDuration:0.3 animations:^{
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

-(void) phoneButtonPushed:(MDSelect*)select{
    NSString *phoneNum = select.selectLabel.text;// 电话号码
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

-(void) reviewButtonPushed{
    MDReviewViewController *rvc = [[MDReviewViewController alloc]init];
    rvc.package = _package;
    [self.navigationController pushViewController:rvc animated:YES];
    
}

@end
