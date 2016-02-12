//
//  BuyGiftViewController.m
//  ChatDemo-UI3.0
//
//  Created by HoJolin on 16/2/12.
//  Copyright © 2016年 HoJolin. All rights reserved.
//

#import "BuyGiftViewController.h"
#import "API.h"

@interface BuyGiftViewController () <APIProtocol>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UITextField *addrTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@end

@implementation BuyGiftViewController
- (IBAction)buybuttonClick:(id)sender {
    if ([_mobileTF.text isEqualToString:@""] || [_nameTF.text isEqualToString:@""] || [_addrTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"姓名，电话，地址都是必填项" message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
        [alert show];
    } else {
        API *myAPI = [[API alloc]init];
        myAPI.delegate = self;
        [myAPI buyTreasure:[NSString stringWithFormat:@"%@", _data[@"id"]] addressee:_nameTF.text phone:_mobileTF.text address:_addrTF.text];
    }
}
- (IBAction)backgroundClick:(id)sender {
    [_mobileTF resignFirstResponder];
    [_addrTF resignFirstResponder];
    [_nameTF resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兑换";
    _buyButton.layer.cornerRadius = 3;
    _buyButton.layer.masksToBounds = YES;
    [_buyButton setTitle:@"确认兑换" forState:UIControlStateNormal];
    [_buyButton setTitle:@"财富值不足" forState:UIControlStateDisabled];
    _titleLabel.text = [NSString stringWithFormat:@"个人财富值: %@", [API getInfo][@"rmb"]];
    if ([[API getInfo][@"rmb"]intValue] < [_data[@"price"]intValue]) {
        _subLabel.text = [NSString stringWithFormat:@"您的账户余额不足，请努力学习赚取更多财富值"];
        _buyButton.enabled = NO;
        _buyButton.backgroundColor = [UIColor lightGrayColor];
        _mobileTF.hidden = YES;
        _addrTF.hidden = YES;
        _nameTF.hidden = YES;
    } else {
        _subLabel.text = [NSString stringWithFormat:@"使用%@去兑换该项目", _data[@"price"]];
        _buyButton.enabled = YES;
        _buyButton.backgroundColor = THEMECOLOR;
    }
    _addrTF.text = [API getInfo][@"address"];
    _nameTF.text = [API getInfo][@"nickname"];
    _mobileTF.text = [API getInfo][@"phone"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didReceiveAPIErrorOf:(API *)api data:(long)errorNo {
    NSLog(@"%ld", errorNo);
}

- (void)didReceiveAPIResponseOf:(API *)api data:(NSDictionary *)data {
    NSLog(@"%@", data);
    if ([data[@"result"]intValue] == 1) {
        [_buyButton setTitle:@"兑换成功" forState:UIControlStateNormal];
    } else {
        [_buyButton setTitle:@"兑换失败" forState:UIControlStateNormal];
    }
    _buyButton.userInteractionEnabled = NO;
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
