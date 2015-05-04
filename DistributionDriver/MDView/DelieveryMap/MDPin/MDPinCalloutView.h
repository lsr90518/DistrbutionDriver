//
//  MDPinCalloutView.h
//  DistributionDriver
//
//  Created by Lsr on 5/3/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDPackage.h"

@interface MDPinCalloutView : UIButton

@property (strong, nonatomic) UIImageView   *image;
@property (strong, nonatomic) UILabel       *sizeLabel;
@property (strong, nonatomic) UILabel       *rewardLabel;
@property (strong, nonatomic) UILabel       *toAddrLabel;
@property (strong, nonatomic) UILabel       *deliveryLimitLabel;
@property (strong, nonatomic) UILabel       *expireLabel;

-(void) setData:(MDPackage *)package;

@end
