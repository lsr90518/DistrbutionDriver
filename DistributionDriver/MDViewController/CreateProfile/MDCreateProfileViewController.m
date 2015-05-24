//
//  MDCreateProfileViewController.m
//  Distribution
//
//  Created by Lsr on 4/12/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDCreateProfileViewController.h"
#import "MDUser.h"
#import "MDViewController.h"
#import "MDUtil.h"
#import "MDAPI.h"
#import <SVProgressHUD.h>

@interface MDCreateProfileViewController (){
    UIActionSheet *myActionSheet;
    NSString* filePath;
    BOOL isCamera;
    
    NSString *viewTitle;
}

@end

@implementation MDCreateProfileViewController

-(void) loadView {
    [super loadView];
    
    _createProfileView = [[MDCreateProfileView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_createProfileView];
    _createProfileView.delegate = self;
    
    [self initNavigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) initNavigationBar {
    self.navigationItem.title = @"ドライバー登録";
    
    UIButton *_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setTitle:@"戻る" forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
    _backButton.frame = CGRectMake(0, 0, 25, 44);
    [_backButton addTarget:self action:@selector(backButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = leftButton;
}

-(void) backButtonTouched {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) toggleButton:(MDKindButton *)button{
    if ([button.buttonTitle.text isEqualToString:@"徒歩"]){
        [MDUser getInstance].walk = ([[button toggleButton] isEqualToString:@"On"]) ? @"1" : @"0";
    } else if([button.buttonTitle.text isEqualToString:@"バイク"]) {
        [MDUser getInstance].motorBike = ([[button toggleButton] isEqualToString:@"On"]) ? @"1" : @"0";
    } else if([button.buttonTitle.text isEqualToString:@"自転車"]) {
        [MDUser getInstance].bike = ([[button toggleButton] isEqualToString:@"On"]) ? @"1" : @"0";
    } else {
        [MDUser getInstance].car = ([[button toggleButton] isEqualToString:@"On"]) ? @"1" : @"0";
    }
}

-(void) postData:(MDCreateProfileView *)createProfileView {
    
    if(createProfileView.personButtonAndDescription.isHasPicture == NO || createProfileView.idCardButtonAndDescription.isHasPicture == NO){
        
        [MDUtil makeAlertWithTitle:@"写真がない" message:@"審査のため、写真が入ります。" done:@"ok" viewController:self];
    } else if(![createProfileView isAllInput]){
        
        [MDUtil makeAlertWithTitle:@"未入力項目" message:@"項目を全部入力してください" done:@"ok" viewController:self];
        
    } else if(createProfileView.passwordInput.input.text.length < 6){
        
        [MDUtil makeAlertWithTitle:@"パスワード" message:@"パスワードは6桁以上に設定してください" done:@"ok" viewController:self];
        
    } else if (![createProfileView.passwordInput.input.text isEqualToString:[NSString stringWithFormat:@"%@",createProfileView.repeatInput.input.text]]) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"パスワード"
                                                        message:@"パスワードをもう一回確認してください。"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        alert.delegate = self;
        [alert show];
    } else {
        MDUser *user = [MDUser getInstance];
        user.lastname = createProfileView.lastnameInput.input.text;
        user.firstname = createProfileView.givennameInput.input.text;
        user.password = createProfileView.passwordInput.input.text;
        [_createProfileView.postButton setUserInteractionEnabled:NO];
        
        
        //call api
        [SVProgressHUD show];
        [[MDAPI sharedAPI] newProfileByUser:user
                                    onComplete:^(MKNetworkOperation *completeOperation) {
                                        NSLog(@"%@", [completeOperation responseJSON]);
                                        user.userHash = [completeOperation responseJSON][@"hash"];
                                        [user setLogin];
                                        [SVProgressHUD dismiss];
                                        MDViewController *viewcontroller = [[MDViewController alloc]init];
                                        [self presentViewController:viewcontroller animated:YES completion:nil];
                                    } onError:^(MKNetworkOperation *completeOperarion, NSError *error){
                                        NSLog(@"error --------------  %@", error);
                                        [SVProgressHUD dismiss];
                                        
                                    }];
    }
    
}

-(void) scrollDidMove:(MDCreateProfileView *)createProfileView {
    [createProfileView.passwordInput.input resignFirstResponder];
    [createProfileView.repeatInput.input resignFirstResponder];
    [createProfileView.lastnameInput.input resignFirstResponder];
    [createProfileView.givennameInput.input resignFirstResponder];
}

-(void) showCreditView {
    NSLog(@"credit view");
}

#pragma picture
-(void) openCameraForView:(MDButtonAndDescriptionView *)view{
    [self openMenu];
    viewTitle = view.buttonTitle;
}

-(void)openMenu
{
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"キャンセル"
                     destructiveButtonTitle:nil
                     otherButtonTitles: @"写真を撮る", @"カメラロール",nil];
    [myActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            isCamera = YES;
            [self takePhoto];
            break;
        case 1:  //打开本地相册
            isCamera = NO;
            [self LocalPhoto];
            break;
    }
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"カメラがない");
    }
}
//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [SVProgressHUD show];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        //transfer image to data
        if (UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 0.3);
        } else {
            data = UIImagePNGRepresentation(image);
        }
        
        if(isCamera) {
            UIImageWriteToSavedPhotosAlbum(image, self, nil, NULL);
        }
                        
        if ([viewTitle isEqualToString:@"顔"]){
            [_createProfileView.personButtonAndDescription setPicture:image];
            [MDUser getInstance].imageData = data;

        } else {
            [_createProfileView.idCardButtonAndDescription setPicture:image];
            [MDUser getInstance].idImageData = data;
        }
        
        [SVProgressHUD dismiss];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        

    }
}





@end
