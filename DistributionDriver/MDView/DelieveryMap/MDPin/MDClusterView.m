//
//  MDClusterView.m
//  DistributionDriver
//
//  Created by Lsr on 5/4/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDClusterView.h"
#import "MDPin.h"
#import "MDPinCalloutView.h"

@implementation MDClusterView{
    UIImageView *imageView;
    UILabel *numberLabel;
    MDPinCalloutView *infoWindow;
}

-(id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if(self){
        self.backgroundColor = [UIColor clearColor];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-17, -17, 70, 70)];
        numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(-17, -17, 70, 70)];
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:imageView];
        [self addSubview:numberLabel];
    }
    return self;
}

-(void) updatePinAnnotationByType:(MDPin *)pin{
    [imageView setHidden:YES];
    [numberLabel setHidden:YES];
}

-(void) updateClusterAnnotationByType:(MDPin *)pin{
    if([pin.packageType isEqualToString:@"from"]){
        [imageView setImage:[UIImage imageNamed:@"numberFrom"]];
    } else {
        [imageView setImage:[UIImage imageNamed:@"numberTo"]];
    }
    [imageView setHidden:NO];
    [numberLabel setHidden:NO];
}

-(void) showInfo:(MDPackage*)package{
    CGSize  calloutSize = CGSizeMake(290, 166);
    
    infoWindow = [[MDPinCalloutView alloc] initWithFrame:CGRectMake(-126, -calloutSize.height-20, calloutSize.width, calloutSize.height)];
    infoWindow.tag = 100;
    [infoWindow addTarget:self action:@selector(seeInside) forControlEvents:UIControlEventTouchUpInside];
    [infoWindow setData:package];
    [self addSubview:infoWindow];
}

-(void) seeInside {
    NSLog(@"click");
}

-(void) hideInfo{
    [infoWindow removeFromSuperview];
}

-(void) setNumber:(NSInteger)number {
    numberLabel.text = [NSString stringWithFormat:@"%ld",(long)number];
}




@end
