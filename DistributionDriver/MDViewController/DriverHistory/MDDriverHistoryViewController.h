//
//  MDDriverHistoryViewController.h
//  DistributionDriver
//
//  Created by Lsr on 5/10/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDMyPackageService.h"
#import "MDReview.h"
#import "MDReviewWell.h"

@interface MDDriverHistoryViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *reviews;

@end
