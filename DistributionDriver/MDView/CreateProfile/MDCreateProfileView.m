//
//  MDCreateProfileView.m
//  Distribution
//
//  Created by Lsr on 4/12/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDCreateProfileView.h"
#import "MDCheckBox.h"
#import "MDUtil.h"
#import "MDUser.h"
#import "MDKindButton.h"

@implementation MDCreateProfileView{
    MDKindButton *trankButton;
    MDKindButton *walkButton;
    MDKindButton *bikeButton;
    MDKindButton *motorbikeButton;
    BOOL isChecked;
}

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _scrollView = [[UIScrollView alloc]initWithFrame:frame];
        _scrollView.delegate = self;
        [_scrollView setContentSize:CGSizeMake(frame.size.width, 830)];
        [_scrollView setBackgroundColor:[UIColor whiteColor]];
        [_scrollView setScrollEnabled:YES];
        [self addSubview:_scrollView];
        
        //顔写真ボタン
        _personButtonAndDescription = [[MDButtonAndDescriptionView alloc]initWithFrame:CGRectMake(10, 10, frame.size.width-20, 100)];
        [_personButtonAndDescription setText:@"顔がハッキリと分かる正面の写真を添付してください。条件を満たさない場合、登録申請が解除される場合があります。"];
        [_personButtonAndDescription setIcon:[UIImage imageNamed:@"personIcon"]];
        _personButtonAndDescription.delegate = self;
        _personButtonAndDescription.buttonTitle = @"顔";
        [_scrollView addSubview:_personButtonAndDescription];
        
        
        _idCardButtonAndDescription =
        [[MDButtonAndDescriptionView alloc]initWithFrame:CGRectMake(_personButtonAndDescription.frame.origin.x,
                                                                    _personButtonAndDescription.frame.origin.y + _personButtonAndDescription.frame.size.height + 10,
                                                                    _personButtonAndDescription.frame.size.width,
                                                                    _personButtonAndDescription.frame.size.height)];
        [_idCardButtonAndDescription setText:@"本人確認のため身分を証明する書類を撮影し添付してください。①免許証、②保険証、③パスポートが有効です。"];
        _idCardButtonAndDescription.buttonTitle = @"証明書";
        [_idCardButtonAndDescription setIcon:[UIImage imageNamed:@"IDCardIcon"]];
        _idCardButtonAndDescription.delegate = self;
        [_scrollView addSubview:_idCardButtonAndDescription];
        
        
        _lastnameInput = [[MDInput alloc]initWithFrame:CGRectMake(10, _idCardButtonAndDescription.frame.origin.y + _idCardButtonAndDescription.frame.size.height + 10, frame.size.width-20, 50)];
        _lastnameInput.title.text = @"姓";
        [_lastnameInput.title sizeToFit];
        _lastnameInput.input.placeholder = @"山田";
        _lastnameInput.delegate = self;
        [_scrollView addSubview:_lastnameInput];
        
        _givennameInput = [[MDInput alloc]initWithFrame:CGRectMake(10, _lastnameInput.frame.origin.y + _lastnameInput.frame.size.height + 10, frame.size.width-20, 50)];
        [_givennameInput setBackgroundColor:[UIColor whiteColor]];
        _givennameInput.title.text = @"名";
        [_givennameInput.title sizeToFit];
        _givennameInput.input.placeholder = @"太郎";
        _givennameInput.delegate = self;
        [_scrollView addSubview:_givennameInput];
        
        _phoneButton = [[MDInput alloc]initWithFrame:CGRectMake(10,
                                                                _givennameInput.frame.origin.y + 10 + _givennameInput.frame.size.height,
                                                                frame.size.width-20,
                                                                50)];
        [_phoneButton setBackgroundColor:[UIColor whiteColor]];
        _phoneButton.title.text = @"携帯番号";
        [_phoneButton.title sizeToFit];
        _phoneButton.input.text = [MDUtil japanesePhoneNumber:[MDUser getInstance].phoneNumber];
//        [_phoneButton setReadOnly];
        _phoneButton.delegate = self;
        [_phoneButton setUserInteractionEnabled:NO];
        [_scrollView addSubview:_phoneButton];
        
        _passwordInput = [[MDInput alloc]initWithFrame:CGRectMake(10,
                                                                  _phoneButton.frame.origin.y + 10 + _phoneButton.frame.size.height,
                                                                  frame.size.width-20,
                                                                  50)];
        [_passwordInput setBackgroundColor:[UIColor whiteColor]];
        _passwordInput.title.text = @"パスワード";
        [_passwordInput.title sizeToFit];
        [_passwordInput.input setSecureTextEntry:YES];
        _passwordInput.input.placeholder = @"6桁以上の英数字";
        _passwordInput.delegate = self;
        [_scrollView addSubview:_passwordInput];
        
        _repeatInput = [[MDInput alloc]initWithFrame:CGRectMake(10, _passwordInput.frame.origin.y + 60, frame.size.width-20, 50)];
        [_repeatInput setBackgroundColor:[UIColor whiteColor]];
        _repeatInput.title.text = @"パスワード(確認用)";
        [_repeatInput.title sizeToFit];
        _repeatInput.input.placeholder = @"6桁以上の英数字";
        _repeatInput.delegate = self;
        [_repeatInput.input setSecureTextEntry:YES];
        [_scrollView addSubview:_repeatInput];
        
        //transportation title
        UIView *transpotationTitleView = [[UIView alloc]initWithFrame:CGRectMake(10, _repeatInput.frame.origin.y + 60, frame.size.width-20, 50)];
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
        
        
        float viewLength = transpotationTitleView.frame.size.width / 4;
        
        //button group
        walkButton = [[MDKindButton alloc]initWithFrame:CGRectMake(10, transpotationTitleView.frame.origin.y + transpotationTitleView.frame.size.height-2, viewLength, viewLength)];
        [walkButton setIconImageByName:@"walkingIcon"];
        walkButton.buttonTitle.text = @"徒歩";
        [walkButton addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:walkButton];
        //button group
        bikeButton = [[MDKindButton alloc]initWithFrame:CGRectMake(walkButton.frame.origin.x + walkButton.frame.size.width - 1, transpotationTitleView.frame.origin.y + transpotationTitleView.frame.size.height-2, viewLength+1, viewLength)];
        [bikeButton setIconImageByName:@"bikeIcon"];
        bikeButton.buttonTitle.text = @"自転車";
        [bikeButton addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:bikeButton];
        //button group
        motorbikeButton = [[MDKindButton alloc]initWithFrame:CGRectMake(bikeButton.frame.origin.x + bikeButton.frame.size.width - 1, transpotationTitleView.frame.origin.y + transpotationTitleView.frame.size.height-2, viewLength + 1, viewLength)];
        [motorbikeButton setIconImageByName:@"motorbikeIcon"];
        motorbikeButton.buttonTitle.text = @"バイク";
        [motorbikeButton addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:motorbikeButton];
        //button group
        trankButton = [[MDKindButton alloc]initWithFrame:CGRectMake(motorbikeButton.frame.origin.x + motorbikeButton.frame.size.width - 1, transpotationTitleView.frame.origin.y + transpotationTitleView.frame.size.height-2, viewLength + 1, viewLength)];
        [trankButton setIconImageByName:@"trankIcon"];
        trankButton.buttonTitle.text = @"自動車";
        [trankButton addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:trankButton];
        [_scrollView addSubview:transpotationTitleView];
        
        
        //checkbox
        MDCheckBox *checkBox = [[MDCheckBox alloc]initWithFrame:CGRectMake(10, walkButton.frame.origin.y + walkButton.frame.size.height + 10, 34, 34)];
        [checkBox addTarget:self action:@selector(toggleCheck:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:checkBox];
        
        
        UIButton *userProtocol = [[UIButton alloc]initWithFrame:CGRectMake(checkBox.frame.origin.x + checkBox.frame.size.width+10, checkBox.frame.origin.y+10, 64, 14)];
        userProtocol.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:14];
        [userProtocol setTitleColor:[UIColor colorWithRed:30.0/255.0 green:132.0/255.0 blue:158.0/255.0 alpha:1] forState:UIControlStateNormal];
        [userProtocol setTitle:@"利用規約" forState:UIControlStateNormal];
        [_scrollView addSubview:userProtocol];
        
        UILabel *toLabel = [[UILabel alloc]initWithFrame:CGRectMake(userProtocol.frame.origin.x + userProtocol.frame.size.width, userProtocol.frame.origin.y, 14, 14)];
        toLabel.text = @"と";
        toLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:14];
        toLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1];
        [_scrollView addSubview:toLabel];
        
        UIButton *driverProtocol = [[UIButton alloc]initWithFrame:CGRectMake(toLabel.frame.origin.x+14, toLabel.frame.origin.y, 126, 14)];
        driverProtocol.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:14];
        [driverProtocol setTitleColor:[UIColor colorWithRed:30.0/255.0 green:132.0/255.0 blue:158.0/255.0 alpha:1] forState:UIControlStateNormal];
        [driverProtocol setTitle:@"プライバシポリシー" forState:UIControlStateNormal];
        [_scrollView addSubview:driverProtocol];
        
        UILabel *niLabel = [[UILabel alloc]initWithFrame:CGRectMake(driverProtocol.frame.origin.x + driverProtocol.frame.size.width, driverProtocol.frame.origin.y, 42, 14)];
        niLabel.text = @"に同意";
        niLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:14];
        niLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1];
        [_scrollView addSubview:niLabel];
        
        _postButton = [[UIButton alloc]initWithFrame:CGRectMake(10, checkBox.frame.origin.y + checkBox.frame.size.height + 20, frame.size.width-20, 50)];
        [_postButton setBackgroundColor:[UIColor colorWithRed:226.0/255.0 green:138.0/255.0 blue:0 alpha:1]];
        [_postButton setTitle:@"以上で登録" forState:UIControlStateNormal];
        _postButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:18];
        [_postButton addTarget:self action:@selector(postData) forControlEvents:UIControlEventTouchUpInside];
        _postButton.layer.cornerRadius = 2.5;
        [_scrollView addSubview:_postButton];
    }
    
    return self;
}

-(void) postData {

    if([self.delegate respondsToSelector:@selector(postData:)]){
        [self.delegate postData:self];

    }
}

-(void) toggleButton:(MDKindButton *)button{
    if([self.delegate respondsToSelector:@selector(toggleButton:)]){
        [self.delegate toggleButton:button];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if([self.delegate respondsToSelector:@selector(scrollDidMove:)]) {
        [self.delegate scrollDidMove:self];
    }
}

#pragma ButtonAndDescriptionView
-(void) buttonPushed:(MDButtonAndDescriptionView *)view{
    if([self.delegate respondsToSelector:@selector(openCameraForView:)]){
        [self.delegate openCameraForView:view];
    }
}

#pragma input delegate
-(void) inputPushed:(MDInput *)input{
    int offset = input.frame.origin.y + input.frame.size.height + 89 - (_scrollView.frame.size.height - 216.0);//键盘高度216
    CGPoint point = CGPointMake(0, offset);
    [_scrollView setContentOffset:point animated:YES];
}

-(void) endInput:(MDInput *)input{
    [self didClosed];
}

-(void)returnKeyPushed:(MDInput *)input{
    if([input isEqual:_repeatInput]){
        [input resignFirstResponder];
    } else {
        bool isFind = false;
        
        for (UIView *view in [_scrollView subviews]) {
            if([view isKindOfClass:[MDInput class]]){
                MDInput *tmpView = (MDInput *)view;
                if(isFind){
                    [tmpView.input becomeFirstResponder];
                    break;
                } else {
                    
                    if([input isEqual:tmpView]){
                        isFind = true;
                    }
                }
            }
        }
    }
}

-(void) toggleCheck:(MDCheckBox *)box{
    isChecked = [box toggleCheck];
}

-(BOOL)isChecked{
    return isChecked;
}

-(void)didClosed {
    // 下に空白ができたらスクロールで調整
    int scrollOffset = [_scrollView contentOffset].y;
    int contentBottomOffset = _scrollView.contentSize.height - _scrollView.frame.size.height;
    // NSLog(@"sizes: %f,%f",_scrollView.contentSize.height,_scrollView.frame.size.height);
    if(scrollOffset > contentBottomOffset){
        CGPoint point = CGPointMake(0, contentBottomOffset);
        [_scrollView setContentOffset:point animated:YES];
    }
}

-(BOOL) isAllInput{
    for (UIView *view in [_scrollView subviews]) {
        if([view isKindOfClass:[MDInput class]]){
            MDInput *tmpView = (MDInput *)view;
            if (tmpView.input.text.length > 0) {
                //
            } else {
                return NO;
            }
        }
    }
    return YES;
}

@end
