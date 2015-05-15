//
//  MDDeliveryListView.h
//  DistributionDriver
//
//  Created by 劉 松然 on 2015/05/07.
//  Copyright (c) 2015年 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDDeliveryTableView.h"
#import "MDDeliveryTableViewCell.h"
#import "MDPackage.h"

@protocol MDDeliveryListViewDelegate;

@interface MDDeliveryListView : UIView<MDDeliveryTableViewDelegate>

@property (strong, nonatomic) MDDeliveryTableView       *deliveryTableView;
@property (nonatomic, assign) id<MDDeliveryListViewDelegate>   delegate;

-(void) initWithArray:(NSArray *)array;

@end

@protocol MDDeliveryListViewDelegate <NSObject>

@optional
-(void) gotoDeliveryView;
-(void) gotoSettingView;
-(void) makeUpData:(MDPackage *)data;

@end
