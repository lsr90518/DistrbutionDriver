//
//  MDDeliveryTableViewCell.h
//  DistributionDriver
//
//  Created by 劉 松然 on 2015/05/07.
//  Copyright (c) 2015年 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDDeliveryTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *cargoImageView;
@property (strong, nonatomic) UILabel *statusLeft;
@property (strong, nonatomic) UILabel *statusRight;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UIImageView *rightArrow;

-(void) initCellWithData:(NSDictionary *)data;

@end
