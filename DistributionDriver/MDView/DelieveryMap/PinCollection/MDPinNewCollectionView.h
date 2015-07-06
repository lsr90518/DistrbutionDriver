//
//  MDPinNewCollectionView.h
//  DistributionDriver
//
//  Created by Lsr on 5/27/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDPinNewCollectionCellView.h"

@protocol MDPinNewCollectionViewDelegate;

@interface MDPinNewCollectionView : UIView<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MDPinNewCollectionCellDelegate>

@property (nonatomic) UICollectionView *collectionView;

@property (nonatomic) NSMutableArray *packageList;

@property (assign , nonatomic) id<MDPinNewCollectionViewDelegate> cellDelegate;

@end

@protocol MDPinNewCollectionViewDelegate <NSObject>

@optional
-(void) cellContentPushed:(MDPin *)pin;

@end
