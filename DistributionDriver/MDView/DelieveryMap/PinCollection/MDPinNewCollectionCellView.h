//
//  MDPinNewCollectionCellView.h
//  DistributionDriver
//
//  Created by Lsr on 5/27/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDPinCalloutView.h"

@protocol MDPinNewCollectionCellDelegate;

@interface MDPinNewCollectionCellView : UICollectionViewCell

@property (nonatomic) MDPinCalloutView *calloutView;
@property (nonatomic) MDPin *pin;

@property (assign, nonatomic) id<MDPinNewCollectionCellDelegate> delegate;

-(void) setCellData:(MDPin *)pin;

@end

@protocol MDPinNewCollectionCellDelegate <NSObject>

@optional
-(void) contentPushed:(MDPin*)pin;

@end