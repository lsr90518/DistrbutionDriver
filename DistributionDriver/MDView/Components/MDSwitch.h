//
//  MDSwitch.h
//  DistributionDriver
//
//  Created by Lsr on 5/26/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MDSwitchDelegate;

@interface MDSwitch : UIView

@property (strong, nonatomic) UILabel       *title;
@property (strong, nonatomic) UISwitch      *switchInput;

@end
