//
//  MDReviewView.m
//  DistributionDriver
//
//  Created by 劉 松然 on 2015/05/08.
//  Copyright (c) 2015年 Lsr. All rights reserved.
//

#import "MDReviewView.h"
#import "MDWell.h"
#import "MDStarRatingBar.h"

@implementation MDReviewView{
    UIScrollView    *scrollView;
//    UIView          *reviewView;
    MDStarRatingBar *reviewView;
    UIView          *commentView;
    UITextView      *commentTextView;
    UIButton        *postButton;
    
    BOOL isNotTyping;
}

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //add code
        [self setBackgroundColor:[UIColor whiteColor]];
        scrollView = [[UIScrollView alloc]initWithFrame:frame];
        
        [scrollView setContentSize:CGSizeMake(frame.size.width, frame.size.height-44)];
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        //well
        MDWell *descriptionWell = [[MDWell alloc]initWithFrame:CGRectMake(10, 10, frame.size.width - 20, 82)];
        [descriptionWell setContentText:@"配送お疲れ様でした。今回の配送に関して、依頼者への評価をして配達を完了させてください。両者の評価が完了すると、評価が公開されます。"];
        [scrollView addSubview:descriptionWell];
        
        //review view
        _rating = @"5";
        reviewView = [[MDStarRatingBar alloc]initWithFrame:CGRectMake(descriptionWell.frame.origin.x, descriptionWell.frame.origin.y + descriptionWell.frame.size.height + 10, descriptionWell.frame.size.width, 74)];
        reviewView.layer.cornerRadius = 1;
        reviewView.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1].CGColor;
        reviewView.layer.borderWidth = 0.5;
        [reviewView setRating:[_rating integerValue]];
        
        [scrollView addSubview:reviewView];
        
        
        commentView = [[UIView alloc]initWithFrame:CGRectMake(reviewView.frame.origin.x, reviewView.frame.origin.y + reviewView.frame.size.height + 10, reviewView.frame.size.width, 100)];
        commentView.layer.cornerRadius = 1;
        commentView.layer.borderWidth = 0.5;
        commentView.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1].CGColor;
        [scrollView addSubview:commentView];
        
        commentTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, commentView.frame.size.width-20, commentView.frame.size.height - 20)];
        commentTextView.text = @"フリーコメント";
        commentTextView.textColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
        commentTextView.delegate = self;
        [commentView addSubview:commentTextView];
        
        //button
        postButton = [[UIButton alloc]initWithFrame:CGRectMake(10, commentView.frame.origin.y + commentView.frame.size.height + 10, commentView.frame.size.width, 50)];
        [postButton setTitle:@"依頼者を評価して配達を完了する" forState:UIControlStateNormal];
        postButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:14];
        [postButton setBackgroundColor:[UIColor colorWithRed:226.0/255.0 green:138.0/255.0 blue:0 alpha:1]];
        postButton.layer.cornerRadius = 2.5;
        [postButton addTarget:self action:@selector(postButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:postButton];
        isNotTyping = YES;
        
    }
    
    return self;
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    if(isNotTyping){
        textView.text = @"";
        isNotTyping = NO;
    }
    
    textView.textColor = [UIColor blackColor];
    CGPoint textViewPoint = CGPointMake(0, textView.frame.origin.y + 100);
    [scrollView setContentOffset:textViewPoint animated:YES];
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if(textView.text.length < 1){
        textView.text = @"フリーコメント";
        textView.textColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
        isNotTyping = YES;
    }
    
    int scrollOffset = [scrollView contentOffset].y;
    int contentBottomOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if(scrollOffset > contentBottomOffset){
        CGPoint point = CGPointMake(0, contentBottomOffset);
        [scrollView setContentOffset:point animated:YES];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [commentTextView resignFirstResponder];
}

-(void) postButtonTouched{
    [commentTextView resignFirstResponder];
    
    _rating = [NSString stringWithFormat:@"%lu",reviewView.rating];
    _reviewText = ([commentTextView.text isEqualToString:@"フリーコメント"]) ? @"" : commentTextView.text;
    if([self.delegate respondsToSelector:@selector(postButtonPushed)]){
        [self.delegate postButtonPushed];
    }
}

-(void) initWithData:(MDReview *)review{
    
    NSString *reviewText = [NSString stringWithFormat:@"%@", review.text];
    
    if(![reviewText isEqualToString:@"<null>"]){
        commentTextView.text = review.text;
        commentTextView.textColor = [UIColor blackColor];
        isNotTyping = NO;
    } else {
        isNotTyping = YES;
    }
    
    NSString *reviewStar = [NSString stringWithFormat:@"%@", review.star];
    if(![reviewStar isEqualToString:@"<null>"]){
        [reviewView setRating:[review.star integerValue]];
        
    }
    
    
}

@end
