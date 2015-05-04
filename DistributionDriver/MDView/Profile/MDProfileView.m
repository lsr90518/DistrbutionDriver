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

@implementation MDProfileView{
    UIImageView *profileImageView;
    MDInput     *nameInput;
    UIView      *previewView;//new compnent
    MDSelect    *phoneNumberButton;
    MDWell      *descriptionWell;
    MDTitleWell      *introWell;//new component
    MDInput     *countNumber;
    MDTitleWell      *previewWell;//new component
    UIButton *blockButton;
    UIButton *policeButton;
    
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
        [profileImageView sd_setImageWithURL:[NSURL URLWithString:[MDUser getInstance].image] placeholderImage:[UIImage imageNamed:@"cargo"] options:SDWebImageRetryFailed];
        [_scrollView addSubview:profileImageView];
        
        //name
        nameInput = [[MDInput alloc]initWithFrame:CGRectMake(profileImageView.frame.origin.x + profileImageView.frame.size.width + 10,
                                                            profileImageView.frame.origin.y,
                                                            frame.size.width - 10 - profileImageView.frame.origin.x - profileImageView.frame.size.width - 10,
                                                            50)];
        nameInput.title.text = [NSString stringWithFormat:@"%@ %@",[MDUser getInstance].lastname, [MDUser getInstance].firstname];;
        [nameInput.title sizeToFit];
        [nameInput.input setHidden:YES];
        [_scrollView addSubview:nameInput];
        
        //preview
        previewView = [[UIView alloc]initWithFrame:CGRectMake(nameInput.frame.origin.x,
                                                              nameInput.frame.size.height + nameInput.frame.origin.y + 10,
                                                              nameInput.frame.size.width,
                                                              nameInput.frame.size.height)];
        previewView.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1].CGColor;
        previewView.layer.borderWidth = 0.5;
        [_scrollView addSubview:previewView];
        
        //連絡先
        phoneNumberButton = [[MDSelect alloc]initWithFrame:CGRectMake(10, profileImageView.frame.origin.y + profileImageView.frame.size.height + 10, frame.size.width - 20, 50)];
        phoneNumberButton.buttonTitle.text = @"連絡先";
        [phoneNumberButton.buttonTitle sizeToFit];
        phoneNumberButton.selectLabel.text = [[MDUtil getInstance] japanesePhoneNumber:[MDUser getInstance].phoneNumber];
        [_scrollView addSubview:phoneNumberButton];
        
        //説明文
        descriptionWell = [[MDWell alloc]initWithFrame:CGRectMake(10, phoneNumberButton.frame.origin.y + phoneNumberButton.frame.size.height, frame.size.width-20, 100)];
        descriptionWell.contentText = @"荷物について、ご不明点や連絡が必要な際は、上記連絡先よりドライバーに直接ご問い合わせたください。当サービスでは、サービス向上のためドライバーの方の免許証、保険証の確認しております。";
        [_scrollView addSubview:descriptionWell];
        
        //自己紹介
        introWell = [[MDTitleWell alloc]initWithFrame:CGRectMake(10, descriptionWell.frame.origin.y + descriptionWell.frame.size.height + 10, frame.size.width-20, 104)];
        [introWell setDataWithTitle:@"ドライバー自己紹介" Text:[MDUser getInstance].intro];
        [_scrollView addSubview:introWell];
        
        
        
        //荷物回数
        countNumber = [[MDInput alloc]initWithFrame:CGRectMake(10, introWell.frame.origin.y + introWell.frame.size.height + 10, frame.size.width -20, 50)];
        countNumber.title.text = @"今まで運んだ荷物";
        [countNumber.title sizeToFit];
        countNumber.input.text = [NSString stringWithFormat:@"%@回",[MDUser getInstance].deposit];
        [countNumber.input setUserInteractionEnabled:NO];
        [_scrollView addSubview:countNumber];
        
        //評価
        previewWell = [[MDTitleWell alloc]initWithFrame:CGRectMake(10, countNumber.frame.origin.y + countNumber.frame.size.height - 1, frame.size.width - 20, 100)];
        [previewWell setDataWithTitle:@"xy" subtitle:@"2015-05-02" text:@"一所懸命"];
        [previewView setBackgroundColor:[UIColor whiteColor]];
        [_scrollView addSubview:previewWell];
        
        //ブロック
//        blockButton = [[UIButton alloc]initWithFrame:CGRectMake(10, previewWell.frame.origin.y + previewWell.frame.size.height+10, frame.size.width - 20, 50)];
//        [blockButton setTitle:@"このドライバーをブロックする" forState:UIControlStateNormal];
//        [blockButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        blockButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:14];
//        blockButton.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1].CGColor;
//        blockButton.layer.borderWidth = 0.5;
//        blockButton.layer.cornerRadius = 1;
//        [_scrollView addSubview:blockButton];
//        
//        //通報
//        policeButton = [[UIButton alloc]initWithFrame:CGRectMake(10, blockButton.frame.origin.y + blockButton.frame.size.height+10, frame.size.width - 20, 50)];
//        [policeButton setTitle:@"このドライバーを通報する" forState:UIControlStateNormal];
//        [policeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        policeButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:14];
//        policeButton.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1].CGColor;
//        policeButton.layer.borderWidth = 0.5;
//        policeButton.layer.cornerRadius = 1;
//        [_scrollView addSubview:policeButton];
        
        [_scrollView setContentSize:CGSizeMake(frame.size.width, previewWell.frame.origin.y + previewWell.frame.size.height + 50)];
    }
    return self;
}

@end
