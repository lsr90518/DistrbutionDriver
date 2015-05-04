//
//  MDCreateProfileView.h
//  Distribution
//
//  Created by Lsr on 4/12/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDInput.h"
#import "MDSelect.h"
#import "MDButtonAndDescriptionView.h"
#import "MDKindButton.h"

@protocol CreateProfileViewDelegate;

@interface MDCreateProfileView : UIView<UIScrollViewAccessibilityDelegate,UIScrollViewDelegate, MDButtonAndDescriptionViewDelegate, MDInputDelegate>

@property (strong, nonatomic) UIScrollView  *scrollView;
@property (strong, nonatomic) MDInput       *lastnameInput;
@property (strong, nonatomic) MDInput       *givennameInput;
@property (strong, nonatomic) MDInput      *phoneButton;
@property (strong, nonatomic) MDInput       *passwordInput;
@property (strong, nonatomic) MDInput       *repeatInput;
@property (strong, nonatomic) MDButtonAndDescriptionView *personButtonAndDescription;
@property (strong, nonatomic) MDButtonAndDescriptionView *idCardButtonAndDescription;


@property (strong, nonatomic) UIButton      *postButton;

@property (assign, nonatomic) id<CreateProfileViewDelegate> delegate;

-(BOOL) isChecked;

@end

@protocol CreateProfileViewDelegate <NSObject>

@optional
-(void) postData:(MDCreateProfileView *)createProfileView;
-(void) scrollDidMove:(MDCreateProfileView *)createProfileView;
-(void) openCameraForView:(MDButtonAndDescriptionView *)view;
-(void) toggleButton:(MDKindButton *)button;

@end