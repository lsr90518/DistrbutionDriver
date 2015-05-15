//
//  MDDeliveryListViewController.h
//  DistributionDriver
//
//  Created by 劉 松然 on 2015/05/07.
//  Copyright (c) 2015年 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDAPI.h"
#import <SVProgressHUD.h>
#import "MDDeliveryListView.h"

@interface MDDeliveryListViewController : UIViewController<MDDeliveryListViewDelegate>

@property (strong, nonatomic) MDDeliveryListView *listView;

@property (strong, nonatomic) NSString                  *pref;

@end
