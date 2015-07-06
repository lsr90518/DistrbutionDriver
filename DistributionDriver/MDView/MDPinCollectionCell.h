//
//  MDPinCollectionCellCollectionViewCell.h
//  DistributionDriver
//
//  Created by Lsr on 5/24/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDPinCollectionCellView.h"
#import "MDPackage.h"

@protocol MDPinCollectionCellDelegate;

@interface MDPinCollectionCell : UICollectionViewCell

@property (nonatomic) MDPinCollectionCellView *calloutView;
@property (assign, nonatomic) id<MDPinCollectionCellDelegate> delegate;
@property (nonatomic) MDPin *pin;

-(void) setCellData:(MDPin *)pin;

@end


@protocol MDPinCollectionCellDelegate <NSObject>

@optional
-(void) contentPushed:(MDPin*)pin;

@end
