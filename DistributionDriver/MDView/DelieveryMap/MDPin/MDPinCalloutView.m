//
//  MDPinCalloutView.m
//  DistributionDriver
//
//  Created by Lsr on 5/3/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDPinCalloutView.h"
#import <UIImageView+WebCache.h>

@implementation MDPinCalloutView

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
        
        //size
        _sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_image.frame.origin.x + _image.frame.size.width + 14, _image.frame.origin.y + 4, 102, 17)];
        _sizeLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:10];
        _sizeLabel.textAlignment = NSTextAlignmentCenter;
        _sizeLabel.layer.cornerRadius = 2.5;
        _sizeLabel.layer.borderWidth = 0.5;
        _sizeLabel.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1].CGColor;
        _sizeLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1];
        [self addSubview:_sizeLabel];
        
        //reward
        _rewardLabel = [[UILabel alloc]initWithFrame:CGRectMake(_sizeLabel.frame.origin.x, _sizeLabel.frame.origin.y + _sizeLabel.frame.size.height + 11, 150, 20)];
        _rewardLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:18];
        _rewardLabel.textColor = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1];
        [self addSubview:_rewardLabel];
        
        //right arrow
        UIImageView *rightArrayView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - 22, 28, 11, 18)];
        [rightArrayView setImage:[UIImage imageNamed:@"grayRightArrow"]];
        [self addSubview:rightArrayView];
        
        //line
        UIView *lineTop = [[UIView alloc]initWithFrame:CGRectMake(0, _image.frame.origin.y + _image.frame.size.height + 10, frame.size.width, 1)];
        [lineTop setBackgroundColor:[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1]];
        [self addSubview:lineTop];
        
        //to addr
        _toAddrLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _image.frame.origin.y + _image.frame.size.height + 23, frame.size.width - 20, 12)];
        _toAddrLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
        _toAddrLabel.textColor = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1];
        [self addSubview:_toAddrLabel];
        
        //line
        UIView *lineBottom = [[UIView alloc]initWithFrame:CGRectMake(0, lineTop.frame.origin.y + 36, frame.size.width, 1)];
        [lineBottom setBackgroundColor:[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1]];
        [self addSubview:lineBottom];
        
        //deliverylimit
        _deliveryLimitLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _toAddrLabel.frame.origin.y + _toAddrLabel.frame.size.height + 24, frame.size.width -20, 12)];
        _deliveryLimitLabel.textColor = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1];
        _deliveryLimitLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
        [self addSubview:_deliveryLimitLabel];
        
        //expire
        _expireLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _deliveryLimitLabel.frame.origin.y + _deliveryLimitLabel.frame.size.height + 9, _deliveryLimitLabel.frame.size.width, 12)];
        _expireLabel.textColor = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1];
        _expireLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
        [self addSubview:_expireLabel];
    }
    
    return self;
}

-(void) setData:(MDPackage *)package{
    
    [_image sd_setImageWithURL:[NSURL URLWithString:package.image] placeholderImage:[UIImage imageNamed:@"cargo"] options:SDWebImageRetryFailed];
    _sizeLabel.text = [NSString stringWithFormat:@"合計 %@cm 以内", package.size];
    _rewardLabel.text = [NSString stringWithFormat:@"報酬: %@円", package.reward_amount];
    _toAddrLabel.text = [NSString stringWithFormat:@"配達場所: %@", package.to_addr];
    
    //convert
    NSDate *now = [NSDate date];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[NSLocale systemLocale]];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:00"];
    NSDate *deliverLimitDate =[dateFormat dateFromString:package.deliver_limit];
    NSDateFormatter* janpaneseFormat = [[NSDateFormatter alloc] init];
    [janpaneseFormat setLocale:[NSLocale systemLocale]];
    [janpaneseFormat setDateFormat:@"YYYY年MM月dd日 HH時mm分"];
    _deliveryLimitLabel.text = [NSString stringWithFormat:@"配達期限: %@", [janpaneseFormat stringFromDate:deliverLimitDate]];
    
    NSDate *expireDate =[dateFormat dateFromString:package.expire];
    NSTimeInterval timeBetween = [expireDate timeIntervalSinceDate:now];
    int hour = timeBetween/60/60;
    _expireLabel.text = [NSString stringWithFormat:@"依頼期限: %d時間以内", hour+1];
    
}

@end
