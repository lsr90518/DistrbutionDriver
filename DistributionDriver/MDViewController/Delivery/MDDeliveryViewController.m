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
#import "MDClusterView.h"
#import "MDDeliveryListViewController.h"
#import "MDNotificationService.h"
#import "MDMyPackageService.h"
#import "MDUserLocationService.h"
#import "MDPinCollectionView.h"


@interface MDDeliveryViewController () {
    NSMutableArray *annotations;
    NSMutableArray *fromAnnotations;
    NSMutableArray *toAnnotations;
    MDPinCalloutView *infoWindow;
    MKAnnotationView *currentAnnotationView;
    MDUserLocationService *currentUesrLocation;
    MKCoordinateRegion currentUserRegion;
    NSString *currentPref;
    BOOL isSelected;
    BOOL isMoved;
    BOOL isTrack;
    BOOL isCluster;
    BOOL isShowHistory;
    
//    MDPinCollectionView *infoWindow;
    
    MDPackageService *packageService;
    MDMyPackageService *myPackageService;
    MDNotificationService *notificationService;
    
    
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
    
    //currentLocation
    UIButton *currentLocationButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 69, 40, 40)];
    [currentLocationButton setImage:[UIImage imageNamed:@"currentLocation"] forState:UIControlStateNormal];
    [currentLocationButton addTarget:self  action:@selector(moveToUserLocation) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    [self.view addSubview:currentLocationButton];
    
    isShowHistory = YES;
    
    //user location
    currentUesrLocation = [MDUserLocationService getInstance];
    //update lastest data
    [self updateMyPackageData];
    //update notification data
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _fromAnnotationsMapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    _toAnnotationsMapView = [[MKMapView alloc]initWithFrame:CGRectZero];
}
-(void) viewDidAppear:(BOOL)animated{
    isSelected = NO;
}

-(void) getCurrentPref:(MKUserLocation *)userLocation{
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             //获取城市
             currentPref = placemark.administrativeArea;
             [self loadDataByPref:currentPref location:userLocation.location];
             [SVProgressHUD dismiss];
         }
     }];
    
}

-(void) loadDataByPref:(NSString *)pref
              location:(CLLocation *)location{
    
    [SVProgressHUD show];
    
    [[MDAPI sharedAPI]getWaitingPackageWithHash:[MDUser getInstance].userHash
                                       WithPref:@"東京都"
                                     OnComplete:^(MKNetworkOperation *completeOperation){
                                         //call api
                                         [[MDPackageService getInstance] initDataWithArray:[completeOperation responseJSON][@"Packages"]
                                                                               WithDistance:(CLLocation *)location];
                                         
                                         //put pin
                                         [self putPackageIntoMap];
                                         [_mapView addAnnotations:annotations];

                                         [_fromAnnotationsMapView addAnnotations:fromAnnotations];
                                         [_toAnnotationsMapView addAnnotations:toAnnotations];
                                         [self updateVisibleAnnotations];


                                         [SVProgressHUD dismiss];
                                     }onError:^(MKNetworkOperation *operation, NSError *error) {
                                         
                                         NSLog(@"%@", [operation responseJSON]);
                                     }];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self configMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)updateVisibleAnnotations {
    
    static float marginFactor = 1.8;
    
    static float bucketSize = 60.0;
    
    // find all the annotations in the visible area + a wide margin to avoid popping annotation views in and out while panning the map.
    MKMapRect visibleMapRect = [self.mapView visibleMapRect];
    MKMapRect adjustedVisibleMapRect = MKMapRectInset(visibleMapRect, -marginFactor * visibleMapRect.size.width, -marginFactor * visibleMapRect.size.height);
    
    // determine how wide each bucket will be, as a MKMapRect square
    CLLocationCoordinate2D leftCoordinate = [self.mapView convertPoint:CGPointZero toCoordinateFromView:self.view];
    CLLocationCoordinate2D rightCoordinate = [self.mapView convertPoint:CGPointMake(bucketSize, 0) toCoordinateFromView:self.view];
    double gridSize = MKMapPointForCoordinate(rightCoordinate).x - MKMapPointForCoordinate(leftCoordinate).x;
    MKMapRect gridMapRect = MKMapRectMake(0, 0, gridSize, gridSize);
    
    // condense annotations, with a padding of two squares, around the visibleMapRect
    double startX = floor(MKMapRectGetMinX(adjustedVisibleMapRect) / gridSize) * gridSize;
    double startY = floor(MKMapRectGetMinY(adjustedVisibleMapRect) / gridSize) * gridSize;
    double endX = floor(MKMapRectGetMaxX(adjustedVisibleMapRect) / gridSize) * gridSize;
    double endY = floor(MKMapRectGetMaxY(adjustedVisibleMapRect) / gridSize) * gridSize;
    
    // for each square in our grid, pick one annotation to show
    gridMapRect.origin.y = startY;
    while (MKMapRectGetMinY(gridMapRect) <= endY) {
        gridMapRect.origin.x = startX;
        
        while (MKMapRectGetMinX(gridMapRect) <= endX) {
            NSSet *allAnnotationsInBucket = [self.fromAnnotationsMapView annotationsInMapRect:gridMapRect];
            NSSet *visibleAnnotationsInBucket = [self.mapView annotationsInMapRect:gridMapRect];
            
            // we only care about PhotoAnnotations
            NSMutableSet *filteredAnnotationsInBucket = [[allAnnotationsInBucket objectsPassingTest:^BOOL(id obj, BOOL *stop) {
                return ([obj isKindOfClass:[MDPin class]]);
            }] mutableCopy];
            
            if (filteredAnnotationsInBucket.count > 0) {
                MDPin *annotationForGrid = (MDPin *)[self annotationInGrid:gridMapRect usingAnnotations:filteredAnnotationsInBucket];
//
                [filteredAnnotationsInBucket removeObject:annotationForGrid];
//
//                // give the annotationForGrid a reference to all the annotations it will represent
                annotationForGrid.containedAnnotations = [filteredAnnotationsInBucket allObjects];
//
                [self.mapView addAnnotation:annotationForGrid];
//
                for (MDPin *annotation in filteredAnnotationsInBucket) {
                    // give all the other annotations a reference to the one which is representing them
                    annotation.clusterAnnotation = annotationForGrid;
                    annotation.containedAnnotations = nil;
                    
                    // remove annotations which we've decided to cluster
                    if ([visibleAnnotationsInBucket containsObject:annotation]) {
                        CLLocationCoordinate2D actualCoordinate = annotation.coordinate;
                        annotation.coordinate = annotation.clusterAnnotation.coordinate;
                        annotation.coordinate = actualCoordinate;
                        [self.mapView removeAnnotation:annotation];
                    }
                }
            }
            
            gridMapRect.origin.x += gridSize;
        }
        
        gridMapRect.origin.y += gridSize;
    }
}

- (id<MKAnnotation>)annotationInGrid:(MKMapRect)gridMapRect usingAnnotations:(NSSet *)annotations {
    
    // first, see if one of the annotations we were already showing is in this mapRect
    NSSet *visibleAnnotationsInBucket = [self.mapView annotationsInMapRect:gridMapRect];
    NSSet *annotationsForGridSet = [annotations objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        BOOL returnValue = ([visibleAnnotationsInBucket containsObject:obj]);
        if (returnValue)
        {
            *stop = YES;
        }
        return returnValue;
    }];
    
    if (annotationsForGridSet.count != 0) {
        return [annotationsForGridSet anyObject];
    }
    
    // otherwise, sort the annotations based on their distance from the center of the grid square,
    // then choose the one closest to the center to show
    MKMapPoint centerMapPoint = MKMapPointMake(MKMapRectGetMidX(gridMapRect), MKMapRectGetMidY(gridMapRect));
    NSArray *sortedAnnotations = [[annotations allObjects] sortedArrayUsingComparator:^(id obj1, id obj2) {
        MKMapPoint mapPoint1 = MKMapPointForCoordinate(((id<MKAnnotation>)obj1).coordinate);
        MKMapPoint mapPoint2 = MKMapPointForCoordinate(((id<MKAnnotation>)obj2).coordinate);
        
        CLLocationDistance distance1 = MKMetersBetweenMapPoints(mapPoint1, centerMapPoint);
        CLLocationDistance distance2 = MKMetersBetweenMapPoints(mapPoint2, centerMapPoint);
        
        
        if (distance1 < distance2) {
            return NSOrderedAscending;
        } else if (distance1 > distance2) {
            return NSOrderedDescending;
        }
        
        return NSOrderedSame;
    }];
    
    return sortedAnnotations[0];
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
    [_mapView setRotateEnabled:NO];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    
    // Start heading updates.
    if ([CLLocationManager headingAvailable]) {
        self.locationManager.headingFilter = 5;
        [self.locationManager startUpdatingHeading];
    }
    
    //View Area
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 2000, 2000);
        region.center.latitude = self.locationManager.location.coordinate.latitude;
        region.center.longitude = self.locationManager.location.coordinate.longitude;
    [self.mapView setRegion:region animated:YES];
    isTrack = YES;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //跟踪用户
    if(isTrack){
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 4000, 4000);
        [self.mapView setRegion:region animated:YES];
        isTrack = NO;
        [self getCurrentPref:userLocation];
        //loadData
        //
    }
    [MDUserLocationService getInstance].currentUserRegion = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 4000, 4000);
    [MDUserLocationService getInstance].userLocation = userLocation;
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
    
    static NSString *ID = @"transy";
    MDClusterView *annoView = (MDClusterView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    MDPin *pin = annotation;
    if (annoView == nil) {
        annoView = [[MDClusterView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        annoView.canShowCallout = NO;
    } else {
        [annoView updatePinAnnotationByType:pin];
        annoView.image = nil;
    }
    // 传递模型数据
    annoView.annotation = annotation;
    
    if([pin.containedAnnotations count] > 0){
        // 创建MKAnnotationView
        [annoView updateClusterAnnotationByType:pin];
    } else {
        [annoView updatePinAnnotationByType:pin];
        if([pin.packageType isEqualToString:@"from"]){
            //大头针的图片
            annoView.image = [UIImage imageNamed:@"pinFrom"];
            
        } else if([pin.packageType isEqualToString:@"from"]) {
            annoView.image = [UIImage imageNamed:@"pinTo"];
            
        } else if([pin.packageType isEqualToString:@"history-from"]){
            annoView.image = [UIImage imageNamed:@"pinFrom"];
            [annoView setAlpha:0.5];
        } else {
            annoView.image = [UIImage imageNamed:@"pinTo"];
            [annoView setAlpha:0.5];
        }
    }
    
    [annoView setNumber:[pin.containedAnnotations count]+1];
    
    
    return annoView;
}

//把大头针放在地图上
-(void)putPackageIntoMap{
    if(annotations == nil){
        annotations = [[NSMutableArray alloc] init];
        fromAnnotations = [[NSMutableArray alloc]init];
        toAnnotations = [[NSMutableArray alloc]init];
    }
    [_mapView removeAnnotations:annotations];
    [_fromAnnotationsMapView removeAnnotations:fromAnnotations];
    [_toAnnotationsMapView removeAnnotations:toAnnotations];
    [annotations removeAllObjects];
    [fromAnnotations removeAllObjects];
    [toAnnotations removeAllObjects];
    
    NSMutableArray *packageList = [[MDPackageService getInstance] getPackageListByPackage:[MDCurrentPackage getInstance]];
    
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
        [fromAnnotations addObject:from_annotation];
        [toAnnotations addObject:to_annotation];
    }
    
    if(isShowHistory){
        NSMutableArray *packageList = [[MDMyPackageService getInstance] packageList];
        
        for (MDPackage *package in packageList) {
            
            //from pin
            NSString *from_lat = package.from_lat;
            NSString *from_lng = package.from_lng;
            //Create coordinates from the latitude and longitude values
            CLLocationCoordinate2D coord;
            coord.latitude = from_lat.doubleValue;
            coord.longitude = from_lng.doubleValue;
            MDPin *from_annotation = [[MDPin alloc]initWithCoordinates:coord title:@"" subTitle:@"" type:@"history-from"];
            from_annotation.package = package;
            
            //to pin
            NSString *to_lat = package.to_lat;
            NSString *to_lng = package.to_lng;
            //Create coordinates from the latitude and longitude values
            CLLocationCoordinate2D to_coord;
            to_coord.latitude = to_lat.doubleValue;
            to_coord.longitude = to_lng.doubleValue;
            MDPin *to_annotation = [[MDPin alloc] initWithCoordinates:to_coord title:@"" subTitle:@"" type:@"history-to"];
            to_annotation.package = package;
            
            [annotations addObject:from_annotation];
            [annotations addObject:to_annotation];
            [fromAnnotations addObject:from_annotation];
            [toAnnotations addObject:to_annotation];
        }
    }
}


//点击大头针
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    currentAnnotationView = view;

    MDPin *tmpView = (MDPin *)view.annotation;
    if(![view.annotation isKindOfClass:[MKUserLocation class]]) {
        
        if([tmpView.containedAnnotations count] > 0){
            
//            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(tmpView.coordinate,
//                                                                           _mapView.region.span.latitudeDelta *300,
//                                                                           _mapView.region.span.longitudeDelta *300);
            //找到最大距离
            MKCoordinateRegion region = MKCoordinateRegionMake(tmpView.coordinate, _mapView.region.span);
            isCluster = YES;
            [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
        } else {
            
            if([tmpView.packageType isEqualToString:@"from"] || [tmpView.packageType isEqualToString:@"to"] || [tmpView.packageType isEqualToString:@"history-from"] || [tmpView.packageType isEqualToString:@"history-to"]){
                isSelected = YES;
                
                MKCoordinateRegion region = MKCoordinateRegionMake(tmpView.coordinate, _mapView.region.span);
                [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
                
            }
        }
    }

}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    
    isSelected = NO;
    isMoved = NO;
    isCluster = NO;
}

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    if(isSelected && isMoved){
        isSelected = NO;
    }
    [infoWindow removeFromSuperview];
//    [infoWindow removeFromSuperview];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{

    MDPin *currentPin = currentAnnotationView.annotation;
    if(isSelected && !isCluster){
            isMoved = YES;
            CGSize  calloutSize = CGSizeMake(self.view.frame.size.width - 30, 166);
            infoWindow = [[MDPinCalloutView alloc] initWithFrame:CGRectMake(15, 121, calloutSize.width, calloutSize.height)];
            [infoWindow setData:currentPin.package];
            [infoWindow addTarget:self action:@selector(seeDetail) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:infoWindow];
        
    } else {
        NSSet *visitableAnnotations = [mapView annotationsInMapRect:[mapView visibleMapRect]];
        [visitableAnnotations enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            if(![obj isKindOfClass:[MKUserLocation class]]){
                [mapView removeAnnotation:obj];
            }
        }];
        
        [visitableAnnotations enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            if(![obj isKindOfClass:[MKUserLocation class]]){
                [mapView addAnnotation:obj];
            }
        }];
        
        [self updateVisibleAnnotations];
        isCluster = NO;
    }
    
}

-(void)moveToUserLocation {
    [self.mapView setRegion:[MDUserLocationService getInstance].currentUserRegion animated:YES];
}


-(void) seeDetail{
    //currentPin.package;
    MDPin *currentPin = currentAnnotationView.annotation;
    MDRequestDetailViewController *rdvc = [[MDRequestDetailViewController alloc]init];
    rdvc.package = currentPin.package;
    [self.navigationController pushViewController:rdvc animated:YES];
    
}


-(void) initNavigationBar {
    self.navigationItem.title = @"依頼を探す";
    //add right button item
    UIButton *_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setTitle:@"表示" forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
    _backButton.frame = CGRectMake(0, 0, 25, 44);
    [_backButton addTarget:self action:@selector(gotoFilterView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //right button
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"リスト" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
    rightButton.frame = CGRectMake(0, 0, 37, 44);
    [rightButton addTarget:self action:@selector(gotoListView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

#pragma DeliveryDelegate
-(void) gotoFilterView{
    MDMapFilterViewController *mfvc = [[MDMapFilterViewController alloc]init];
    [self.navigationController pushViewController:mfvc animated:YES];
}

-(void) gotoListView{
    MDDeliveryListViewController *dlvc = [[MDDeliveryListViewController alloc]init];
    dlvc.pref = currentPref;
    [self.navigationController pushViewController:dlvc animated:YES];
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

-(void) updateMyPackageData {
    [[MDAPI sharedAPI] getMyPackageWithHash:[MDUser getInstance].userHash
                                 OnComplete:^(MKNetworkOperation *complete) {
                                     //
                                     myPackageService = [MDMyPackageService getInstance];
                                     [myPackageService initDataWithArray:[complete responseJSON][@"Packages"]];
                                     
                                 } onError:^(MKNetworkOperation *operation, NSError *error) {
                                     //
                                 }];

}

@end
