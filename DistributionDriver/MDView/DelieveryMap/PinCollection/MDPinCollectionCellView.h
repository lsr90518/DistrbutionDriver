//
//  MDPinCollectionCellView.h
//  DistributionDriver
//
//  Created by Lsr on 5/27/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDPin.h"
#import <UIImageView+WebCache.h>
#import "MDStarRatingBar.h"

@interface MDPinCollectionCellView : UIButton

@property (strong, nonatomic) UIImageView   *image;
@property (strong, nonatomic) UILabel       *sizeLabel;
@property (strong, nonatomic) UILabel       *rewardLabel;
@property (strong, nonatomic) UILabel       *toAddrLabel;
@property (strong, nonatomic) UILabel       *deliveryLimitLabel;
@property (nonatomic) UILabel               *statusLabel;
@property (nonatomic) UILabel               *reviewLabel;
@property (nonatomic) MDStarRatingBar       *starBar;
@property (strong, nonatomic) UILabel       *expireLabel;
@property (nonatomic) UILabel               *overLabel;

-(void) setData:(MDPackage *)package;
-(void) setDataByPin:(MDPin *)pin;

@end
