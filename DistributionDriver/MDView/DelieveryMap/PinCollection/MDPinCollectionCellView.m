//
//  MDPinCollectionCellView.m
//  DistributionDriver
//
//  Created by Lsr on 5/27/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDPinCollectionCellView.h"

@implementation MDPinCollectionCellView

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //add code
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.shadowColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.5,0.5);
        self.layer.shadowOpacity = YES;
        
        //image
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 54, 54)];
        _image.layer.cornerRadius = 2.5;
        [self addSubview:_image];
        
        //status label
        _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(_image.frame.origin.x + _image.frame.size.width + 14, _image.frame.origin.y + 4, 60, 17)];
        _statusLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:10];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.layer.cornerRadius = 2.5;
        _statusLabel.layer.borderWidth = 0.5;
        _statusLabel.layer.borderColor = [UIColor colorWithRed:226.0/255.0 green:138.0/255.0 blue:0/255.0 alpha:1].CGColor;
        _statusLabel.textColor = [UIColor colorWithRed:226.0/255.0 green:138.0/255.0 blue:0/255.0 alpha:1];
        _statusLabel.text = @"依頼終了";
        [self addSubview:_statusLabel];
        
        
        //size
        _sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_statusLabel.frame.origin.x + _statusLabel.frame.size.width + 14, _image.frame.origin.y + 4, 102, 17)];
        _sizeLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:10];
        _sizeLabel.textAlignment = NSTextAlignmentCenter;
        _sizeLabel.layer.cornerRadius = 2.5;
        _sizeLabel.layer.borderWidth = 0.5;
        _sizeLabel.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1].CGColor;
        _sizeLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1];
        [self addSubview:_sizeLabel];
        
        //reward
        _rewardLabel = [[UILabel alloc]initWithFrame:CGRectMake(_statusLabel.frame.origin.x, _statusLabel.frame.origin.y + _statusLabel.frame.size.height + 11, 150, 20)];
        _rewardLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:18];
        _rewardLabel.textColor = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1];
        [self addSubview:_rewardLabel];
        
        //line
        UIView *lineTop = [[UIView alloc]initWithFrame:CGRectMake(0, _image.frame.origin.y + _image.frame.size.height + 10, frame.size.width, 1)];
        [lineTop setBackgroundColor:[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1]];
        [self addSubview:lineTop];
        
        //reviewLabel
        _reviewLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _image.frame.origin.y + _image.frame.size.height + 23, 40, 12)];
        _reviewLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
        _reviewLabel.textColor = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1];
        _reviewLabel.text = @"依頼者";
        [self addSubview:_reviewLabel];
        
        //star bar
        _starBar = [[MDStarRatingBar alloc]initWithFrame:CGRectMake(_reviewLabel.frame.origin.x + _reviewLabel.frame.size.width + 5, _reviewLabel.frame.origin.y-7, 100, 25)];
        [_starBar setRating:3];
        [self addSubview:_starBar];
        
        //line
        UIView *lineMiddle = [[UIView alloc]initWithFrame:CGRectMake(0, lineTop.frame.origin.y + 36, frame.size.width, 1)];
        [lineMiddle setBackgroundColor:[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1]];
        [self addSubview:lineMiddle];
        
        //to addr
        _toAddrLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, lineMiddle.frame.origin.y + lineMiddle.frame.size.height + 11, frame.size.width - 20, 12)];
        _toAddrLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
        _toAddrLabel.textColor = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1];
        [self addSubview:_toAddrLabel];
        
        //line
        UIView *lineBottom = [[UIView alloc]initWithFrame:CGRectMake(0, lineMiddle.frame.origin.y + 36, frame.size.width, 1)];
        [lineBottom setBackgroundColor:[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1]];
        [self addSubview:lineBottom];
        
        //expire
        _overLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, lineBottom.frame.origin.y + lineBottom.frame.size.height + 17, frame.size.width, 18)];
        _overLabel.textColor = [UIColor colorWithRed:226.0/255.0 green:138.0/255.0 blue:0/255.0 alpha:1];
        _overLabel.text = @"この依頼は終了しています。";
        _overLabel.textAlignment = NSTextAlignmentCenter;
        _overLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:18];
        [self addSubview:_overLabel];
    }
    
    return self;
}

-(void) setData:(MDPackage *)package{
    
    [_image sd_setImageWithURL:[NSURL URLWithString:package.image] placeholderImage:[UIImage imageNamed:@"cargo"] options:SDWebImageRetryFailed];
    _sizeLabel.text = [NSString stringWithFormat:@"合計 %@cm 以内", package.size];
    _rewardLabel.text = [NSString stringWithFormat:@"報酬: %@ 円", package.reward_amount];
    _toAddrLabel.text = [NSString stringWithFormat:@"配達場所: %@", package.to_addr];
    [_starBar setRating:[package.userReview.star intValue]];
    
}

-(void) setDataByPin:(MDPin *)pin{
    MDPackage *package = pin.package;
    
    [_image sd_setImageWithURL:[NSURL URLWithString:package.image] placeholderImage:[UIImage imageNamed:@"cargo"] options:SDWebImageRetryFailed];
    _sizeLabel.text = [NSString stringWithFormat:@"合計 %@cm 以内", package.size];
    _rewardLabel.text = [NSString stringWithFormat:@"報酬: %@ 円", package.reward_amount];
    _toAddrLabel.text = [NSString stringWithFormat:@"配達場所: %@", package.to_addr];
    [_starBar setRating:[package.userReview.star intValue]];
}

@end
