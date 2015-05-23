//
//  MDButtonAndDescriptionView.h
//  DistributionDriver
//
//  Created by Lsr on 4/22/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MDButtonAndDescriptionViewDelegate;

@interface MDButtonAndDescriptionView : UIView

@property (strong ,nonatomic) UIButton *iconButton;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel  *descriptionLabel;
@property (strong, nonatomic) UIView   *descriptionView;
@property (strong, nonatomic) NSString *buttonTitle;

@property (nonatomic, assign) id<MDButtonAndDescriptionViewDelegate> delegate;

-(void) setText:(NSString *)text;
-(void) setIcon:(UIImage  *)icon;
-(void) setDescriptionViewColor:(UIColor *)color;

-(void) setPicture:(UIImage *)picture;

-(BOOL) isHasPicture;

@end

@protocol MDButtonAndDescriptionViewDelegate <NSObject>

@optional
-(void) buttonPushed:(MDButtonAndDescriptionView *)view;

@end