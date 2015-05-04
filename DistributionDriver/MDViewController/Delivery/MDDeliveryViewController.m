//
//  MDDeliveryViewController.m
//  Distribution
//
//  Created by Lsr on 3/27/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDDeliveryViewController.h"
#import "MDRequestViewController.h"
#import "MDRequestDetailViewController.h"
#import "MDSettingViewController.h"
#import "MDMapFilterViewController.h"
#import "MDPackageService.h"
#import <SVProgressHUD.h>
#import "MDPin.h"
#import "MDPinCalloutView.h"
#import "MDPinCallout.h"
#import "MDClusterView.h";


@interface MDDeliveryViewController () {
    NSMutableArray *annotations;
    MDPinCalloutView *infoWindow;
    MKAnnotationView *currentAnnotationView;
    BOOL isSelected;
    BOOL isMoved;
}

@end

@implementation MDDeliveryViewController

-(void)loadView{
    [super loadView];
    [self initNavigationBar];
    
    [self.view addSubview:_deliveryView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _mapView = [[MKMapView alloc]initWithFrame:self.view.frame];
    
    [self.view addSubview:_mapView];
    
    //tab bar button
    _tabbar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    //tab bar shadow
    UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
    [shadowView setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1]];
    [_tabbar addSubview:shadowView];
    
    for (int i = 0; i < 3; i++) {
        MDTabButton *tabButton = [[MDTabButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width / 3) * i, 0.5, ([UIScreen mainScreen].bounds.size.width / 3), 49.5) withTabType:i];
        if (i == 1) {
            [tabButton setButtonImage:YES];
        } else {
            [tabButton setButtonImage:NO];
        }
        [tabButton addTarget:self action:@selector(changeTab:) forControlEvents:UIControlEventTouchDown];
        [_tabbar addSubview:tabButton];
    }
    [self.view addSubview:_tabbar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void) viewDidAppear:(BOOL)animated{
    [SVProgressHUD show];
    [[MDAPI sharedAPI]getWaitingPackageWithHash:[MDUser getInstance].userHash
                                     OnComplete:^(MKNetworkOperation *completeOperation){
                                         [[MDPackageService getInstance] initDataWithArray:[completeOperation responseJSON][@"Packages"]];
                                         [self putPackageIntoMap];
                                         [_mapView addAnnotations:annotations];
                                         [SVProgressHUD dismiss];
                                     }onError:^(MKNetworkOperation *operation, NSError *error) {
                                         
                                     }];
    isSelected = false;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self configMap];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mapDelegate
-(void) configMap{
    _mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    
    
    
    _mapView.showsUserLocation = YES;
    [_mapView setMapType:MKMapTypeStandard];
    [_mapView setZoomEnabled:YES];
    [_mapView setScrollEnabled:YES];
    [_mapView setUserTrackingMode:MKUserTrackingModeNone];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    
    // Start heading updates.
    if ([CLLocationManager headingAvailable]) {
        NSLog(@"available");
        self.locationManager.headingFilter = 5;
        [self.locationManager startUpdatingHeading];
    }
    
    //View Area
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 4000, 4000);
        region.center.latitude = self.locationManager.location.coordinate.latitude;
        region.center.longitude = self.locationManager.location.coordinate.longitude;
        region.span.longitudeDelta = 0.05f;
        region.span.longitudeDelta = 0.05f;
    [self.mapView setRegion:region animated:YES];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    
}

#pragma device location
- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceLat {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
}
- (NSString *)deviceLon {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceAlt {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.altitude];
}



//自定义大头针
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    // 判断annotation的类型
    if (![annotation isKindOfClass:[MDPin class]]) return nil;
    
    // 创建MKAnnotationView
    static NSString *ID = @"transy";
    MKAnnotationView *annoView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MDClusterView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        annoView.canShowCallout = NO;
    }
    // 传递模型数据
    annoView.annotation = annotation;
    
    
//    // 设置图片
//    MDPin *pin = annotation;
//    if([pin.packageType isEqualToString:@"from"]){
//        annoView.image = [UIImage imageNamed:@"pinFrom"];
//    } else {
//        annoView.image = [UIImage imageNamed:@"pinTo"];
//    }
//    
    return annoView;
}

//把大头针放在地图上
-(void)putPackageIntoMap{
    if(annotations == nil){
        annotations = [[NSMutableArray alloc] init];
    }
    [annotations removeAllObjects];
    NSMutableArray *packageList = [MDPackageService getInstance].packageList;
    
    
    for (MDPackage *package in packageList) {
        
        //from pin
        NSString *from_lat = package.from_lat;
        NSString *from_lng = package.from_lng;
        //Create coordinates from the latitude and longitude values
        CLLocationCoordinate2D coord;
        coord.latitude = from_lat.doubleValue;
        coord.longitude = from_lng.doubleValue;
        MDPin *from_annotation = [[MDPin alloc]initWithCoordinates:coord title:@"" subTitle:@"" type:@"from"];
        from_annotation.package = package;
        
        //to pin
        NSString *to_lat = package.to_lat;
        NSString *to_lng = package.to_lng;
        //Create coordinates from the latitude and longitude values
        CLLocationCoordinate2D to_coord;
        to_coord.latitude = to_lat.doubleValue;
        to_coord.longitude = to_lng.doubleValue;
        MDPin *to_annotation = [[MDPin alloc] initWithCoordinates:to_coord title:@"" subTitle:@"" type:@"to"];
        to_annotation.package = package;
        
        [annotations addObject:from_annotation];
        [annotations addObject:to_annotation];
    }
}


//点击大头针
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    NSLog(@"クリックした");
    currentAnnotationView = view;

    MDPin *tmpView = (MDPin *)view.annotation;
    if(![view.annotation isKindOfClass:[MKUserLocation class]]) {
        
        isSelected = true;
    }
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(tmpView.coordinate, 4000, 4000);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MDPinCallout *)view{
    [infoWindow removeFromSuperview];
    isSelected = false;
    isMoved = false;
}

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    if(isSelected && isMoved){
        isSelected = false;
    }
    [infoWindow removeFromSuperview];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{

    MDPin *currentPin = currentAnnotationView.annotation;
    if(isSelected){
        isMoved = true;
        CGSize  calloutSize = CGSizeMake(self.view.frame.size.width - 30, 166);
        infoWindow = [[MDPinCalloutView alloc] initWithFrame:CGRectMake(15, 121, calloutSize.width, calloutSize.height)];
        [infoWindow setData:currentPin.package];
        [infoWindow addTarget:self action:@selector(seeDetail) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:infoWindow];
    }
    
    NSSet *nearbySet = [self.mapView annotationsInMapRect:self.mapView.visibleMapRect];
    NSLog(@"%f,  %f", mapView.centerCoordinate.latitude , mapView.centerCoordinate.longitude);
    NSLog(@"%@", nearbySet);
}


-(void) seeDetail{
    //currentPin.package;
    MDPin *currentPin = currentAnnotationView.annotation;
    MDRequestDetailViewController *rdvc = [[MDRequestDetailViewController alloc]init];
    rdvc.package = currentPin.package;
    [self.navigationController pushViewController:rdvc animated:YES];
    
}


-(void) initNavigationBar {
    self.navigationItem.title = @"配送の依頼";
    //add right button item
    UIButton *_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setTitle:@"絞込" forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
    _backButton.frame = CGRectMake(0, 0, 25, 44);
    [_backButton addTarget:self action:@selector(gotoFilterView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = leftButton;
}

#pragma DeliveryDelegate
-(void) gotoFilterView{
    MDMapFilterViewController *mfvc = [[MDMapFilterViewController alloc]init];
    [self.navigationController pushViewController:mfvc animated:YES];
}


#pragma self action
-(void) postRequest {
    // 接下来做/packages/user/register
    
}

-(void) selectButtonTouched:(MDSelect *)select {
    
   
}

-(void)gotoRequestAddressView {
    MDInputRequestViewController *irvc = [[MDInputRequestViewController alloc]init];
    [self.navigationController pushViewController:irvc animated:YES];
}

-(void)gotoDestinationAddressView {
    MDInputDestinationViewController *dvc = [[MDInputDestinationViewController alloc]init];
    [self.navigationController pushViewController:dvc animated:YES];
}

-(void) gotoRequestView{
    MDRequestViewController *rvc = [[MDRequestViewController alloc]init];
    UINavigationController *rNavigationController = [[UINavigationController alloc]initWithRootViewController:rvc];
    [self presentViewController:rNavigationController animated:NO completion:nil];
}

-(void) gotoSettingView {
    MDSettingViewController *rvc = [[MDSettingViewController alloc]init];
    UINavigationController *rNavigationController = [[UINavigationController alloc]initWithRootViewController:rvc];
    [self presentViewController:rNavigationController animated:NO completion:nil];
}

-(void) changeTab:(MDTabButton *)button {
    switch (button.type) {
        case 0:
            [self gotoRequestView];
            break;
        case 2:
            [self gotoSettingView];
            break;
        default:
            break;
    }
}

@end
