//
//  MDJudgmentViewController.m
//  DistributionDriver
//
//  Created by Lsr on 5/23/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDJudgmentViewController.h"

@interface MDJudgmentViewController ()

@end

@implementation MDJudgmentViewController

-(void) loadView{
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2-110, 100, 104)];
    [iconImage setImage:[UIImage imageNamed:@"judgementIcon"]];
    [self.view addSubview:iconImage];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, iconImage.frame.origin.y + iconImage.frame.size.height + 30, self.view.frame.size.width, 32)];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:16];
    textLabel.textColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1];
    textLabel.text = @"ただ今、ドライバーの審査中です。";
    [self.view addSubview:textLabel];
    
    UILabel *secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, textLabel.frame.origin.y + textLabel.frame.size.height + 20, self.view.frame.size.width, 32)];
    secondLabel.font = textLabel.font;
    secondLabel.textColor = textLabel.textColor;
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.text = @"いましばらくお待ちください。";
    [self.view addSubview:secondLabel];
    
    [self initNavigationBar];
}

-(void)initNavigationBar {
    self.navigationItem.title = @"ドライバーの審査待ち";
    //add right button item
    UIButton *_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setTitle:@"戻る" forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
    _backButton.frame = CGRectMake(0, 0, 25, 44);
    [_backButton addTarget:self action:@selector(backButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = leftButton;
}

-(void) backButtonTouched{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
