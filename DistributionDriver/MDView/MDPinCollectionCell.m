//
//  MDPinCollectionCellCollectionViewCell.m
//  DistributionDriver
//
//  Created by Lsr on 5/24/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDPinCollectionCell.h"

@implementation MDPinCollectionCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // change to our custom selected background view
//        CustomCellBackground *backgroundView = [[CustomCellBackground alloc] initWithFrame:CGRectZero];
//        self.selectedBackgroundView = backgroundView;
        [self setBackgroundColor:[UIColor blueColor]];
    }
    return self;
}


@end
