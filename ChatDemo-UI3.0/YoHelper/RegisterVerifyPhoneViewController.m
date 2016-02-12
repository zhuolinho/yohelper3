//
//  RegisterVerifyPhoneViewController.m
//  ChatDemo-UI3.0
//
//  Created by HoJolin on 16/2/10.
//  Copyright © 2016年 HoJolin. All rights reserved.
//

#import "RegisterVerifyPhoneViewController.h"
#import "RegisterViewController.h"
#import "API.h"

@interface RegisterVerifyPhoneViewController () <APIProtocol> {
    API *sendCodeApi;
    API *checkCodeApi;
    NSString *phone;
    NSString *code;
}
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@end

@implementation RegisterVerifyPhoneViewController
- (IBAction)backButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)bgClick:(id)sender {
    [_mobileTF resignFirstResponder];
    [_codeTF resignFirstResponder];
}
- (IBAction)nextButtonClick:(id)sender {
    RegisterViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    vc.mobile = phone;
    vc.code = code;
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)codeButtonClick:(id)sender {
    if (![_mobileTF.text isEqualToString:@""]) {
        [sendCodeApi sendAuthCode:_mobileTF.text];
    }
}
- (IBAction)codeEditingChanged:(UITextField *)sender {
    if (phone && ![sender.text isEqualToString:@""]) {
        [checkCodeApi checkAuthCode:phone authCode:sender.text];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    sendCodeApi = [[API alloc]init];
    checkCodeApi = [[API alloc]init];
    sendCodeApi.delegate = self;
    checkCodeApi.delegate = self;
    _nextButton.layer.cornerRadius = 3;
    _nextButton.layer.masksToBounds = YES;
    [_nextButton setTitle:NSLocalizedString(@"Please verify phone number", @"请验证手机号") forState:UIControlStateDisabled];
    _nextButton.enabled = NO;
    [_codeButton setTitle:NSLocalizedString(@"Sent", @"已发送") forState:UIControlStateDisabled];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didReceiveAPIResponseOf:(API *)api data:(NSDictionary *)data {
    if (api == sendCodeApi) {
        NSString *res = data[@"result"];
        if ([res isEqualToString:@"wrong"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Send Failed", @"发送失败") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
            [alert show];
        } else if ([res isEqualToString:@"repeated"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Phone number repeated", @"手机号重复") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
            [alert show];
        } else {
            _mobileTF.userInteractionEnabled = NO;
            _codeButton.enabled = NO;
            phone = _mobileTF.text;
        }
    } else {
        int res = [data[@"result"]intValue];
        if (res == 1) {
            _nextButton.enabled = YES;
            code = _codeTF.text;
        }
    }
}

- (void)didReceiveAPIErrorOf:(API *)api data:(long)errorNo {
    NSLog(@"%ld", errorNo);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
