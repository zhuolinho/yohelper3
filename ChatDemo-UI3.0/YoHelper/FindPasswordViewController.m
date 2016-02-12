//
//  FindPasswordViewController.m
//  ChatDemo-UI3.0
//
//  Created by HoJolin on 16/2/10.
//  Copyright © 2016年 HoJolin. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "API.h"

@interface FindPasswordViewController () <APIProtocol, UIAlertViewDelegate> {
    API *myAPI;
}
@property (weak, nonatomic) IBOutlet UIButton *findButton;
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;

@end

@implementation FindPasswordViewController
- (IBAction)backButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _findButton.layer.cornerRadius = 3;
    _findButton.layer.masksToBounds = YES;
    myAPI = [[API alloc]init];
    myAPI.delegate = self;
    // Do any additional setup after loading the view.
}
- (IBAction)findButtonClick:(id)sender {
    if (![_mobileTF.text isEqualToString:@""]) {
        [myAPI findPassword:_mobileTF.text];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didReceiveAPIErrorOf:(API *)api data:(long)errorNo {
    NSLog(@"%ld", errorNo);
}

- (void)didReceiveAPIResponseOf:(API *)api data:(NSDictionary *)data {
    int res = [data[@"result"]intValue];
    if (res == 1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Back to login", @"返回登录") message:NSLocalizedString(@"new password has been sent to your phone", @"新的密码已经发到你的手机") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
        [alert show];
    } else if (res == -1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Phone number doesn't exit", @"号码不存在") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
        [alert show];
    } else if (res == -4) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Wrong format", @"手机号格式不对") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
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
