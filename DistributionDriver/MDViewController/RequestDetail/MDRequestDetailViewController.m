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
#import "MDSizeDescriptionViewController.h"
#import "MDUserLocationService.h"

@interface MDRequestDetailViewController ()

@end

@implementation MDRequestDetailViewController

-(void) loadView {
    [super loadView];
    _requestDetailView = [[MDRequestDetailView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_requestDetailView];
    
    _requestDetailView.delegate = self;
    
    
}

-(void)initNavigationBar {
    NSString *number = [NSString stringWithFormat:@"%@",_package.package_number];
    int length = (int)number.length/2;
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
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void) viewWillAppear:(BOOL)animated{
    [self initNavigationBar];
    
    if([_package.user_id isEqual:[NSNull null]]){
        [_requestDetailView seeCancelPackage:_package];
        self.navigationItem.title = @"キャンセルされた荷物";
    } else {
        
        
        
        [self getUserData];
        
        [_requestDetailView makeupByData:_package];
        
        [_requestDetailView setStatus:[_package.status intValue]];
        
        NSString *driverReviewed = [NSString stringWithFormat:@"%@", _package.driverReview.reviewed];
        if([driverReviewed isEqualToString:@"1"]){
            [_requestDetailView setDriverReviewContent:_package.driverReview];
        }
        
        NSString *userReviewed = [NSString stringWithFormat:@"%@", _package.userReview.reviewed];
        if([userReviewed isEqualToString:@"1"] && [driverReviewed isEqualToString:@"1"]){
            [_requestDetailView setReviewContent:_package.userReview];
        }
    }
}

-(void) getUserData{
    
    //call api
    
    [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeClear];
    
    [[MDAPI sharedAPI] getUserDataWithHash:[MDUser getInstance].userHash
                                    userId:_package.user_id
                                  OnComplete:^(MKNetworkOperation *complete) {
                                      //
                                      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                          // time-consuming task
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [SVProgressHUD dismiss];
                                          });
                                      });
                                      
                                      _client = [[MDClient alloc]init];
                                      [_client initWithData:[complete responseJSON][@"User"]];
                                      [_requestDetailView setClientData:_client];
                                      
                                  } onError:^(MKNetworkOperation *operation, NSError *error) {
                                      
                                  }];
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
    
    //check region
    [SVProgressHUD show];
    [[MDAPI sharedAPI] acceptPackageWithHash:[MDUser getInstance].userHash
                                   packageId:_package.package_id
                                  OnComplete:^(MKNetworkOperation *operation) {
                                      
                                      if([[operation responseJSON][@"code"] intValue] == 3){
                                          [MDUtil makeAlertWithTitle:@"惜しい" message:@"他のドライバーに決まられた。" done:@"OK" viewController:self];
                                      } else if([[operation responseJSON][@"code"] intValue] == 2){
                                          [MDUtil makeAlertWithTitle:@"不正番号" message:@"改めてログインしてください。" done:@"OK" viewController:self];
                                      } else if([[operation responseJSON][@"code"] intValue] == 4){
                                          [MDUtil makeAlertWithTitle:@"評価による制限" message:@"過去の評価による制限で同時受領件数のため荷物が受けられません" done:@"OK" viewController:self];
                                      } else {
                                          [SVProgressHUD showSuccessWithStatus:@"荷物を受けました。"];
                                          [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(goRoot) name:SVProgressHUDDidDisappearNotification object: nil];
                                          
                                      }
                                      
                                  } onError:^(MKNetworkOperation *operation, NSError *error) {
                                      
                                  }];
    [SVProgressHUD dismiss];
    
//    // 获取当前所在的城市名
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    //根据经纬度反向地理编译出地址信息
//    [geocoder reverseGeocodeLocation:[MDUserLocationService getInstance].userLocation.location completionHandler:^(NSArray *array, NSError *error)
//     {
//         if (array.count > 0)
//         {
//             CLPlacemark *placemark = [array objectAtIndex:0];
//             
//             //获取城市
//             NSString *currentPref = placemark.administrativeArea;
//             
//             if([currentPref isEqualToString:@"東京都"]){
//                 //call api
//
//                 [[MDAPI sharedAPI] acceptPackageWithHash:[MDUser getInstance].userHash
//                                                packageId:_package.package_id
//                                               OnComplete:^(MKNetworkOperation *operation) {
//                                                   
//                                                   if([[operation responseJSON][@"code"] intValue] == 3){
//                                                       [MDUtil makeAlertWithTitle:@"惜しい" message:@"他のドライバーに決まられた。" done:@"OK" viewController:self];
//                                                   } else if([[operation responseJSON][@"code"] intValue] == 2){
//                                                       [MDUtil makeAlertWithTitle:@"不正番号" message:@"改めてログインしてください。" done:@"OK" viewController:self];
//                                                   } else if([[operation responseJSON][@"code"] intValue] == 4){
//                                                       [MDUtil makeAlertWithTitle:@"評価による制限" message:@"過去の評価による制限で同時受領件数のため荷物が受けられません" done:@"OK" viewController:self];
//                                                   } else {
//                                                       [SVProgressHUD showSuccessWithStatus:@"荷物を受けました。"];
//                                                       [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(goRoot) name:SVProgressHUDDidDisappearNotification object: nil];
//                                                       
//                                                   }
//                                                   
//                                               } onError:^(MKNetworkOperation *operation, NSError *error) {
//                                                   
//                                               }];
//                 [SVProgressHUD dismiss];
//             } else {
//                 [MDUtil makeAlertWithTitle:@"地域制限" message:@"申し訳ございません。現在は、預かり先、お届け先ともに東京都23区のみのテストリリースとなっております。ご指定のエリアは、開放されるまで今しばらくお待ちください。" done:@"OK" viewController:self];
//             }
//
//             
//         }
//     }];
}

-(void) goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) goRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
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

-(void) reviewButtonPushed{
    MDReviewViewController *rvc = [[MDReviewViewController alloc]init];
    rvc.package = _package;
    [self.navigationController pushViewController:rvc animated:YES];
    
}

-(void) sizeDescriptionButtonPushed{
    MDSizeDescriptionViewController *sdvc = [[MDSizeDescriptionViewController alloc]init];
    [self.navigationController pushViewController:sdvc animated:YES];
}

-(void)matchButtonPushed:(MDSelect *)button{
    [self callNumber:button];
}

-(void) cancelButtonPushed{
    
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"依頼のキャンセル"    //标题
                                                  message:@"依頼をキャンセルすると自動的に星1がつきますが、よろしいでしょうか。"   //显示内容
                                                 delegate:self          //委托，可以点击事件进行处理
                                        cancelButtonTitle:@"いいえ"
                                        otherButtonTitles:@"はい",nil];
     [view show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self cancelPackage];
            break;
        default:
            break;
    }
}

-(void) cancelPackage{
    [SVProgressHUD show];
    //call api
    [[MDAPI sharedAPI] cancelMyPackageWithHash:[MDUser getInstance].userHash
                                     packageId:_package.package_id
                                    OnComplete:^(MKNetworkOperation *complete) {
                                        //
                                        [SVProgressHUD dismiss];
                                        NSLog(@"%@", [complete responseJSON]);
                                        if([[complete responseJSON][@"code"] intValue] == 0){
                                            [self backButtonPushed];
                                        }
                                    } onError:^(MKNetworkOperation *operation, NSError *error) {
                                        //
                                    }];
}

-(void) addressButtonPushed:(MDAddressButton *)button{
    // URL encode the spaces
    NSString *addressText =  [button.addressField.text stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    //apple map
    NSString* urlText = [NSString stringWithFormat:@"http://maps.apple.com/maps?q=%@",addressText];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
}

-(void) callNumber:(MDSelect *)button{
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", button.selectLabel.text]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [self.view addSubview:callWebview];
}

-(void) takeButtonPushed:(UIButton *)button{
    if(button.tag == 1){
        [self haveReceived];
    } else if(button.tag == 2){
        [self haveDelivered];
    } else if(button.tag == 3){
        [self reviewButtonPushed];
    }
}


@end
