//
//  MDProfileViewController.h
//  DistributionDriver
//
//  Created by Lsr on 4/26/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDProfileView.h"
#import "MDUser.h"
#import "MDAPI.h"
#import "MDMyPackageService.h"
#import "MDDriver.h"

@interface MDProfileViewController : UIViewController<MDProfileViewDelegate>

@property (strong, nonatomic) MDProfileView *profileView;
@property (strong, nonatomic) MDDriver      *driver;

@end
