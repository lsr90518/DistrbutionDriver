//
//  MDTranspotation.m
//  DistributionDriver
//
//  Created by Lsr on 5/3/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDTranspotation.h"
#import "MDKindButton.h"
#import "MDUser.h"

@implementation MDTranspotation{
    MDKindButton *trankButton;
    MDKindButton *walkButton;
    MDKindButton *bikeButton;
    MDKindButton *motorbikeButton;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setBackgroundColor:[UIColor whiteColor]];
        //transportation title
        UIView *transpotationTitleView = [[UIView alloc]initWithFrame:CGRectMake(10, frame.origin.y + 74, frame.size.width-20, 50)];
        [transpotationTitleView setBackgroundColor:[UIColor whiteColor]];
        transpotationTitleView.layer.cornerRadius = 2.5;
        transpotationTitleView.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1].CGColor;
        transpotationTitleView.layer.borderWidth = 0.5;
        
        UILabel *transpotationTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 18, 90, 14)];
        transpotationTitleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:14];
        transpotationTitleLabel.text = @"配送予定手段";
        transpotationTitleLabel.textColor = [UIColor blackColor];
        
        UILabel *transpotationSubtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 18, 166, 13)];
        transpotationSubtitleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:13];
        transpotationSubtitleLabel.text = @"(該当は全て選択 : 変更可)";
        transpotationTitleLabel.textColor = [UIColor blackColor];
        
        [transpotationTitleView addSubview:transpotationTitleLabel];
        [transpotationTitleView addSubview:transpotationSubtitleLabel];
        [self addSubview:transpotationTitleView];
        
        float viewLength = transpotationTitleView.frame.size.width / 4;
        
        //button group
        walkButton = [[MDKindButton alloc]initWithFrame:CGRectMake(10, transpotationTitleView.frame.origin.y + transpotationTitleView.frame.size.height-2, viewLength, viewLength)];
        [walkButton setIconImageByName:@"walkingIcon"];
        walkButton.buttonTitle.text = @"徒歩";
        [walkButton addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:walkButton];
        //button group
        bikeButton = [[MDKindButton alloc]initWithFrame:CGRectMake(walkButton.frame.origin.x + walkButton.frame.size.width - 1, transpotationTitleView.frame.origin.y + transpotationTitleView.frame.size.height-2, viewLength+1, viewLength)];
        [bikeButton setIconImageByName:@"bikeIcon"];
        bikeButton.buttonTitle.text = @"自転車";
        [bikeButton addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bikeButton];
        //button group
        motorbikeButton = [[MDKindButton alloc]initWithFrame:CGRectMake(bikeButton.frame.origin.x + bikeButton.frame.size.width - 1, transpotationTitleView.frame.origin.y + transpotationTitleView.frame.size.height-2, viewLength + 1, viewLength)];
        [motorbikeButton setIconImageByName:@"motorbikeIcon"];
        motorbikeButton.buttonTitle.text = @"バイク";
        [motorbikeButton addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:motorbikeButton];
        //button group
        trankButton = [[MDKindButton alloc]initWithFrame:CGRectMake(motorbikeButton.frame.origin.x + motorbikeButton.frame.size.width - 1, transpotationTitleView.frame.origin.y + transpotationTitleView.frame.size.height-2, viewLength + 1, viewLength)];
        [trankButton setIconImageByName:@"trankIcon"];
        trankButton.buttonTitle.text = @"自動車";
        [trankButton addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:trankButton];
        [self addSubview:transpotationTitleView];

    }
    return self;
}

-(void) toggleButton:(MDKindButton *)button{
    if ([button.buttonTitle.text isEqualToString:@"徒歩"]){
        [MDUser getInstance].walk = ([[button toggleButton] isEqualToString:@"On"]) ? @"1" : @"0";
    } else if([button.buttonTitle.text isEqualToString:@"バイク"]) {
        [MDUser getInstance].motorBike = ([[button toggleButton] isEqualToString:@"On"]) ? @"1" : @"0";
    } else if([button.buttonTitle.text isEqualToString:@"自転車"]) {
        [MDUser getInstance].bike = ([[button toggleButton] isEqualToString:@"On"]) ? @"1" : @"0";
    } else {
        [MDUser getInstance].car = ([[button toggleButton] isEqualToString:@"On"]) ? @"1" : @"0";
    }
}

-(void) initWithData:(MDUser *)user{
    ([user.car isEqualToString:@"1"]) ? [trankButton toggleButton] : @"";
    ([user.bike isEqualToString:@"1"]) ? [bikeButton toggleButton] : @"";
    ([user.motorBike isEqualToString:@"1"]) ? [motorbikeButton toggleButton] : @"";
    ([user.walk isEqualToString:@"1"]) ? [walkButton toggleButton] : @"";
}

@end
