//
//  MDPackageService.m
//  DistributionDriver
//
//  Created by Lsr on 5/2/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDPackageService.h"

@implementation MDPackageService

+(MDPackageService *)getInstance {
    
    static MDPackageService *sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[MDPackageService alloc] init];
    });
    return sharedInstance;
}

-(void) initData{
    if(_packageList == nil){
        _packageList = [[NSMutableArray alloc]init];
    }
}

-(void) initDataWithArray:(NSArray *)array{
    if(_packageList == nil){
        _packageList = [[NSMutableArray alloc]init];
    } else {
        [_packageList removeAllObjects];
    }
    
    for (int i = 0;i < array.count;i++) {
        NSString *image = [array objectAtIndex:i][@"image"];
        if(![image isEqual:[NSNull null]]){
            MDPackage *tmpPackage = [[MDPackage alloc]initWithData:[array objectAtIndex:i]];
            [_packageList addObject:tmpPackage];
        }
    }
}

-(void) initDataWithArray:(NSArray *)array
             WithDistance:(CLLocation *)location{
    if(_packageList == nil){
        _packageList = [[NSMutableArray alloc]init];
    } else {
        [_packageList removeAllObjects];
    }
    
    NSMutableArray *tmpList = [[NSMutableArray alloc]init];
    
    for (int i = 0;i < array.count;i++) {
        NSString *image = [array objectAtIndex:i][@"image"];
        if(![image isEqual:[NSNull null]]){
            MDPackage *tmpPackage = [[MDPackage alloc]initWithData:[array objectAtIndex:i]];
            [tmpList addObject:tmpPackage];
        }
    }
    //sort
    MKMapPoint userLocation = MKMapPointForCoordinate(location.coordinate);
    
    [_packageList addObjectsFromArray:[tmpList sortedArrayUsingComparator:^NSComparisonResult(MDPackage* obj1, MDPackage* obj2) {
        //;
        CLLocationCoordinate2D location1 = CLLocationCoordinate2DMake([obj1.from_lat floatValue], [obj1.from_lng floatValue]);
        MKMapPoint mapPoint1 = MKMapPointForCoordinate(location1);
        CLLocationCoordinate2D location2 = CLLocationCoordinate2DMake([obj2.from_lat floatValue], [obj2.from_lng floatValue]);
        MKMapPoint mapPoint2 = MKMapPointForCoordinate(location2);
        CLLocationDistance distance1 = MKMetersBetweenMapPoints(mapPoint1, userLocation);
        obj1.distance = [NSString stringWithFormat:@"%d",(int)distance1];
        CLLocationDistance distance2 = MKMetersBetweenMapPoints(mapPoint2, userLocation);
        obj2.distance = [NSString stringWithFormat:@"%d", (int)distance2];
        
        if(distance1 > distance2){
            return (NSComparisonResult)NSOrderedDescending;
        } else {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
    }]];
}

-(NSMutableArray *)getPackageListByPackage:(MDCurrentPackage *)package{
    NSMutableArray *tmpPackageList = [[NSMutableArray alloc]init];
    [_packageList enumerateObjectsUsingBlock:^(MDPackage *obj, NSUInteger idx, BOOL *stop) {
        //
        int flag = 0;
        if([obj.request_amount intValue] > [[MDCurrentPackage getInstance].request_amount intValue]){
            flag++;
        }
        if([obj.size intValue] < [[MDCurrentPackage getInstance].size intValue]){
            flag++;
        }
        if([obj.distance intValue] < [[MDCurrentPackage getInstance].distance intValue]){
            flag++;
        }
        NSDateFormatter *tmpFormatter = [[NSDateFormatter alloc]init];
        [tmpFormatter setLocale:[NSLocale systemLocale]];
        [tmpFormatter setDateFormat:@"YYYY-MM-dd HH:mm:00"];
        NSDate *currentPackageDate = [tmpFormatter dateFromString:[MDCurrentPackage getInstance].deliver_limit];
        NSDate *packageDate = [tmpFormatter dateFromString:obj.deliver_limit];
        
        NSTimeInterval time=[packageDate timeIntervalSinceDate:currentPackageDate];
        if(time > 0){
            flag++;
        }
        if(flag == 4){
            [tmpPackageList addObject:obj];
        }
    }];
    
    return tmpPackageList;
}

@end
