//
//  MDRequestDetailView.h
//  Distribution
//
//  Created by Lsr on 4/19/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDPackage.h"
#import "MDSelect.h"
#import "MDClient.h"
#import "MDAddressButton.h"

@protocol MDRequestDetailViewDelegate;

@interface MDRequestDetailView : UIView<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView  *scrollView;
@property (strong, nonatomic) NSString      *process;
@property (strong, nonatomic) id<MDRequestDetailViewDelegate> delegate;
@property (strong, nonatomic) MDPackage     *package;
@property (strong, nonatomic) MDClient      *client;

-(void) setStatus:(int) status;
-(void) makeupByData:(MDPackage *)data;
-(void) setClientData:(MDClient *)client;
-(UIImageView *) getUploadedImage;
-(void) setDriverReviewContent:(MDReview *)review;

-(void) seeCancelPackage:(MDPackage *)package;

-(void) setReviewContent:(MDReview *)review;

@end

@protocol MDRequestDetailViewDelegate <NSObject>

@optional
-(void) cameraButtonPushed;
-(void) reviewButtonPushed;
-(void) profileButtonPushed;
-(void) sizeDescriptionButtonPushed;
-(void) matchButtonPushed:(MDSelect *)button;
-(void) cancelButtonPushed;
-(void) addressButtonPushed:(MDAddressButton *)button;
-(void) recieveButtonPushed;
-(void) takeButtonPushed:(UIButton *)button;

@end