//
//  MDSettingView.m
//  Distribution
//
//  Created by Lsr on 3/27/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDSettingView.h"
#import "MDUser.h"
#import "MDSelectRating.h"
#import "MDUtil.h"

@implementation MDSettingView{
    
    MDSelect *notificationButton;
    MDSelectRating *averageButton;
    MDSelect *nameButton;
    MDSelect *phoneButton;
    MDSelect *transportation;
    MDSelect *introButton;
    UIButton *logoutButton;
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
//        MDSelect *profileImage = [[MDSelect alloc]initWithFrame:CGRectMake(10, 10, frame.size.width-20, 50)];
//        profileImage.buttonTitle.text = @"プロフィール表示";
//        [profileImage.buttonTitle sizeToFit];
//        [profileImage addTarget:self action:@selector(profileImageTouched) forControlEvents:UIControlEventTouchUpInside];
//        [_scrollView addSubview:profileImage];

        notificationButton = [[MDSelect alloc]initWithFrame:CGRectMake(10, 10, frame.size.width - 20, 50)];
        notificationButton.buttonTitle.text = @"通知";
        [notificationButton addTarget:self action:@selector(notificationButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:notificationButton];
        
        averageButton = [[MDSelectRating alloc]initWithFrame:CGRectMake(10, notificationButton.frame.origin.y + notificationButton.frame.size.height + 10, frame.size.width - 20, 50)];
        averageButton.buttonTitle.text = @"平均評価";
        [averageButton.starLabel setRating:5];
        [averageButton setReadOnly];
        [averageButton addTarget:self action:@selector(averageButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:averageButton];
        
        //name button
        nameButton = [[MDSelect alloc]initWithFrame:CGRectMake(10, averageButton.frame.origin.y + averageButton.frame.size.height + 10, frame.size.width-20, 50)];
        nameButton.buttonTitle.text = @"お名前";
        [nameButton addTarget:self action:@selector(nameButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:nameButton];
        
        //phone button
        phoneButton = [[MDSelect alloc]initWithFrame:CGRectMake(10, nameButton.frame.origin.y + nameButton.frame.size.height + 10, frame.size.width-20, 50)];
        phoneButton.buttonTitle.text = @"携帯番号";
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
        MDSelect *qaButton = [[MDSelect alloc]initWithFrame:CGRectMake(10, payButton.frame.origin.y + payButton.frame.size.height + 10, frame.size.width-20, 50)];
        qaButton.buttonTitle.text = @"よくある質問";
        qaButton.selectLabel.text = @"";
        [qaButton setUnactive];
        [qaButton addTarget:self action:@selector(aqButtonPushed) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:qaButton];
        
        //name button
        MDSelect *privateButton = [[MDSelect alloc]initWithFrame:CGRectMake(10, qaButton.frame.origin.y + qaButton.frame.size.height + 10, frame.size.width-20, 50)];
        privateButton.buttonTitle.text = @"プライバシーポリシー";
        [privateButton.buttonTitle sizeToFit];
        privateButton.selectLabel.text = @"";
        [privateButton setUnactive];
        [privateButton addTarget:self action:@selector(privateButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:privateButton];
        
        //name button
        MDSelect *protocolButton = [[MDSelect alloc]initWithFrame:CGRectMake(10, privateButton.frame.origin.y + privateButton.frame.size.height + 10, frame.size.width-20, 50)];
        protocolButton.buttonTitle.text = @"利用規約";
        protocolButton.selectLabel.text = @"";
        [protocolButton setUnactive];
        [protocolButton addTarget:self action:@selector(protocolButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:protocolButton];
        
        //button
        logoutButton = [[UIButton alloc]initWithFrame:CGRectMake(10, protocolButton.frame.origin.y + protocolButton.frame.size.height + 23, frame.size.width-20, 50)];
        [logoutButton setBackgroundColor:[UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1]];
        [logoutButton setTitle:@"ログアウト" forState:UIControlStateNormal];
        logoutButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:18];
        logoutButton.layer.cornerRadius = 2.5;
        [logoutButton addTarget:self action:@selector(logoutButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:logoutButton];
        [_scrollView setContentSize:CGSizeMake(frame.size.width, logoutButton.frame.origin.y + logoutButton.frame.size.height + 10)];
        
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

-(void) notificationButtonTouched {
    if([self.delegate respondsToSelector:@selector(notificationButtonPushed)]){
        [self.delegate notificationButtonPushed];
    }
}

-(void) averageButtonTouched{
    if([self.delegate respondsToSelector:@selector(averageButtonPushed)]){
        [self.delegate averageButtonPushed];
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

-(void) logoutButtonTouched{
    if([self.delegate respondsToSelector:@selector(logoutButtonPushed)]){
        [self.delegate logoutButtonPushed];
    }
}

-(void) privateButtonTouched{
    if([self.delegate respondsToSelector:@selector(privacyButtonPushed)]){
        [self.delegate privacyButtonPushed];
    }
}

-(void) protocolButtonTouched {
    if([self.delegate respondsToSelector:@selector(protocolButtonPushed)]){
        [self.delegate protocolButtonPushed];
    }
}

-(void) aqButtonPushed{
    if([self.delegate respondsToSelector:@selector(aqButtonPushed)]){
        [self.delegate aqButtonPushed];
    }
}

-(void) setViewData:(MDUser *)user{
    nameButton.selectLabel.text = [NSString stringWithFormat:@"%@ %@", user.lastname, user.firstname];
    phoneButton.selectLabel.text = [MDUtil japanesePhoneNumber:[MDUser getInstance].phoneNumber];
    
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

-(void) setRating:(int)star{
    [averageButton.starLabel setRating:star];
}

-(void)setNotificationCount:(int)count{
    
    if(count == 0){
        notificationButton.selectLabel.text = @"新着通知がありません";
    } else {
        notificationButton.selectLabel.text = [NSString stringWithFormat:@"%d件の新着", count];
    }
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

