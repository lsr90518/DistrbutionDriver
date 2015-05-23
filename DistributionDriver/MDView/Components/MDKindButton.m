//
//  MDKindButton.m
//  DistributionDriver
//
//  Created by Lsr on 4/21/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDKindButton.h"

@implementation MDKindButton{
    CGRect buttonFrame;
    
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //make button
        buttonFrame = frame;
        [self setBackgroundColor:[UIColor whiteColor]];
        //color
        self.activeColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1];
        self.normalColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
        //frame
        self.buttonTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height/2+16.5, frame.size.width, 12)];
        self.buttonTitle.textAlignment = NSTextAlignmentCenter;
        self.buttonTitle.text = @"小包";
        self.buttonTitle.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:10];
        self.buttonTitle.textColor = self.normalColor;
        
        self.layer.cornerRadius = 1;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1].CGColor;
        
        
        [self addSubview:self.buttonTitle];
        

        //title
        _status = @"Off";
    }
    
    return self;
}

-(void) setIconImageByName:(NSString *)imageName {
    _imageName = imageName;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",_imageName, _status]];
    if (!self.iconImageView){
        self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width/2, image.size.height/2)];
    }
    
    self.iconImageView.center = CGPointMake(buttonFrame.size.width/2, buttonFrame.size.height/2-10);
    [self.iconImageView setImage:image];
    [self addSubview:self.iconImageView];
}

-(NSString *) toggleButton {
    _status = ([_status isEqualToString:@"Off"]) ? @"On" : @"Off";
    if([_status isEqualToString:@"Off"]){
        self.buttonTitle.textColor = self.normalColor;
    } else {
        self.buttonTitle.textColor = self.activeColor;
    }
    [self setIconImageByName:_imageName];
    return _status;
}



@end
