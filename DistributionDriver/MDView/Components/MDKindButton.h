//
//  MDKindButton.h
//  DistributionDriver
//
//  Created by Lsr on 4/21/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDKindButton : UIButton

@property (strong, nonatomic) UIImageView   *iconImageView;
@property (strong, nonatomic) UILabel       *buttonTitle;
@property (strong, nonatomic) UIColor       *activeColor;
@property (strong, nonatomic) UIColor       *normalColor;
@property (strong, nonatomic) NSString      *status;
@property (strong, nonatomic) NSString      *imageName;

-(void) setIconImageByName:(NSString *)imageName;
-(NSString *) toggleButton;

@end
