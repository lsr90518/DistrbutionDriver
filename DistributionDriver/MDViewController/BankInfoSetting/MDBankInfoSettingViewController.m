//
//  MDBankInfoSettingViewController.m
//  DistributionDriver
//
//  Created by Lsr on 5/12/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDBankInfoSettingViewController.h"
#import "MDBankSearchViewController.h"
#import "MDRealmBankInfo.h"

@interface MDBankInfoSettingViewController (){
    
    MDBankInfo         *bankInfo;
    MDBankSettingView  *bankSettingView;
}

@end

@implementation MDBankInfoSettingViewController

- (void)loadView {
    [super loadView];
    
    
    bankSettingView = [[MDBankSettingView alloc]initWithFrame:self.view.frame];
    bankSettingView.delegate = self;
    [self.view addSubview:bankSettingView];
    
    
    [self initNavigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    bankInfo = [[MDBankInfo alloc]init];
    [bankSettingView setMoney:[MDUser getInstance].deposit];
    [self loadBankInfo];
    
    [bankSettingView setViewData:bankInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initNavigationBar {
    self.navigationItem.title = @"口座入金の申請";
    //add right button item
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

-(void) postViewData:(MDBankSettingView *)viewData{
    
    if([viewData.status intValue] == 0){
        [MDUtil makeAlertWithTitle:@"未完成" message:@"残る項目を入力してください。" done:@"OK" viewController:self];
    } else {
        bankInfo.bank_number = viewData.bankNumberInput.input.text;
        bankInfo.branch_number = viewData.branchNumberInput.input.text;
        bankInfo.account_number = viewData.accountNumberInput.input.text;
        [bankInfo setType:viewData.typeSelect.selectLabel.text];
        bankInfo.name = viewData.nameInput.input.text;
        
        if([self inputCheck:bankInfo] == 0){
            //make bankInfo
            
            [SVProgressHUD show];
            //call api
            [[MDAPI sharedAPI] setBankAccountWithHash:[MDUser getInstance].userHash
                                            bankInfo:bankInfo
                                           OnComplete:^(MKNetworkOperation *complete) {
                                               switch ([[complete responseJSON][@"code"] intValue]) {
                                                   case 2:
                                                       [SVProgressHUD dismiss];
                                                       [MDUtil makeAlertWithTitle:@"エラー" message:@"改めてログインしてください。" done:@"OK" viewController:self];
                                                       break;
                                                   case 3:
                                                       [SVProgressHUD dismiss];
                                                       [MDUtil makeAlertWithTitle:@"エラー" message:@"口座名義に使用できない文字が含まれています。" done:@"OK" viewController:self];
                                                       break;
                                                    case 0:
                                                       //call api
                                                       [self saveBankInfo];
                                                       [self requestWithdrawDeposit:viewData.moneyInput.input.text];
                                                       break;
                                                   default:
                                                       break;
                                               }
                                               
                                            } onError:^(MKNetworkOperation *operation, NSError *error) {
                                                //
                                            }];
        } else {
            [MDUtil makeAlertWithTitle:@"エラー" message:@"入力エラー。" done:@"OK" viewController:self];
        }
    }
}

-(void) requestWithdrawDeposit:(NSString *)amount{
    [SVProgressHUD show];
    [[MDAPI sharedAPI] requestWithDrawDepositWithHash:[MDUser getInstance].userHash
                                                amount:amount
                                            OnComplete:^(MKNetworkOperation *complete) {
                                               
                                                switch ([[complete responseJSON][@"code"] intValue]) {
                                                    case 2:
                                                        [MDUtil makeAlertWithTitle:@"エラー" message:@"改めてログインしてください。" done:@"OK" viewController:self];
                                                        break;
                                                    case 3:
                                                        [MDUtil makeAlertWithTitle:@"エラー" message:@"残高不足。" done:@"OK" viewController:self];
                                                        break;
                                                    case 4:
                                                        [MDUtil makeAlertWithTitle:@"エラー" message:@"引き出し最低額に満たない。" done:@"OK" viewController:self];
                                                        break;
                                                    case 5:
                                                        [MDUtil makeAlertWithTitle:@"エラー" message:@"銀行口座が登録されていない。" done:@"OK" viewController:self];
                                                        break;
                                                    case 0:
                                                        [SVProgressHUD showWithStatus:@"申請が成功しました！" maskType:SVProgressHUDMaskTypeGradient];
                                                        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(backButtonTouched) name:SVProgressHUDDidDisappearNotification object: nil];
                                                    default:
                                                        break;
                                                }
                                            } onError:^(MKNetworkOperation *operation, NSError *error) {
                                                //
                                            }];
}

-(int) inputCheck:(MDBankInfo *)bank {
    int flag = 0;
    if (bank.account_number.length < 8) {
        int zeroCount = 7 - (int)bank.account_number.length;
        if(zeroCount != 0){
            NSMutableString *account_number_stardard = [[NSMutableString alloc]initWithString:@"0000000"];
            [account_number_stardard replaceCharactersInRange:NSMakeRange(zeroCount, bank.account_number.length) withString:bank.account_number];
        }
    } else {
        flag = flag + 1;
    }
    
    
    return flag;
}

-(void) bankNumberSearchButtonPushed {
    MDBankSearchViewController *bsvc = [[MDBankSearchViewController alloc]init];
    [self presentViewController:bsvc animated:YES completion:nil];
}

-(void) saveBankInfo{
    [[NSFileManager defaultManager] removeItemAtPath:[RLMRealm defaultRealmPath] error:nil];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    MDRealmBankInfo *rBankInfo = [[MDRealmBankInfo alloc]init];
    rBankInfo.account_number = bankInfo.account_number;
    rBankInfo.branch_number = bankInfo.branch_number;
    rBankInfo.bank_number = bankInfo.bank_number;
    rBankInfo.name = bankInfo.name;
    rBankInfo.type = [bankInfo getType];
    
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:rBankInfo];
    [realm commitWriteTransaction];
}
-(void) loadBankInfo{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    RLMResults *oldBankInfo = [MDRealmBankInfo allObjectsInRealm:realm];
    
    for(MDRealmBankInfo *tmp in oldBankInfo){
        bankInfo.account_number = tmp.account_number;
        bankInfo.branch_number = tmp.branch_number;
        bankInfo.bank_number = tmp.bank_number;
        bankInfo.name = tmp.name;
        [bankInfo setType:tmp.type];
    }
}


@end

