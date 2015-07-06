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
#import "MDCheckBox.h"

@implementation MDTranspotation{
    MDKindButton *trankButton;
    MDKindButton *walkButton;
    MDKindButton *bikeButton;
    MDKindButton *motorbikeButton;
    
    UILabel         *warnLabel;
    UIView          *warnView;
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
        
        [self setWarnViewStatus:0];

    }
    return self;
}

-(void) setWarnViewStatus:(int)status{
    
    [warnView removeFromSuperview];
    
    warnView = [[UIView alloc]initWithFrame:CGRectMake(10, walkButton.frame.origin.y + walkButton.frame.size.height + 10, self.frame.size.width - 20, 300)];
    
    //warn label
    warnLabel  = [[UILabel alloc]init];
    warnLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:11];
    warnLabel.textColor = [UIColor colorWithRed:226.0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    warnLabel.numberOfLines = 0;
    
    //content
    if (status == 0) {
        [warnLabel setFrame:CGRectMake(20, 0, warnView.frame.size.width - 40, 0)];
        warnLabel.text = @"";
    } else if(status == 1){
        [warnLabel  setFrame:CGRectMake(20, 15, warnView.frame.size.width - 40, 50)];
        warnLabel.text = @"125CC以上のバイクを利用して運送を行う場合、許認可が必要となりますので、ご注意ください。";
        
    } else if(status == 2){
        [warnLabel setFrame:CGRectMake(20, 15, warnView.frame.size.width - 40, 50)];
        warnLabel.text = @"自動車を利用して、運送を行う場合、許認可が必要となりますので、ご注意ください。";
        
    } else {
        [warnLabel setFrame:CGRectMake(20, 15, warnView.frame.size.width - 40, 50)];
        warnLabel.text = @"125CC以上のバイク、また自動車を利用して運送を行う場合、許認可が必要となりますので、ご注意ください。";
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:warnLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:11];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [warnLabel.text length])];
    warnLabel.attributedText = attributedString;
    [warnLabel sizeToFit];
    [warnView addSubview:warnLabel];
    
//    //warn check
//    MDCheckBox *shipCheckBox = [[MDCheckBox alloc]initWithFrame:CGRectMake(0, 0, 34, 0)];
//    
//    if (status != 0) {
//        [shipCheckBox setFrame:CGRectMake(0, warnLabel.frame.origin.y + warnLabel.frame.size.height + 30, 34, 34)];
//        //checkbox
//        [shipCheckBox addTarget:self action:@selector(toggleCheck:) forControlEvents:UIControlEventTouchUpInside];
//        [warnView addSubview:shipCheckBox];
//        
//        UILabel *shipToLabel = [[UILabel alloc]initWithFrame:CGRectMake(shipCheckBox.frame.origin.x + shipCheckBox.frame.size.width+10, shipCheckBox.frame.origin.y+10, 84, 14)];
//        shipToLabel.text = @"運送に関わる";
//        shipToLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:14];
//        shipToLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1];
//        [warnView addSubview:shipToLabel];
//        
//        UIButton *shipDriverProtocol = [[UIButton alloc]initWithFrame:CGRectMake(shipToLabel.frame.origin.x+shipToLabel.frame.size.width, shipToLabel.frame.origin.y, 42, 14)];
//        shipDriverProtocol.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:14];
//        [shipDriverProtocol setTitleColor:[UIColor colorWithRed:30.0/255.0 green:132.0/255.0 blue:158.0/255.0 alpha:1] forState:UIControlStateNormal];
//        [shipDriverProtocol setTitle:@"許認可" forState:UIControlStateNormal];
//        [warnView addSubview:shipDriverProtocol];
//        
//        UILabel *shipNiLabel = [[UILabel alloc]initWithFrame:CGRectMake(shipDriverProtocol.frame.origin.x + shipDriverProtocol.frame.size.width, shipDriverProtocol.frame.origin.y, 126, 14)];
//        shipNiLabel.text = @"を保有しています。";
//        shipNiLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:14];
//        shipNiLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1];
//        [warnView addSubview:shipNiLabel];
//    }
    
    [self addSubview:warnView];
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
    
    int status = 0;
    ([[MDUser getInstance].motorBike isEqualToString:@"1"]) ? status = status + 1 : status;
    ([[MDUser getInstance].car isEqualToString:@"1"]) ? status = status + 2 : status;
    
    [self setWarnViewStatus:status];
}

-(void) initWithData:(MDUser *)user{
    ([user.car isEqualToString:@"1"]) ? [trankButton toggleButton] : @"";
    ([user.bike isEqualToString:@"1"]) ? [bikeButton toggleButton] : @"";
    ([user.motorBike isEqualToString:@"1"]) ? [motorbikeButton toggleButton] : @"";
    ([user.walk isEqualToString:@"1"]) ? [walkButton toggleButton] : @"";
}

@end
