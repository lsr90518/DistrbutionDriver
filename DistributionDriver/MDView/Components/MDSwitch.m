//
//  MDSwitch.m
//  DistributionDriver
//
//  Created by Lsr on 5/26/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDSwitch.h"

@implementation MDSwitch

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        //border
        self.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1].CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 2.5;
        
        //title
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(19, 18, 20, 14)];
        self.title.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:14];
        [self addSubview:self.title];
        
        
        //input
        self.switchInput = [[UISwitch alloc]initWithFrame:CGRectMake(frame.size.width-60, 11, 40, 27)];
        self.switchInput.onTintColor = [UIColor colorWithRed:226.0/255.0 green:138.0/255.0 blue:0 alpha:1];
        [self addSubview:_switchInput];
        
    }
    
    return self;
}

@end
