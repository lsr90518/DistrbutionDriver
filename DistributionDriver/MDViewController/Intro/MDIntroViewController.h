//
//  MDIntroViewController.h
//  DistributionDriver
//
//  Created by Lsr on 5/10/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDUser.h"

@interface MDIntroViewController : UIViewController<UITextViewDelegate>
@property (strong, nonatomic) UITextView *serviceInputView;
@property (strong, nonatomic) NSString *contentText;

-(void) setText:(NSString *)text;

@end
