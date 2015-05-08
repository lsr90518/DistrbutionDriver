//
//  MDMapFilter.h
//  DistributionDriver
//
//  Created by Lsr on 5/7/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDSelect.h"
#import "MDInput.h"
#import "MDPicker.h"

@protocol MDMapFilterDelegate;

@interface MDMapFilter : UIView<UIScrollViewDelegate,MDInputDelegate,MDSelectDelegate,MDPickerDelegate>


@property (strong, nonatomic) UIScrollView  *scrollView;
@property (strong, nonatomic) MDPicker      *dataPicker;
@property (assign, nonatomic) id<MDMapFilterDelegate> delegate;

@end

@protocol MDMapFilterDelegate <NSObject>

@optional

@end
