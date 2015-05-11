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

@protocol MDRequestDetailViewDelegate;

@interface MDRequestDetailView : UIView<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView  *scrollView;
@property (strong, nonatomic) NSString      *process;
@property (strong, nonatomic) id<MDRequestDetailViewDelegate> delegate;

-(void) setStatus:(int) status;
-(void) makeupByData:(MDPackage *)data;
-(void) setClientData:(MDClient *)client;
-(UIImageView *) getUploadedImage;


@end

@protocol MDRequestDetailViewDelegate <NSObject>

@optional
-(void) cameraButtonPushed;
-(void) recieveButtonPushed;
-(void) phoneButtonPushed:(MDSelect*)select;
-(void) reviewButtonPushed;

@end