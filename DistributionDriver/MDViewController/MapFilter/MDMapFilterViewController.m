//
//  MDMapFilterViewController.m
//  DistributionDriver
//
//  Created by Lsr on 4/24/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDMapFilterViewController.h"
#import "MDSelect.h"
#import "MDCurrentPackage.h"
#import "MDSizeInputViewController.h"
#import "MDRequestAmountViewController.h"
#import "MDDeliveryLimitViewController.h"

@interface MDMapFilterViewController (){
    MDSelect *sizePicker;
    MDSelect *costPicker;
    MDSelect *distancePicker;
    MDSelect *destinateTimePicker;
}

@end

@implementation MDMapFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) loadView {
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _mapFilter = [[MDMapFilter alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_mapFilter];
    
    [self initNavigationBar];
}

-(void) initNavigationBar {
    self.navigationItem.title = @"絞り込み";
    //add right button item
    UIButton *_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setTitle:@"戻る" forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
    [_backButton.titleLabel sizeToFit];
    _backButton.frame = CGRectMake(0, 0, 25, 44);
    [_backButton addTarget:self action:@selector(goMap) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = leftButton;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
//    [self initViewData];
}

//-(void) initViewData {
//    [[MDCurrentPackage getInstance] initData];
//    //size
//    sizePicker.selectLabel.text = [NSString stringWithFormat:@"%@cm以内",[MDCurrentPackage getInstance].size];
//    //price
//    costPicker.selectLabel.text = [NSString stringWithFormat:@"%@円",[MDCurrentPackage getInstance].request_amount];
//    
//    destinateTimePicker.selectLabel.text = [NSString stringWithFormat:@"%@時", [[MDCurrentPackage getInstance].deliver_limit substringToIndex:13]];
//    
//    
//}

-(void) gotoSizeView:(MDSelect *)button {
    MDSizeInputViewController *siv = [[MDSizeInputViewController alloc]init];
    [siv initWithData:button.options];
    [self.navigationController pushViewController:siv animated:YES];
}

-(void) gotoRequestAmount{
    MDRequestAmountViewController *rav = [[MDRequestAmountViewController alloc]init];
    [self.navigationController pushViewController:rav animated:YES];
}

-(void) gotoDestinateView {
    MDDeliveryLimitViewController *dlvc = [[MDDeliveryLimitViewController alloc]init];
    [self.navigationController pushViewController:dlvc animated:YES];
}

-(void) goMap {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
