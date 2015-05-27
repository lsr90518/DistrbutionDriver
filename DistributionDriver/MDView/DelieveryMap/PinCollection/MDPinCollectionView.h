//
//  MDPinCollectionView.h
//  DistributionDriver
//
//  Created by Lsr on 5/24/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDPinCollectionCell.h"

@protocol MDPinCollectionViewDelegate;

@interface MDPinCollectionView : UIView<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MDPinCollectionCellDelegate>

@property (nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) id<MDPinCollectionViewDelegate> cellDelegate;
@property (nonatomic) NSMutableArray *packageList;

@end


@protocol MDPinCollectionViewDelegate <NSObject>

@optional
-(void)cellContentPushed:(MDPin*) pin;

@end