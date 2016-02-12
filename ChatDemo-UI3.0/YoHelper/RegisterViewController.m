//
//  RegisterViewController.m
//  ChatDemo-UI3.0
//
//  Created by HoJolin on 16/2/10.
//  Copyright © 2016年 HoJolin. All rights reserved.
//

#import "RegisterViewController.h"
#import "EMError.h"
#import "API.h"

@interface RegisterViewController () <IChatManagerDelegate, UITextFieldDelegate, APIProtocol> {
    NSMutableDictionary *isLetterOrNumberDic;
    API *myAPI;
}

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction)doRegister:(id)sender;

@end

@implementation RegisterViewController

@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize confirmTextField = _confirmTextField;
@synthesize registerButton = _registerButton;

- (IBAction)backButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    myAPI = [[API alloc]init];
    myAPI.delegate = self;
    [self setupForDismissKeyboard];
    _usernameTextField.delegate = self;
    _passwordTextField.delegate = self;
    _registerButton.layer.cornerRadius = 3;
    _registerButton.layer.masksToBounds = YES;
    NSArray *isLetterOrNumber = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
    isLetterOrNumberDic = [[NSMutableDictionary alloc]init];
    for (NSString *c in isLetterOrNumber) {
        isLetterOrNumberDic[c] = @"";
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doRegister:(id)sender {
    if (![self isEmpty]) {
        if (_passwordTextField.text.length < 6) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"passwored should be more than 6 digits", @"密码需要至少6位") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
            [alert show];
            return;
        }
        if (![_passwordTextField.text isEqualToString:_confirmTextField.text]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"password should be same", @"两次密码输入不一致") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
            [alert show];
            return;
        }
        //隐藏键盘
        [self.view endEditing:YES];
        //判断是否是中文，但不支持中英文混编
        if ([self checkUsernameValid:self.usernameTextField.text]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"yohelper.isNotAscii", @"用户名只能包含字母和数字")
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                                  otherButtonTitles:nil];
            
            [alert show];
            return;
        }
        [self showHudInView:self.view hint:NSLocalizedString(@"register.ongoing", @"Is to register...")];
        [myAPI registerAction:_usernameTextField.text phone:_mobile password:_passwordTextField.text authCode:_code];
        //异步注册账号
    }
}

- (BOOL)isEmpty{
    BOOL ret = NO;
    NSString *username = _usernameTextField.text;
    NSString *password = _passwordTextField.text;
    if (username.length == 0 || password.length == 0) {
        ret = YES;
        [EMAlertView showAlertWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                message:NSLocalizedString(@"login.inputNameAndPswd", @"Please enter username and password")
                        completionBlock:nil
                      cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                      otherButtonTitles:nil];
    }
    
    return ret;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _usernameTextField) {
        [_usernameTextField resignFirstResponder];
        [_passwordTextField becomeFirstResponder];
    } else if (textField == _passwordTextField) {
        [_passwordTextField resignFirstResponder];
        [_confirmTextField becomeFirstResponder];
    }
    return YES;
}

- (void)didReceiveAPIErrorOf:(API *)api data:(long)errorNo {
    [self hideHud];
    TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
}

- (void)didReceiveAPIResponseOf:(API *)api data:(NSDictionary *)data {
//    NSDictionary *res = data[@"result"];
//    if (![res[@"token"] isEqual: @"wrong"]) {
    
//        [self loginWithUsername:res[@"username"] password:@"123456"];
//    }
//    else {
//        TTAlertNoTitle(NSLocalizedString(@"AuthenticationFailure", @"User name or password is incorrect."));
//    }
    NSLog(@"%@", data);
    if ([data[@"result"]isEqualToString:@"repeated"] || [data[@"result"]isEqualToString:@"huanxin_repeated"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"yohelper.wrongUser", @"该用户名无法使用") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
        [alert show];
        [self hideHud];
    } else {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:data[@"result"] forKey:@"yo_token"];
        [ud synchronize];
        [self loginWithUsername:_usernameTextField.text password:@"123456"];
    }
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    [self showHudInView:self.view hint:NSLocalizedString(@"login.ongoing", @"Is Login...")];
    //异步登陆账号
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         [self hideHud];
         if (loginInfo && !error) {
             //设置是否自动登录
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
             
             // 旧数据转换 (如果您的sdk是由2.1.2版本升级过来的，需要家这句话)
             [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             //获取数据库中数据
             [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             
             //获取群组列表
             [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
             
             //发送自动登陆状态通知
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
             
             //保存最近一次登录用户名
             [self saveLastLoginUsername];
         }
         else
         {
             switch (error.errorCode)
             {
                 case EMErrorNotFound:
                     TTAlertNoTitle(error.description);
                     break;
                 case EMErrorNetworkNotConnected:
                     TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                     break;
                 case EMErrorServerNotReachable:
                     TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                     break;
                 case EMErrorServerAuthenticationFailure:
                     TTAlertNoTitle(error.description);
                     break;
                 case EMErrorServerTimeout:
                     TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                     break;
                 default:
                     TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Login failure"));
                     break;
             }
         }
     } onQueue:nil];
}

- (void)saveLastLoginUsername
{
    NSString *username = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
        [ud synchronize];
    }
}

- (BOOL)checkUsernameValid:(NSString *)name {
    for (int i = 0; i < name.length; i++) {
        NSString *str = [NSString stringWithFormat:@"%c", [name characterAtIndex:i]];
        if (!isLetterOrNumberDic[str]) {
            return YES;
        }
    }
    return NO;
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
