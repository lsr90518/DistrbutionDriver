//
//  MDProfileView.m
//  DistributionDriver
//
//  Created by Lsr on 4/26/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDProfileView.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "MDTitleWell.h"
#import "MDUser.h"
#import "MDUtil.h"
#import "MDReview.h"
#import "MDStarRatingBar.h"
#import "MDReviewWell.h"

@implementation MDProfileView{
    UIImageView *profileImageView;
    MDInput     *nameInput;
    MDSelect    *phoneNumberButton;
    MDWell      *descriptionWell;
    MDTitleWell      *introWell;
    MDSelect     *countNumber;
    MDReviewWell      *previewWell;
    UIButton *blockButton;
    UIButton *policeButton;
    MDStarRatingBar *reviewView;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        //scrollview
        _scrollView = [[UIScrollView alloc]initWithFrame:frame];
        [self addSubview:_scrollView];
        
        //profile Image
        profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 110, 110)];
        //        [profileImageView sd_setImageWithURL:[NSURL URLWithString:[MDUser getInstance].image] placeholderImage:[UIImage imageNamed:@"cargo"] options:SDWebImageRetryFailed];
        [profileImageView setImage:[UIImage imageNamed:@"cargo"]];
        [_scrollView addSubview:profileImageView];
        
        //name
        nameInput = [[MDInput alloc]initWithFrame:CGRectMake(profileImageView.frame.origin.x + profileImageView.frame.size.width + 10,
                                                             profileImageView.frame.origin.y,
                                                             frame.size.width - 10 - profileImageView.frame.origin.x - profileImageView.frame.size.width - 10,
                                                             50)];
        
        [nameInput.input setHidden:YES];
        [_scrollView addSubview:nameInput];
        
        //preview
        reviewView = [[MDStarRatingBar alloc]initWithFrame:CGRectMake(nameInput.frame.origin.x,
                                                                      nameInput.frame.size.height + nameInput.frame.origin.y + 10,
                                                                      nameInput.frame.size.width,
                                                                      nameInput.frame.size.height)];
        reviewView.layer.cornerRadius = 2.5;
        reviewView.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1].CGColor;
        reviewView.layer.borderWidth = 0.5;
        [reviewView setUserInteractionEnabled:NO];
        [_scrollView addSubview:reviewView];
        
        //連絡先
        phoneNumberButton = [[MDSelect alloc]initWithFrame:CGRectMake(10, profileImageView.frame.origin.y + profileImageView.frame.size.height + 10, frame.size.width - 20, 50)];
        phoneNumberButton.buttonTitle.text = @"連絡先";
        [phoneNumberButton.buttonTitle sizeToFit];
        phoneNumberButton.selectLabel.text = @"";
        [phoneNumberButton addTarget:self action:@selector(phoneButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:phoneNumberButton];
        
        //説明文
        descriptionWell = [[MDWell alloc]initWithFrame:CGRectMake(10, phoneNumberButton.frame.origin.y + phoneNumberButton.frame.size.height, frame.size.width-20, 100)];
        descriptionWell.contentText = @"荷物について、ご不明点や連絡が必要な際は、上記連絡先よりドライバーに直接ご問い合わせたください。当サービスでは、サービス向上のためドライバーの方の免許証、保険証の確認しております。";
        [_scrollView addSubview:descriptionWell];
        
        //自己紹介
        introWell = [[MDTitleWell alloc]initWithFrame:CGRectMake(10, descriptionWell.frame.origin.y + descriptionWell.frame.size.height + 10, frame.size.width-20, 104)];
        introWell.layer.cornerRadius = 2.5;
        
        [_scrollView addSubview:introWell];
        
        
        
        //荷物回数
        countNumber = [[MDSelect alloc]initWithFrame:CGRectMake(10, introWell.frame.origin.y + introWell.frame.size.height + 10, frame.size.width -20, 50)];
        countNumber.buttonTitle.text = @"今まで運んだ荷物";
        [countNumber.buttonTitle sizeToFit];
        [countNumber setActive];
        [countNumber addTarget:self action:@selector(historyButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:countNumber];
        
        [_scrollView setContentSize:CGSizeMake(frame.size.width, countNumber.frame.origin.y + countNumber.frame.size.height + 50)];
    }
    return self;
}

-(void) setDriverData:(MDDriver *)driver{
    
    //photo
    [profileImageView sd_setImageWithURL:[NSURL URLWithString:driver.image] placeholderImage:[UIImage imageNamed:@"cargo"] options:SDWebImageRetryFailed];
    
    //name
    nameInput.title.text = driver.name;
    [nameInput.title setFrame:CGRectMake(19, 16, nameInput.frame.size.width - 38, 18)];
    
    //phone number
    phoneNumberButton.selectLabel.text = driver.phoneNumber;
    
    //star
    float averageStar = [driver.average_star floatValue];
    [reviewView setRating:(int)averageStar];
    
    //intro
    [introWell setDataWithTitle:@"ドライバー自己紹介" Text:driver.intro];
    
    //回数
    countNumber.selectLabel.text = [NSString stringWithFormat:@"%@回",driver.delivered_package];
    
}

-(void) phoneButtonTouched:(MDSelect *)button{
    if([self.delegate respondsToSelector:@selector(phoneButtonPushed:)]){
        [self.delegate phoneButtonPushed:button];
    }
}

-(void) blockButtonTouched{
    if([self.delegate respondsToSelector:@selector(blockButtonPushed)]){
        [self.delegate blockButtonPushed];
    }
}

-(void) historyButtonTouched{
    if([self.delegate respondsToSelector:@selector(historyButtonPushed)]){
        [self.delegate historyButtonPushed];
    }
}

@end
