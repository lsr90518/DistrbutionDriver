//
//  MDReviewView.h
//  DistributionDriver
//
//  Created by 劉 松然 on 2015/05/08.
//  Copyright (c) 2015年 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDStarRatingBar.h"
#import "MDPackage.h"

@protocol MDReviewDelegate;

@interface MDReviewView : UIView<UIScrollViewDelegate,UITextViewDelegate>

@property (assign ,nonatomic) id<MDReviewDelegate> delegate;
@property (strong, nonatomic) NSString      *rating;
@property (strong, nonatomic) NSString      *reviewText;

@end

@protocol MDReviewDelegate <NSObject>

@optional
-(void) postButtonPushed:(MDReviewView*)reviewView;

@end
