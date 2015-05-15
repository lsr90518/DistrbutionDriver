//
//  MDBankSettingView.h
//  DistributionDriver
//
//  Created by Lsr on 5/12/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDInput.h"
#import "MDSelect.h"
#import "MDUtil.h"
#import "MDAPI.h"
#import "MDBankInfo.h"
#import "MDPicker.h"
#import "MDWell.h"

@protocol MDBankSettingViewDelegate;

@interface MDBankSettingView : UIView<MDInputDelegate, MDSelectDelegate, UIScrollViewDelegate, MDPickerDelegate>

@property (strong, nonatomic) MDInput *moneyInput;
@property (strong, nonatomic) MDWell  *descriptionWell;
@property (strong, nonatomic) MDInput *bankNumberInput;
@property (strong, nonatomic) UIButton *bankNumberSearchButton;
@property (strong, nonatomic) MDInput *branchNumberInput;
@property (strong, nonatomic) MDInput *accountNumberInput;
@property (strong, nonatomic) MDSelect *typeSelect;
@property (strong, nonatomic) MDInput *nameInput;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) MDWell  *nameDesWell;
@property (strong, nonatomic) UIButton *postButton;
@property (strong, nonatomic) MDPicker      *dataPicker;
@property (strong, nonatomic) NSString *status;


-(void) setViewData:(MDBankInfo *)bankInfo;
-(void) setMoney:(NSString *) money;

@property (strong, nonatomic) id<MDBankSettingViewDelegate> delegate;

@end

@protocol MDBankSettingViewDelegate <NSObject>

@optional
-(void) postViewData:(MDBankSettingView *)viewData;
-(void) bankNumberSearchButtonPushed;

@end