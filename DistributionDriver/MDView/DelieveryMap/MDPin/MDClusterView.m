//
//  MDClusterView.m
//  DistributionDriver
//
//  Created by Lsr on 5/4/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDClusterView.h"

@implementation MDClusterView{
    UILabel *numberLabel;
}

-(id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if(self){
        self.backgroundColor = [UIColor clearColor];
        //大头针的图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-35, -35, 70, 70)];
        [imageView setImage:[UIImage imageNamed:@"numberFrom"]];
        [self addSubview:imageView];
        numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(-35, -35, 70, 70)];
        numberLabel.text = @"1";
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:numberLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
