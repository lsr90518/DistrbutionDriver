//
//  MDLocalNotificationManager.m
//  DistributionDriver
//
//  Created by 各務 将士 on 2015/05/19.
//  Copyright (c) 2015年 Lsr. All rights reserved.
//

#import "MDLocalNotificationManager.h"

@implementation MDLocalNotificationManager
#pragma mark - Scheduler
- (void)scheduleLocalNotifications {
    // 一度通知を全てキャンセルする
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    // 通知を設定していく...
    [self schedulePackageWork];
}

- (void)schedulePackageWork {
    if(![MDUser getInstance].isLogin)return;
    // makeNotification: を呼び出して通知を登録する
    MDPackageService *packageService = [MDPackageService alloc];
    [[MDAPI sharedAPI] getMyPackageWithHash:[MDUser getInstance].userHash
                                 OnComplete:^(MKNetworkOperation *complete){
                                     if([[complete responseJSON][@"code"] integerValue] == 0){
                                         [packageService initDataWithArray:[complete responseJSON][@"Packages"] SortByDate:YES];
                                         for (MDPackage *package in packageService.packageList){
                                              // NSLog(@"deliver_limit: %@",[MDUtil getLocalDateTimeStrFromString:package.deliver_limit format:@"yyyy年MM月dd日 HH時mm分"]);
                                             if([package.status isEqualToString:@"2"] && ![package.deliver_limit isEqualToString:@""]){
                                                 NSDate *deliver_date = [MDUtil getLocalDateTimeFromString:package.deliver_limit utc:YES];
                                                 // 4時間前
                                                 [self makeNotification:[deliver_date initWithTimeInterval:-14400 sinceDate:deliver_date]
                                                              alertBody:@"お届け期限まで残り4時間です。急ぎお届け先まで荷物を配送して下さい。"
                                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys:package.package_id, @"package_id", nil]];
                                                 // 2時間前
                                                 [self makeNotification:[deliver_date initWithTimeInterval:-7200 sinceDate:deliver_date]
                                                              alertBody:@"お届け期限まで残り2時間です。急ぎお届け先まで荷物を配送して下さい。"
                                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys:package.package_id, @"package_id", nil]];
                                                 // 1時間前
                                                 [self makeNotification:[deliver_date initWithTimeInterval:-3600 sinceDate:deliver_date]
                                                              alertBody:@"お届け期限まで残り1時間です。急ぎお届け先まで荷物を配送して下さい。"
                                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys:package.package_id, @"package_id", nil]];
                                                 // 30分前
                                                 [self makeNotification:[deliver_date initWithTimeInterval:-1800 sinceDate:deliver_date]
                                                              alertBody:@"お届け期限まで残り30分です。急ぎお届け先まで荷物を配送して下さい。"
                                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys:package.package_id, @"package_id", nil]];
                                                 // 20分前
                                                 [self makeNotification:[deliver_date initWithTimeInterval:-1200 sinceDate:deliver_date]
                                                              alertBody:@"お届け期限まで残り20分です。急ぎお届け先まで荷物を配送して下さい。"
                                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys:package.package_id, @"package_id", nil]];
                                                 // 10分前
                                                 [self makeNotification:[deliver_date initWithTimeInterval:-600 sinceDate:deliver_date]
                                                              alertBody:@"お届け期限まで残り10分です。急ぎお届け先まで荷物を配送して下さい。"
                                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys:package.package_id, @"package_id", nil]];
                                                 // 0分前
                                                 [self makeNotification:deliver_date
                                                              alertBody:@"お届け期限を過ぎた荷物があります。重要なお知らせを確認してください。"
                                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys:package.package_id, @"package_id", nil]];
                                             }
                                             

                                             if([package.status isEqualToString:@"3"] && ![package.review_limit isEqualToString:@""] && [package.driverReview.star isEqualToString:@""]){
                                                 NSDate *review_date = [MDUtil getLocalDateTimeFromString:package.review_limit utc:YES];
                                                 // 3日前
                                                 [self makeNotification:[review_date initWithTimeInterval:-259200 sinceDate:review_date]
                                                              alertBody:@"荷物評価を3日以内にしてください。期限を過ぎると自動的に☆5となります。"
                                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys:package.package_id, @"package_id", nil]];
                                                 // 1日前
                                                 [self makeNotification:[review_date initWithTimeInterval:-86400 sinceDate:review_date]
                                                              alertBody:@"荷物評価を1日以内にしてください。期限を過ぎると自動的に☆5となります。"
                                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys:package.package_id, @"package_id", nil]];
                                                 // 3時間前
                                                 [self makeNotification:[review_date initWithTimeInterval:-10800 sinceDate:review_date]
                                                              alertBody:@"荷物評価を3時間以内にしてください。期限を過ぎると自動的に☆5となります。"
                                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys:package.package_id, @"package_id", nil]];
                                                 // 30分前
                                                 [self makeNotification:[review_date initWithTimeInterval:-1800 sinceDate:review_date]
                                                              alertBody:@"荷物評価を30分以内にしてください。期限を過ぎると自動的に☆5となります。"
                                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys:package.package_id, @"package_id", nil]];
                                             }

                                         }
                                     }
                                 }
                                    onError:^(MKNetworkOperation *complete, NSError *error){
                                        NSLog(@"error ------------------------ %@", error);
                                    }];
}

#pragma mark - helper
- (void)makeNotification:(NSDate *) fireDate alertBody:(NSString *) alertBody userInfo:(NSDictionary *) userInfo {
    // 現在より前の通知は設定しない
    if (fireDate == nil || [fireDate timeIntervalSinceNow] <= 0) {
        return;
    }
    [self schedule:fireDate alertBody:alertBody userInfo:userInfo];
}

- (void)schedule:(NSDate *) fireDate alertBody:(NSString *) alertBody userInfo:(NSDictionary *) userInfo {
    // ローカル通知を作成する
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    [notification setFireDate:fireDate];
    [notification setTimeZone:[NSTimeZone systemTimeZone]];
    [notification setAlertBody:alertBody];
    [notification setUserInfo:userInfo];
    [notification setSoundName:UILocalNotificationDefaultSoundName];
    [notification setAlertAction:@"Open"];
    [notification setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    NSLog(@"Setting LocalNotification: %@", fireDate);
}

@end
