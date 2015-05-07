//
//  MDDeliveryTableView.h
//  DistributionDriver
//
//  Created by 劉 松然 on 2015/05/07.
//  Copyright (c) 2015年 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MDDeliveryTableViewDelegate;

@interface MDDeliveryTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) id<MDDeliveryTableViewDelegate> deliveryTableViewDelegate;

-(void) initWithArray:(NSArray *)array;

@end

@protocol MDDeliveryTableViewDelegate <NSObject>

@optional
-(void) didSelectedRowWithData:(NSDictionary *)data;

@end

