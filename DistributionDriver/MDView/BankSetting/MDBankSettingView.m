//
//  MDBankSettingView.m
//  DistributionDriver
//
//  Created by Lsr on 5/12/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDBankSettingView.h"

@implementation MDBankSettingView{
    
    
}

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        //
        [self setBackgroundColor:[UIColor whiteColor]];
        _scrollView = [[UIScrollView alloc]initWithFrame:frame];
        
        _status = @"1";
        
        //money
        _moneyInput = [[MDInput alloc]initWithFrame:CGRectMake(10, 10, frame.size.width - 20, 50)];
        _moneyInput.title.text = @"溜まっている金額";
        [_moneyInput setMark:@"円"];
        [_moneyInput.input setKeyboardType:UIKeyboardTypeDecimalPad];
        _moneyInput.delegate = self;
        _moneyInput.tag = 1;
        [_moneyInput.title sizeToFit];
        [_scrollView addSubview:_moneyInput];
        
        //description well
        _descriptionWell = [[MDWell alloc]initWithFrame:CGRectMake(10, _moneyInput.frame.origin.y + _moneyInput.frame.size.height - 1, _moneyInput.frame.size.width, 100)];
        NSString *contentText = @"上記の金額から振込み手数料の250円引いた金額を指定の口座に入金させて頂きます。下記から口座情報を設定の上、申請を行ってください。なお、です。";
        [_descriptionWell setContentText:contentText];
        [_descriptionWell inputBolderContent:@"今回の振込予定日は、翌月25日" index: (int)contentText.length - 3];
        
        [_scrollView addSubview:_descriptionWell];
        
        //bank number
        _bankNumberInput = [[MDInput alloc]initWithFrame:CGRectMake(10, _descriptionWell.frame.origin.y + _descriptionWell.frame.size.height + 10, _descriptionWell.frame.size.width, 50)];
        _bankNumberInput.title.text = @"銀行コード";
        _bankNumberInput.input.placeholder = @"0005";
        [_bankNumberInput.input setKeyboardType:UIKeyboardTypeDecimalPad];
        [_bankNumberInput.title sizeToFit];
        _bankNumberInput.delegate = self;
        [_scrollView addSubview:_bankNumberInput];
        
        //調べるbutton
        _bankNumberSearchButton = [[UIButton alloc]initWithFrame:CGRectMake(10, _bankNumberInput.frame.origin.y + _bankNumberInput.frame.size.height + 10, _bankNumberInput.frame.size.width, 10)];
        _bankNumberSearchButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:10];
        [_bankNumberSearchButton setTitle:@">ここから銀行コードを調べる" forState:UIControlStateNormal];
        _bankNumberSearchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_bankNumberSearchButton addTarget:self action:@selector(bankNumberSearchButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [_bankNumberSearchButton setTitleColor:[UIColor colorWithRed:30.0/255.0 green:132.0/255.0 blue:158.0/255.0 alpha:1] forState:UIControlStateNormal];
        [_scrollView addSubview:_bankNumberSearchButton];
        
        //branch number
        _branchNumberInput = [[MDInput alloc]initWithFrame:CGRectMake(10, _bankNumberSearchButton.frame.origin.y + _bankNumberSearchButton.frame.size.height + 17, _bankNumberSearchButton.frame.size.width, 50)];
        _branchNumberInput.title.text = @"支店番号";
        [_branchNumberInput.title sizeToFit];
        _branchNumberInput.delegate = self;
        [_branchNumberInput.input setKeyboardType:UIKeyboardTypeDecimalPad];
        _branchNumberInput.input.placeholder = @"例）123";
        [_scrollView addSubview:_branchNumberInput];
        
        //type
        _typeSelect = [[MDSelect alloc]initWithFrame:CGRectMake(10, _branchNumberInput.frame.origin.y + _branchNumberInput.frame.size.height + 10, _branchNumberInput.frame.size.width, 50)];
        _typeSelect.buttonTitle.text = @"口座種別";
        _typeSelect.selectLabel.text = @"選択してください";
        _typeSelect.delegate = self;
        [_typeSelect setUnactive];
        [_typeSelect addTarget:self action:@selector(typeButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:_typeSelect];
        NSMutableArray *typePickerOptions = [[NSMutableArray alloc]init];
        NSMutableArray *typePickerFirstOptions = [[NSMutableArray alloc]initWithObjects:@"普通",@"当座",@"貯蓄", nil];
        [typePickerOptions addObject:typePickerFirstOptions];
        [_typeSelect setOptions:typePickerOptions :@"" :@""];
        
        
        //account number;
        _accountNumberInput = [[MDInput alloc]initWithFrame:CGRectMake(10, _typeSelect.frame.origin.y + _typeSelect.frame.size.height + 10, _typeSelect.frame.size.width, 50)];
        _accountNumberInput.title.text = @"口座番号";
        _accountNumberInput.input.placeholder = @"例）1234567";
        _accountNumberInput.delegate = self;
        [_accountNumberInput.input setKeyboardType:UIKeyboardTypeNamePhonePad];
        [_accountNumberInput.title sizeToFit];
        [_scrollView addSubview:_accountNumberInput];
        
        //名義
        _nameInput = [[MDInput alloc]initWithFrame:CGRectMake(10, _accountNumberInput.frame.origin.y + _accountNumberInput.frame.size.height + 10, _accountNumberInput.frame.size.width, 50)];
        _nameInput.title.text = @"口座名義";
        [_nameInput.title sizeToFit];
        _nameInput.input.placeholder = @"例）ヤマダタロウ";
        _nameInput.delegate = self;
        [_scrollView addSubview:_nameInput];
        
        //
        _nameDesWell = [[MDWell alloc]initWithFrame:CGRectMake(10, _nameInput.frame.origin.y + _nameInput.frame.size.height - 1, _nameInput.frame.size.width, 60)];
        [_nameDesWell setContentText:@"使用可能な文字：全角カナ, 数字, 大文字アルファベット, (, ), ー"];
        [_scrollView addSubview:_nameDesWell];
        
        _postButton = [[UIButton alloc]initWithFrame:CGRectMake(10, _nameInput.frame.origin.y + _nameInput.frame.size.height + 77, frame.size.width-20, 50)];
        [_postButton setBackgroundColor:[UIColor colorWithRed:226.0/255.0 green:138.0/255.0 blue:0 alpha:1]];
        [_postButton setTitle:@"以上で口座入金の申請をする" forState:UIControlStateNormal];
        _postButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:14];
        [_postButton addTarget:self action:@selector(postButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        _postButton.layer.cornerRadius = 2.5;
        [_scrollView addSubview:_postButton];
        
        [_scrollView setContentSize:CGSizeMake(frame.size.width, _postButton.frame.origin.y + _postButton.frame.size.height + 50)];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
    }
    
    return self;
}

#pragma input delegate
-(void) inputPushed:(MDInput *)input{
    if(input.frame.origin.y + input.frame.size.height > [UIScreen mainScreen].bounds.size.height - 266){
        int offset = input.frame.origin.y + input.frame.size.height + 89 - (_scrollView.frame.size.height - 216.0);//键盘高度216
        CGPoint point = CGPointMake(0, offset);
        [_scrollView setContentOffset:point animated:YES];
    }
}

-(void) endInput:(MDInput *)input{
    [self didClosed];
}


-(void)didClosed {
    int scrollOffset = [_scrollView contentOffset].y;
    int contentBottomOffset = _scrollView.contentSize.height - _scrollView.frame.size.height;
    
    if(contentBottomOffset > 0){
        if(scrollOffset > contentBottomOffset){
            CGPoint point = CGPointMake(0, contentBottomOffset);
            [_scrollView setContentOffset:point animated:YES];
        }
    } else {
        
        CGPoint point = CGPointMake(0, -64);
        [_scrollView setContentOffset:point animated:YES];
    }
}

-(void)returnKeyPushed:(MDInput *)input{
    input.delegate = self;
    if([input isEqual:_nameInput]){
        [input resignFirstResponder];
    } else {
        bool isFind = false;
        
        for (MDInput *view in [_scrollView subviews]) {
            if([view isKindOfClass:[MDInput class]]){
                MDInput *tmpView = view;
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

-(void) textInputting:(MDInput *)input{
}


#pragma UIScrollview delegate
// scrollView 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self closeKeyboard];
}
-(void) closeKeyboard {
    for (MDInput *view in [_scrollView subviews]) {
        if([view isKindOfClass:[MDInput class]]){
            MDInput *tmpView = view;
            [tmpView.input resignFirstResponder];
        }
    }
}

-(void) setViewData:(MDBankInfo *)bankInfo{
    
}

-(void) setMoney:(NSString *)money{
    _moneyInput.input.text = [NSString stringWithFormat:@"%@", money];
    [_moneyInput setUserInteractionEnabled:NO];
}

-(void) postButtonTouched{
    [self inputCheck];
    if([self.delegate respondsToSelector:@selector(postViewData:)]){
        [self.delegate postViewData:self];
    }
}

-(void) inputCheck {
    
    for (UIView *view in [_scrollView subviews]) {
        if([view isKindOfClass:[MDInput class]]){
            MDInput *tmpView = (MDInput *)view;
            if(tmpView.input.text.length < 1){
                _status = @"0";
            }
        } else if([view isKindOfClass:[MDSelect class]]){
            MDSelect *tmpView = (MDSelect *)view;
            if(tmpView.selectLabel.text.length < 1){
                _status = @"0";
            }
        }
    }
}

-(void) bankNumberSearchButtonTouched {
    if([self.delegate respondsToSelector:@selector(bankNumberSearchButtonPushed)]){
        [self.delegate bankNumberSearchButtonPushed];
    }
}

#pragma picker delegate

-(void) typeButtonTouched{
    [self closeKeyboard];
    _dataPicker = [[MDPicker alloc]initWithFrame:self.frame];
    _dataPicker.delegate = self;
    [self addSubview:_dataPicker];
    
    [_dataPicker setOptions:_typeSelect.options : 1 : 0];
    [_dataPicker showView];
}

-(void) didSelectedRow:(NSMutableArray *)resultList :(int)tag{
    _typeSelect.selectLabel.text = [[_typeSelect.showOptions objectAtIndex:0] objectAtIndex:[resultList[0][0] integerValue]];
    [_typeSelect setActive];
}


@end
