//
//  MDDeliveryListView.m
//  DistributionDriver
//
//  Created by 劉 松然 on 2015/05/07.
//  Copyright (c) 2015年 Lsr. All rights reserved.
//

#import "MDDeliveryListView.h"

@implementation MDDeliveryListView

#pragma mark - View Life Cycle

-(id) init
{
    return self;
}

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //add code
        [self setBackgroundColor:[UIColor whiteColor]];
        _deliveryTableView = [[MDDeliveryTableView alloc]initWithFrame:CGRectMake(frame.origin.x,
                                                                                frame.origin.y,
                                                                                frame.size.width,
                                                                                frame.size.height-50)];
        
        //call api
        
        [self addSubview:_deliveryTableView];
        _deliveryTableView.deliveryTableViewDelegate = self;
        
        
    }
    return self;
}

-(void) initWithArray:(NSArray *)array{
    [_deliveryTableView initWithArray:array];
}


-(void) gotoDeliveryView{
    if([self.delegate respondsToSelector:@selector(gotoDeliveryView)]) {
        [self.delegate gotoDeliveryView];
    }
}

-(void) gotoSettingView {
    if([self.delegate respondsToSelector:@selector(gotoSettingView)]) {
        [self.delegate gotoSettingView];
    }
}

-(void) didSelectedRowWithData:(NSDictionary *)data {
    if([self.delegate respondsToSelector:@selector(makeUpData:)]){
        [self.delegate makeUpData:data];
    }
}

@end
