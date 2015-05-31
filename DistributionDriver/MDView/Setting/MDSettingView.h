//
//  MDSettingView.h
//  Distribution
//
//  Created by Lsr on 3/27/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDSelect.h"
#import "MDTabButton.h"
#import "MDUser.h"

@protocol MDSettingViewDelegate;

@interface MDSettingView : UIView <UIScrollViewAccessibilityDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView  *scrollView;
@property (strong, nonatomic) UIView        *tabbar;

@property (nonatomic, assign) id<MDSettingViewDelegate> delegate;

-(void) setViewData:(MDUser *)user;
-(void) setRating:(int)star;
-(void) setNotificationCount:(int)count;

@end

@protocol MDSettingViewDelegate <NSObject>

@optional
-(void) notificationButtonPushed;
-(void) averageButtonPushed;
-(void) nameButtonPushed;
-(void) phoneNumberPushed;
-(void) blockDriverPushed;
-(void) aqButtonPushed;
-(void) privacyButtonPushed;
-(void) agreementButtonPushed;
-(void) gotoRequestView;
-(void) gotoDeliveryView;
-(void) profileImagePushed;
-(void) logoutButtonPushed;
-(void) gotoTansptationView;
-(void) introButtonPushed;
-(void) payButtonPushed;
-(void) privateButtonPushed;
-(void) protocolButtonPushed;

@end
