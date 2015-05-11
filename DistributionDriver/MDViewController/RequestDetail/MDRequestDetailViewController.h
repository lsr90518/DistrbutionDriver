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
#import "MDClient.h"

@interface MDRequestDetailViewController : UIViewController<MDRequestDetailViewDelegate>

@property (strong, nonatomic) MDRequestDetailView   *requestDetailView;
@property (strong, nonatomic) MDPackage             *package;
@property (strong, nonatomic) MDClient              *client;

@end
