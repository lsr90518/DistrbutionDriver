//
//  MDRequestDetailViewController.h
//  Distribution
//
//  Created by Lsr on 4/19/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDRequestDetailView.h"
#import "MDPackage.h"

@interface MDRequestDetailViewController : UIViewController

@property (strong, nonatomic) MDRequestDetailView   *requestDetailView;
@property (strong, nonatomic) MDPackage             *package;

@end
