//
//  MDSettingView.m
//  Distribution
//
//  Created by Lsr on 3/27/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDSettingView.h"
#import "MDUser.h"
#import "MDUtil.h"

@implementation MDSettingView{
    MDSelect *nameButton;
    MDSelect *phoneButton;
    MDSelect *transportation;
    MDSelect *introButton;
}

#pragma mark - View Life Cycle

-(id) init
{
    return self;
}

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        MDUser *user = [MDUser getInstance];
        [user initDataClear];
        
        //scroll view
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-50)];
        _scrollView.scrollEnabled = YES;
        _scrollView.delegate = self;
        [_scrollView setContentSize:CGSizeMake(frame.size.width, frame.size.height)];
        _scrollView.bounces = YES;
        [_scrollView setBackgroundColor:[UIColor whiteColor]];
        _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        [self addSubview:_scrollView];
        
        //profile image
        MDSelect *profileImage = [[MDSelect alloc]initWithFrame:CGRectMake(10, 10, frame.size.width-20, 50)];
        profileImage.buttonTitle.text = @"プロフィール表示";
        [profileImage.buttonTitle sizeToFit];
        [profileImage addTarget:self action:@selector(profileImageTouched) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:profileImage];
        
        //name button
        nameButton = [[MDSelect alloc]initWithFrame:CGRectMake(10, 70, frame.size.width-20, 50)];
        nameButton.buttonTitle.text = @"お名前";
        nameButton.selectLabel.text = [NSString stringWithFormat:@"%@ %@", user.lastname, user.firstname];
        [nameButton addTarget:self action:@selector(nameButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:nameButton];
        
        //phone button
        phoneButton = [[MDSelect alloc]initWithFrame:CGRectMake(10, 130, frame.size.width-20, 50)];
        phoneButton.buttonTitle.text = @"電話番号";
        phoneButton.selectLabel.text = [NSString stringWithFormat:@"%@", user.phoneNumber];
        [phoneButton addTarget:self action:@selector(phoneNumberTouched) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:phoneButton];
        
        introButton = [[MDSelect alloc]initWithFrame:CGRectMake(10, phoneButton.frame.origin.y + phoneButton.frame.size.height + 10, frame.size.width - 20, 50)];
        introButton.buttonTitle.text = @"自己紹介";
        introButton.selectLabel.text = [NSString stringWithFormat:@"%@", user.intro];
        [introButton addTarget:self action:@selector(introButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:introButton];
        
        
        //配達方法
        transportation = [[MDSelect alloc]initWithFrame:CGRectMake(10, introButton.frame.origin.y + introButton.frame.size.height + 10, frame.size.width - 20, 50)];
        transportation.buttonTitle.text = @"交通手段";
        [transportation addTarget:self action:@selector(gotoTansptationView) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:transportation];
        
        
        //pay button
        MDSelect *payButton = [[MDSelect alloc]initWithFrame:CGRectMake(10, transportation.frame.origin.y + transportation.frame.size.height + 10, frame.size.width-20, 50)];
        payButton.buttonTitle.text = @"振込口座";
        payButton.selectLabel.text = [NSString stringWithFormat:@"%@",user.creditNumber];
        [payButton setUnactive];
        [payButton addTarget:self action:@selector(payButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:payButton];
        
        //name button
        MDSelect *qaButton = [[MDSelect alloc]initWithFrame:CGRectMake(10, 370, frame.size.width-20, 50)];
        qaButton.buttonTitle.text = @"よくある質問";
        qaButton.selectLabel.text = @"";
        [qaButton setUnactive];
        [qaButton addTarget:self action:@selector(nameButtonPushed) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:qaButton];
        
        //name button
        MDSelect *privateButton = [[MDSelect alloc]initWithFrame:CGRectMake(10, 430, frame.size.width-20, 50)];
        privateButton.buttonTitle.text = @"プライバシーポリシー";
        [privateButton.buttonTitle sizeToFit];
        privateButton.selectLabel.text = @"";
        [privateButton setUnactive];
        [privateButton addTarget:self action:@selector(nameButtonPushed) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:privateButton];
        
        //name button
        MDSelect *protocolButton = [[MDSelect alloc]initWithFrame:CGRectMake(10, 490, frame.size.width-20, 50)];
        protocolButton.buttonTitle.text = @"利用契約";
        protocolButton.selectLabel.text = @"";
        [protocolButton setUnactive];
        [protocolButton addTarget:self action:@selector(nameButtonPushed) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:protocolButton];
        
        //tabbar
        _tabbar = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-50, frame.size.width, 50)];
        //tab bar shadow
        UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
        [shadowView setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1]];
        [_tabbar addSubview:shadowView];
        
        //tab bar button
        for (int i = 0; i < 3; i++) {
            MDTabButton *tabButton = [[MDTabButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width / 3) * i, 0.5, ([UIScreen mainScreen].bounds.size.width / 3), 49.5) withTabType:i];
            if (i == 2) {
                [tabButton setButtonImage:YES];
            } else {
                [tabButton setButtonImage:NO];
            }
            [tabButton addTarget:self action:@selector(changeTab:) forControlEvents:UIControlEventTouchDown];
            [_tabbar addSubview:tabButton];
        }
        [self addSubview:_tabbar];
        
    }
    return self;
}

-(void) profileImageTouched{
    if([self.delegate respondsToSelector:@selector(profileImagePushed)]){
        [self.delegate profileImagePushed];
    }
}

-(void) nameButtonTouched {
    if([self.delegate respondsToSelector:@selector(nameButtonPushed)]){
        [self.delegate nameButtonPushed];
    }
}

- (void) phoneNumberTouched {
    if([self.delegate respondsToSelector:@selector(phoneNumberPushed)]){
        [self.delegate phoneNumberPushed];
    }
}

-(void) privacyButtonTouched {
    if([self.delegate respondsToSelector:@selector(privacyButtonPushed)]){
        [self.delegate privacyButtonPushed];
    }
}

-(void) blockDriverTouched {
    if([self.delegate respondsToSelector:@selector(blockDriverPushed)]){
        [self.delegate blockDriverPushed];
    }
}

-(void) changeTab:(MDTabButton *)button {
    switch (button.type) {
        case 0:
            [self gotoRequestView];
            break;
        case 1:
            [self gotoDeliveryView];
            break;
        default:
            break;
    }
}

-(void) gotoRequestView{
    if([self.delegate respondsToSelector:@selector(gotoRequestView)]) {
        [self.delegate gotoRequestView];
    }
}

-(void) gotoDeliveryView {
    if([self.delegate respondsToSelector:@selector(gotoDeliveryView)]) {
        [self.delegate gotoDeliveryView];
    }
}

-(void) gotoTansptationView{
    if([self.delegate respondsToSelector:@selector(gotoTansptationView)]){
        [self.delegate gotoTansptationView];
    }
}

-(void) setViewData:(MDUser *)user{
    nameButton.selectLabel.text = [NSString stringWithFormat:@"%@ %@", user.lastname, user.firstname];
    phoneButton.selectLabel.text = [[MDUtil getInstance] japanesePhoneNumber:[MDUser getInstance].phoneNumber];
    
    NSString *transportationStr = @"";
    if([user.walk isEqualToString:@"1"]){
        transportationStr = @"徒歩";
    }
    if([user.bike isEqualToString:@"1"]){
        transportationStr = [NSString stringWithFormat:@"%@ %@",transportationStr, @"自転車"];
    }
    if([user.motorBike isEqualToString:@"1"]){
        transportationStr = [NSString stringWithFormat:@"%@ %@",transportationStr, @"バイク"];
    }
    if([user.car isEqualToString:@"1"]){
        transportationStr = [NSString stringWithFormat:@"%@ %@",transportationStr, @"車"];
    }
    transportation.selectLabel.text = transportationStr;
    
    introButton.selectLabel.text = user.intro;
}

-(void) introButtonTouched{
    if([self.delegate respondsToSelector:@selector(introButtonPushed)]){
        [self.delegate introButtonPushed];
    }
}

-(void) payButtonTouched{
    if([self.delegate respondsToSelector:@selector(payButtonPushed)]){
        [self.delegate payButtonPushed];
    }
}

@end

