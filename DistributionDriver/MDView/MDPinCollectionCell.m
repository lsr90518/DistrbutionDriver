//
//  MDPinCollectionCellCollectionViewCell.m
//  DistributionDriver
//
//  Created by Lsr on 5/24/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDPinCollectionCell.h"

@implementation MDPinCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5.0;
        
        _calloutView = [[MDPinCollectionCellView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        [self.contentView addSubview:_calloutView];
        
        [_calloutView addTarget:self action:@selector(contentTouched) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void) setCellData:(MDPin *)pin{
    _pin = pin;
    [_calloutView setDataByPin:pin];
}

-(void) contentTouched{
    if([self.delegate respondsToSelector:@selector(contentPushed:)]){
        [self.delegate contentPushed:_pin];
    }
}


@end
