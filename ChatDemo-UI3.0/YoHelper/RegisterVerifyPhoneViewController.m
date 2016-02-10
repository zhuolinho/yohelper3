//
//  RegisterVerifyPhoneViewController.m
//  ChatDemo-UI3.0
//
//  Created by HoJolin on 16/2/10.
//  Copyright © 2016年 HoJolin. All rights reserved.
//

#import "RegisterVerifyPhoneViewController.h"
#import "RegisterViewController.h"

@interface RegisterVerifyPhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

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
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
