//
//  MDMapFilter.m
//  DistributionDriver
//
//  Created by Lsr on 5/7/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDMapFilter.h"
#import "MDSelect.h"
#import "MDInput.h"
#import "MDCurrentPackage.h"
#import "MDSwitch.h"

@implementation MDMapFilter{
    MDSelect *sizePicker;
    MDSelect *costPicker;
    MDSelect *distancePicker;
    MDSelect *destinateTimePicker;
    MDSwitch *showHistoryPicker;
    
    NSMutableArray *options;
    NSMutableArray* time;
    NSMutableArray* realDate;
    NSMutableArray* date;
    NSMutableArray *cusTodyDate;
    NSMutableArray *destinateDate;
    NSMutableArray* minute;
    NSMutableArray *cusTodyTime;
    NSMutableArray *destinateMinute;
    NSMutableArray *destinateTime;
}

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        _scrollView = [[UIScrollView alloc]initWithFrame:frame];
        [self addSubview:_scrollView];
        [_scrollView setContentSize:frame.size];
        
        //size picker
        sizePicker = [[MDSelect alloc]initWithFrame:CGRectMake(10, frame.origin.y + 10, frame.size.width-20, 50)];
        sizePicker.buttonTitle.text = @"サイズ";
        sizePicker.selectLabel.text = @"こだわらない";
        sizePicker.delegate = self;
        NSMutableArray *sizePickerOptions = [[NSMutableArray alloc]init];
        NSMutableArray *sizePickerFirstOptions = [[NSMutableArray alloc]initWithObjects:@"9999",@"60",@"80",@"100",@"120",@"140",@"160",@"180",@"200",@"220",@"240",@"260", nil];
        [sizePickerOptions addObject:sizePickerFirstOptions];
        [sizePicker setOptions:sizePickerOptions :@"合計" :@"cm以内"];
        sizePicker.tag = 0;
        [sizePicker addTarget:self action:@selector(pickerButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:sizePicker];
        
        //request amount
        costPicker = [[MDSelect alloc]initWithFrame:CGRectMake(10, sizePicker.frame.origin.y + sizePicker.frame.size.height + 10, frame.size.width-20, 50)];
        costPicker.buttonTitle.text = @"依頼金額";
        costPicker.selectLabel.text = @"こだわらない";
        costPicker.delegate = self;
        NSMutableArray *costPickerOptions = [[NSMutableArray alloc]init];
        NSMutableArray *costPickerFirstOptions = [[NSMutableArray alloc]initWithObjects:@"0",@"200",@"400",@"600",@"800",@"1000",@"1500",@"2000",@"3000",@"5000", nil];
        [costPickerOptions addObject:costPickerFirstOptions];
        [costPicker setOptions:costPickerOptions :@"" :@"円以上"];
        costPicker.tag = 1;
        [costPicker addTarget:self action:@selector(pickerButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:costPicker];
        
        //distance
        distancePicker = [[MDSelect alloc]initWithFrame:CGRectMake(10, costPicker.frame.origin.y + costPicker.frame.size.height + 10, frame.size.width-20, 50)];
        distancePicker.buttonTitle.text = @"配達距離";
        distancePicker.selectLabel.text = @"こだわらない";
        distancePicker.delegate = self;
        NSMutableArray *distancePickerOptions = [[NSMutableArray alloc]init];
        NSMutableArray *distancePickerFirstOptions = [[NSMutableArray alloc]initWithObjects:@"9999",@"50",@"40",@"30",@"20",@"10",@"5",@"3",@"1",@"0.5", nil];
        [distancePickerOptions addObject:distancePickerFirstOptions];
        [distancePicker setOptions:distancePickerOptions :@"" :@"km以内"];
        distancePicker.tag = 2;
        [distancePicker addTarget:self action:@selector(pickerButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:distancePicker];
        
        
        //list
        destinateTimePicker = [[MDSelect alloc]initWithFrame:CGRectMake(10, distancePicker.frame.origin.y + distancePicker.frame.size.height + 10, frame.size.width-20, 50)];
        destinateTimePicker.buttonTitle.text = @"お届け期限";
        destinateTimePicker.tag = 3;
        destinateTimePicker.delegate = self;
        NSMutableArray *destinateTimePickerOptions = [[NSMutableArray alloc]init];
        [self initDeliveryLimitData];
        [destinateTimePickerOptions addObject:date];
        [destinateTimePickerOptions addObject:destinateTime];
        [destinateTimePickerOptions addObject:destinateMinute];
        [destinateTimePicker setOptions:destinateTimePickerOptions :@"" :@""];
        [destinateTimePicker addTarget:self action:@selector(pickerButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:destinateTimePicker];
        destinateTimePicker.selectLabel.text = [self getInitStr];
        
        
        //switch
        showHistoryPicker = [[MDSwitch alloc]initWithFrame:CGRectMake(10, destinateTimePicker.frame.origin.y + destinateTimePicker.frame.size.height + 10, frame.size.width - 20, 50)];
        showHistoryPicker.title.text = @"終了表示";
        [showHistoryPicker.title sizeToFit];
        if([MDCurrentPackage getInstance].isShowHistory){
            showHistoryPicker.switchInput.on = YES;
        }
        [showHistoryPicker.switchInput addTarget:self action:@selector(changeShowHistory:) forControlEvents:UIControlEventValueChanged];
        [_scrollView addSubview:showHistoryPicker];
    }
    
    return self;
}

-(void) pickerButtonTouched:(MDSelect*)select {
    
    _dataPicker = [[MDPicker alloc]initWithFrame:self.frame];
    _dataPicker.delegate = self;
    [self addSubview:_dataPicker];
    
    
    if(select.tag == 0){
        [_dataPicker setOptions:sizePicker.showOptions : 1 : 0];
    } else if(select.tag == 1){
        [_dataPicker setOptions:costPicker.showOptions : 1 : 1];
    } else if(select.tag == 2){
        [_dataPicker setOptions:distancePicker.showOptions :1 : 2];
    } else if(select.tag == 3){
        [_dataPicker setOptions:destinateTimePicker.options :3 :3];
    }
    
    [_dataPicker showView];
}

#pragma MDPicker
-(void) didSelectedRow:(NSMutableArray *)resultList :(int)tag{
    
    switch (tag) {
        case 0:
            sizePicker.selectLabel.text = [[sizePicker.showOptions objectAtIndex:0] objectAtIndex:[resultList[0][0] integerValue]];
            [MDCurrentPackage getInstance].size = [[sizePicker.options objectAtIndex:0] objectAtIndex:[resultList[0][0] integerValue]];
            break;
        case 1:
            costPicker.selectLabel.text = [[costPicker.showOptions objectAtIndex:0] objectAtIndex:[resultList[0][0] integerValue]];
            [MDCurrentPackage getInstance].request_amount = [[costPicker.options objectAtIndex:0] objectAtIndex:[resultList[0][0] integerValue]];
            
            break;
        case 2:
            distancePicker.selectLabel.text = [[distancePicker.showOptions objectAtIndex:0] objectAtIndex:[resultList[0][0] integerValue]];
            [MDCurrentPackage getInstance].distance = [[distancePicker.options objectAtIndex:0] objectAtIndex:[resultList[0][0] integerValue]];
            
            break;
        case 3:
            destinateTimePicker.selectLabel.text = [NSString stringWithFormat:@"%@ %@%@迄",
                                                    [[destinateTimePicker.options objectAtIndex:0] objectAtIndex:[resultList[0][0] integerValue]],
                                                    [[destinateTimePicker.options objectAtIndex:1] objectAtIndex:[resultList[1][0] integerValue]],
                                                    [[destinateTimePicker.options objectAtIndex:2] objectAtIndex:[resultList[2][0] integerValue]]];
            
            [self convertDestinateTimeToSave:
             [realDate objectAtIndex:[resultList[0][0] integerValue]]:
             [[destinateTimePicker.options objectAtIndex:1] objectAtIndex:[resultList[1][0] integerValue]]:
             [[destinateTimePicker.options objectAtIndex:2] objectAtIndex:[resultList[2][0] integerValue]]];
            
            break;
        default:
            break;
    }
    
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


#pragma UIScrollview delegate
// scrollView 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    for (UIView *view in [scrollView subviews]) {
        if([view isKindOfClass:[MDInput class]]){
            MDInput *tmpView = (MDInput *)view;
            [tmpView.input resignFirstResponder];
        }
    }
}

-(void) initDeliveryLimitData {
    
    [self getInitStr];
    
    NSMutableArray *eightArr = [[NSMutableArray alloc] init];
    realDate = [[NSMutableArray alloc]init];
    for (int i = 0; i < 14; i ++) {
        NSTimeInterval secondsPerDay = i * 24*60*60;
        NSDate *curDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M月d日"];
        NSString *dateStr = [dateFormatter stringFromDate:curDate];
        
        
        //server date formate
        NSDateFormatter *serverDateFormatter = [[NSDateFormatter alloc]init];
        [serverDateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSString *serverStr = [serverDateFormatter stringFromDate:curDate];
        [realDate addObject:serverStr];
        
        
        //make string
        NSString *strTime = [NSString stringWithFormat:@"%@",dateStr];
        [eightArr addObject:strTime];
    }
    
    date = [NSMutableArray arrayWithArray:eightArr];
    destinateTime = [NSMutableArray arrayWithObjects:@"01時",@"02時",@"03時",@"04時",@"05時",@"06時",@"07時",@"08時",@"09時",@"10時",@"11時",@"12時",@"13時",@"14時",@"15時",@"16時",@"17時",@"18時",@"19時",@"20時",@"21時",@"22時",@"23時",@"00時", nil];
    destinateMinute = [[NSMutableArray alloc]init];
    for(int i = 0; i < 60;i++){
        [destinateMinute addObject:(i < 10) ? [NSString stringWithFormat:@"0%d分",i] :  [NSString stringWithFormat:@"%d分",i]];
    }
}

-(NSString *) getInitStr {
    NSDate *now = [NSDate date];
    NSDate *oneHoursAfter = [now dateByAddingTimeInterval:1*60*60];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter *tmpFormatter = [[NSDateFormatter alloc]init];
    [tmpFormatter setCalendar:gregorianCalendar];
    [tmpFormatter setLocale:[NSLocale systemLocale]];
    [tmpFormatter setDateFormat:@"YYYY-MM-dd HH:mm:00"];
    
    NSString *showStr;
    NSArray *tmpStr = [[tmpFormatter stringFromDate:oneHoursAfter] componentsSeparatedByString:@" "];
    NSString *dateStr = tmpStr[0];
    NSArray *dateStrArray = [dateStr componentsSeparatedByString:@"-"];
    
    NSString *timeStr = tmpStr[1];
    showStr = [NSString stringWithFormat:@"%d月%d日 %@時%@分迄",
               [dateStrArray[1] intValue],
               [dateStrArray[2] intValue],
               [timeStr componentsSeparatedByString:@":"][0],
               [timeStr componentsSeparatedByString:@":"][1]];
    return showStr;
}

-(void) convertDestinateTimeToSave:(NSString*)newDate:(NSString*)newHour:(NSString*)newMinute {
    
    NSString *stardardHour = [newHour substringToIndex:2];
    NSString *stardardMinute = [newMinute substringToIndex:2];
    
    [MDCurrentPackage getInstance].deliver_limit = [NSString stringWithFormat:@"%@ %@:%@:00",newDate, stardardHour, stardardMinute];
    NSLog(@"%@",[MDCurrentPackage getInstance].deliver_limit);
}

-(void) changeShowHistory:(UISwitch *)switchInput{
    if(switchInput.on){
        [MDCurrentPackage getInstance].isShowHistory = YES;
    } else {
        [MDCurrentPackage getInstance].isShowHistory = NO;
    }
}

@end
