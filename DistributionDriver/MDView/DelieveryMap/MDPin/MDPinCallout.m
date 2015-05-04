//
//  MDPinCallout.m
//  DistributionDriver
//
//  Created by Lsr on 5/2/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDPinCallout.h"
#import <QuartzCore/QuartzCore.h>

#define  Arror_height 6

@implementation MDPinCallout

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void) didAddSubview:(UIView *)subview{
    
    if([NSStringFromClass([subview class]) isEqualToString:@"UICalloutView"] ||
       [NSStringFromClass([subview class]) isEqualToString:@"UIView"])
    {
        self.tmpCalloutView = subview;
        for(UIView *sv in [self.tmpCalloutView subviews])
        {
            [sv removeFromSuperview];
        }
        self.tmpCalloutView.backgroundColor = [UIColor whiteColor];
        self.tmpCalloutView.clipsToBounds = NO;        //←ここ超重要☆
        
        [self setFrame:CGRectMake(0, 0, 100, 100)];
//        self.isLayouted = NO;
    }
}

-(void) layoutSubviews{
    //好きなレイアウト
//    self.infoWindow = [[InfoWindow alloc] initWithNibName:@"InfoWindow" bundle:[NSBundle mainBundle]];
//    _tmpCalloutView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    //吹き出しの中央位置
//    CGRect pinRect = [self convertRect:self.bounds toView:self.tmpCalloutView];
//    CGFloat px = CGRectGetMidX(pinRect);
//    CGFloat py = CGRectGetMinY(pinRect);
//    
//    //ピンの画像によっては微調整
//    px = px - 8.0f;
//    py = py - 3.0f;
//    
//    [_tmpCalloutView setCenter:CGPointMake(px, py)];
    
    //InfoWindowに好きな情報をセットする
//    self.infoWindow.messageLabel.text = self.annotation.title;
    
    //標準コールアウトにオリジナルUIを追加
//    [self asyncAfterDelay:0.0f block:^{
//        [self.tmpCalloutView addSubview:self.infoWindow.view];
//    }];
}

- (CGRect)infoWindowFrame
{
    return [[self superview] convertRect:self.tmpCalloutView.frame fromView:self.tmpCalloutView];
}

@end
