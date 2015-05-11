//
//  MDHistoryCell.h
//  DistributionDriver
//
//  Created by Lsr on 5/10/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDReview.h"
#import "MDReviewWell.h"


@interface MDHistoryCell : UITableViewCell

-(void) setDataWithReview:(MDReview *)review;

@end
