//
//  MDHistoryCell.m
//  DistributionDriver
//
//  Created by Lsr on 5/10/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDHistoryCell.h"

@implementation MDHistoryCell{
    MDReviewWell      *previewWell;
}

#pragma mark - Init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) initView {
    previewWell = [[MDReviewWell alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100)];
    [previewWell setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:previewWell];
}

-(void) setDataWithReview:(MDReview *)review{
    [previewWell setDataWithTitle:review.name star:[review.star integerValue] text:review.text];
}

@end
