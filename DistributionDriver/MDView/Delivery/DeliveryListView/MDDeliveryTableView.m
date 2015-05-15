//
//  MDDeliveryTableView.m
//  DistributionDriver
//
//  Created by 劉 松然 on 2015/05/07.
//  Copyright (c) 2015年 Lsr. All rights reserved.
//

#import "MDDeliveryTableView.h"
#import "MDDeliveryTableViewCell.h"

@implementation MDDeliveryTableView {
    NSMutableArray *dataArray;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //delegate
        self.delegate = self;
        self.dataSource = self;
        self.separatorColor = [UIColor whiteColor];
    }
    
    return self;
}

-(void) initWithArray:(NSArray *)array{
    //ここ
    dataArray = [[NSMutableArray alloc]initWithArray:array];
    [self reloadData];
}


#pragma mark - TableView
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDDeliveryTableViewCell *cell = [self dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[MDDeliveryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(MDDeliveryTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell initCellWithData:dataArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self sendData:[dataArray objectAtIndex:indexPath.row]];
    NSLog(@"did select");
}

-(void) sendData:(NSDictionary *)data{
    NSLog(@"did send");
    if([self.deliveryTableViewDelegate respondsToSelector:@selector(didSelectedRowWithData:)]){
        [self.deliveryTableViewDelegate didSelectedRowWithData:data];
    }
}

@end
