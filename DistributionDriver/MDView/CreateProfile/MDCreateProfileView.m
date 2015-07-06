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
    MDKindButton    *trankButton;
    MDKindButton    *walkButton;
    MDKindButton    *bikeButton;
    MDKindButton    *motorbikeButton;
    UILabel         *warnLabel;
    UIView          *warnView;
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
        _phoneButton.tag = 3;
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
    
    //warn check
    MDCheckBox *shipCheckBox = [[MDCheckBox alloc]initWithFrame:CGRectMake(0, 0, 34, 0)];
    
    if (status != 0) {
        [shipCheckBox setFrame:CGRectMake(0, warnLabel.frame.origin.y + warnLabel.frame.size.height + 30, 34, 34)];
        //checkbox
        [shipCheckBox addTarget:self action:@selector(toggleCheck:) forControlEvents:UIControlEventTouchUpInside];
        [warnView addSubview:shipCheckBox];
        
        UILabel *shipToLabel = [[UILabel alloc]initWithFrame:CGRectMake(shipCheckBox.frame.origin.x + shipCheckBox.frame.size.width+10, shipCheckBox.frame.origin.y+10, 84, 14)];
        shipToLabel.text = @"運送に関わる";
        shipToLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:14];
        shipToLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1];
        [warnView addSubview:shipToLabel];
        
        UIButton *shipDriverProtocol = [[UIButton alloc]initWithFrame:CGRectMake(shipToLabel.frame.origin.x+shipToLabel.frame.size.width, shipToLabel.frame.origin.y, 42, 14)];
        shipDriverProtocol.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:14];
        [shipDriverProtocol setTitleColor:[UIColor colorWithRed:30.0/255.0 green:132.0/255.0 blue:158.0/255.0 alpha:1] forState:UIControlStateNormal];
        [shipDriverProtocol setTitle:@"許認可" forState:UIControlStateNormal];
        [warnView addSubview:shipDriverProtocol];
        
        UILabel *shipNiLabel = [[UILabel alloc]initWithFrame:CGRectMake(shipDriverProtocol.frame.origin.x + shipDriverProtocol.frame.size.width, shipDriverProtocol.frame.origin.y, 126, 14)];
        shipNiLabel.text = @"を保有しています。";
        shipNiLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:14];
        shipNiLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1];
        [warnView addSubview:shipNiLabel];
    }


    //checkbox
    MDCheckBox *checkBox = [[MDCheckBox alloc]initWithFrame:CGRectMake(0, shipCheckBox.frame.origin.y + shipCheckBox.frame.size.height + 10, 34, 34)];
    [checkBox addTarget:self action:@selector(toggleCheck:) forControlEvents:UIControlEventTouchUpInside];
    [warnView addSubview:checkBox];
    
    
    UIButton *userProtocol = [[UIButton alloc]initWithFrame:CGRectMake(checkBox.frame.origin.x + checkBox.frame.size.width+5, checkBox.frame.origin.y+10, 64, 14)];
    userProtocol.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:14];
    [userProtocol setTitleColor:[UIColor colorWithRed:30.0/255.0 green:132.0/255.0 blue:158.0/255.0 alpha:1] forState:UIControlStateNormal];
    [userProtocol setTitle:@"利用規約" forState:UIControlStateNormal];
    [warnView addSubview:userProtocol];
    
    UILabel *toLabel = [[UILabel alloc]initWithFrame:CGRectMake(userProtocol.frame.origin.x + userProtocol.frame.size.width, userProtocol.frame.origin.y, 14, 14)];
    toLabel.text = @"と";
    toLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:14];
    toLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1];
    [warnView addSubview:toLabel];
    
    UIButton *driverProtocol = [[UIButton alloc]initWithFrame:CGRectMake(toLabel.frame.origin.x+14, toLabel.frame.origin.y, 126, 14)];
    driverProtocol.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:14];
    [driverProtocol setTitleColor:[UIColor colorWithRed:30.0/255.0 green:132.0/255.0 blue:158.0/255.0 alpha:1] forState:UIControlStateNormal];
    [driverProtocol setTitle:@"プライバシポリシー" forState:UIControlStateNormal];
    [warnView addSubview:driverProtocol];
    
    UILabel *niLabel = [[UILabel alloc]initWithFrame:CGRectMake(driverProtocol.frame.origin.x + driverProtocol.frame.size.width, driverProtocol.frame.origin.y, 42, 14)];
    niLabel.text = @"に同意";
    niLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:14];
    niLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1];
    [warnView addSubview:niLabel];
    
    _postButton = [[UIButton alloc]initWithFrame:CGRectMake(0, checkBox.frame.origin.y + checkBox.frame.size.height + 20, warnView.frame.size.width, 50)];
    [_postButton setBackgroundColor:[UIColor colorWithRed:226.0/255.0 green:138.0/255.0 blue:0 alpha:1]];
    [_postButton setTitle:@"以上で登録" forState:UIControlStateNormal];
    _postButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:18];
    [_postButton addTarget:self action:@selector(postData) forControlEvents:UIControlEventTouchUpInside];
    _postButton.layer.cornerRadius = 2.5;
    [warnView addSubview:_postButton];
    
    [_scrollView addSubview:warnView];
    [_scrollView setContentSize:CGSizeMake(self.frame.size.width, warnView.frame.origin.y + warnView.frame.size.height + 20)];
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
        bool isFind = NO;
        
        for (UIView *view in [_scrollView subviews]) {
            if([view isKindOfClass:[MDInput class]]){
                MDInput *tmpView = (MDInput *)view;
                
                    if(isFind){
                        if(tmpView.tag == 3){
                         
                            continue;
                        } else {
                            [tmpView.input becomeFirstResponder];
                            break;
                        }
                        
                    } else {
                        
                        if([input isEqual:tmpView]){
                            isFind = YES;
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
    
    //checkbox
    for(UIView *view in [warnView subviews]){
        if ([view isKindOfClass:[MDCheckBox class]]) {
            //
            NSLog(@"count");
            MDCheckBox *tmp = (MDCheckBox *)view;
            if (![tmp isChecked]) {
                return NO;
            }
        }
    }

    return YES;
}

@end
