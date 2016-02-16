//
//  DiscoverTableViewController.m
//  ChatDemo-UI3.0
//
//  Created by HoJolin on 16/2/11.
//  Copyright © 2016年 HoJolin. All rights reserved.
//

#import "DiscoverTableViewController.h"
#import "API.h"
#import "BuyGiftViewController.h"

@interface DiscoverTableViewController () <APIProtocol> {
    API *refreshRecent;
    API *refreshAds;
    API *getInfo;
    NSArray *vouchers;
    NSArray *treasures;
    UITextField *inviteTF;
    API *addInviteCode;
    UITextField *phoneTF;
    UITextField *codeTF;
    API *sendCodeApi;
    UIButton *codeButton;
    API *checkCodeApi;
    API *lottery;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *discoverSegmentedControl;

@end

@implementation DiscoverTableViewController

- (IBAction)discoverSegmentedControlChanged:(UISegmentedControl *)sender {
    [self.tableView reloadData];
    if (_discoverSegmentedControl.selectedSegmentIndex == 0) {
        [getInfo getMyInfo];
    } else if (_discoverSegmentedControl.selectedSegmentIndex == 1) {
        [refreshRecent getMyVouchers];
    } else {
        [refreshAds getTreasures];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self discoverSegmentedControlChanged:_discoverSegmentedControl];
    refreshRecent = [[API alloc]init];
    refreshRecent.delegate = self;
    refreshAds = [[API alloc]init];
    refreshAds.delegate = self;
    getInfo = [[API alloc]init];
    getInfo.delegate = self;
    addInviteCode = [[API alloc]init];
    addInviteCode.delegate = self;
    sendCodeApi = [[API alloc]init];
    sendCodeApi.delegate = self;
    checkCodeApi = [[API alloc]init];
    checkCodeApi.delegate = self;
    lottery = [[API alloc]init];
    lottery.delegate = self;
//    self.tableView.scrollEnabled = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [getInfo getMyInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    if (_discoverSegmentedControl.selectedSegmentIndex == 1) {
        return vouchers.count;
    } else if (_discoverSegmentedControl.selectedSegmentIndex == 2) {
        return treasures.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if (_discoverSegmentedControl.selectedSegmentIndex == 2) {
        return 2;
    }
    return 1;
}

- (void)didReceiveAPIErrorOf:(API *)api data:(long)errorNo {
    NSLog(@"%ld", errorNo);
}

- (void)didReceiveAPIResponseOf:(API *)api data:(NSDictionary *)data {
    if (api == getInfo) {
        [API setInfo:data[@"result"]];
        NSString *avatar = [API getInfo][@"avatar"];
        [API setAvatarByKey:[API getInfo][@"username"] name:avatar];
        [self.tableView reloadData];
    } else if (api == refreshRecent) {
        vouchers = data[@"result"];
        [self.tableView reloadData];
    } else if (api == refreshAds) {
        treasures = data[@"result"];
        [self.tableView reloadData];
    } else if (api == addInviteCode) {
        if ([data[@"result"]intValue] == 1) {
            [getInfo getMyInfo];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"邀请码已激活" message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"邀请码不存在" message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
            [alert show];
        }
    } else if (api == sendCodeApi) {
        NSString *res = data[@"result"];
        if ([res isEqualToString:@"wrong"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Send Failed", @"发送失败") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
            [alert show];
        } else if ([res isEqualToString:@"repeated"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Phone number repeated", @"手机号重复") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
            [alert show];
        } else {
            codeButton.enabled = NO;
        }
    } else if (api == checkCodeApi) {
        if ([data[@"result"]intValue] == 1) {
            [getInfo getMyInfo];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"绑定成功" message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
            [alert show];
        }
    } else if (api == lottery) {
        int error = [data[@"result"][@"error"]intValue];
        if (error == 0) {
            NSString *title = [NSString stringWithFormat:@"恭喜你获得%@财富值", data[@"result"][@"lottery"]];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
            [alert show];
        } else if (error == 1) {
            NSString *title = [NSString stringWithFormat:@"恭喜你获得%@元代金券", data[@"result"][@"voucher"]];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"很抱歉，你这次没抽中" message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_discoverSegmentedControl.selectedSegmentIndex == 0) {
        return 0.1;
    } else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_discoverSegmentedControl.selectedSegmentIndex == 0) {
        return self.view.frame.size.width / 320 * 465;
    } else if (_discoverSegmentedControl.selectedSegmentIndex == 1) {
        return 93;
    } else {
        if (indexPath.row == 0) {
            return self.view.frame.size.width;
        } else {
            return 50;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (_discoverSegmentedControl.selectedSegmentIndex == 0) {
        cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat width = self.view.frame.size.width;
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, self.view.frame.size.width / 320 * 465)];
        imgView.image = [UIImage imageNamed:@"bg"];
        [cell addSubview:imgView];
        UIButton *lotteryButton = [[UIButton alloc]initWithFrame:CGRectMake(width / 2 - 100, 100, 200, 30)];
        [lotteryButton setTitle:@"每日签到" forState:UIControlStateNormal];
        [lotteryButton setBackgroundImage:[UIImage imageNamed:@"提交"] forState:UIControlStateNormal];
        [lotteryButton addTarget:self action:@selector(lotteryButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:lotteryButton];
        inviteTF = [[UITextField alloc]initWithFrame:CGRectMake(width / 2 - 100, 150, 150, 30)];
        inviteTF.placeholder = @"邀请码";
        inviteTF.borderStyle = UITextBorderStyleRoundedRect;
        inviteTF.autocorrectionType = UITextAutocorrectionTypeNo;
        inviteTF.keyboardType = UIKeyboardTypeASCIICapable;
        inviteTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake(width / 2 + 50, 150, 50, 30)];
        [sendButton setTitle:@"确定" forState:UIControlStateNormal];
        [sendButton setBackgroundImage:[UIImage imageNamed:@"提交"] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
        if ([[API getInfo][@"flagInviteCode"]integerValue] == 0) {
            [cell addSubview:inviteTF];
            [cell addSubview:sendButton];
        }
    } else if (_discoverSegmentedControl.selectedSegmentIndex == 1) {
        CGFloat width = self.view.frame.size.width;
        cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(width / 2 - 133, 0, 266, 93)];
        imgView.image = [UIImage imageNamed:@"代金券背景"];
        [cell addSubview:imgView];
        UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(width / 2 - 133, 0, 100, 93)];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.text = [NSString stringWithFormat:@"¥%@", vouchers[indexPath.section][@"rmb"]];
        numLabel.font = [UIFont systemFontOfSize:30];
        numLabel.textColor = THEMECOLOR;
        [cell addSubview:numLabel];
        UILabel *ruleLabel = [[UILabel alloc]initWithFrame:CGRectMake(width / 2 - 33, 20, 166, 21)];
        ruleLabel.textColor = [UIColor lightGrayColor];
        ruleLabel.text = @"可直接抵消微信支付或支付宝现金";
        ruleLabel.font = [UIFont systemFontOfSize:10];
        ruleLabel.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:ruleLabel];
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(width / 2 - 33, 50, 166, 21)];
        timeLabel.textColor = [UIColor lightGrayColor];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *endTime = [formatter dateFromString:vouchers[indexPath.section][@"endTime"]];
        formatter.dateFormat = @"yyyy-MM-dd";
        timeLabel.text = [NSString stringWithFormat:@"有效期至%@", [formatter stringFromDate:endTime]];
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:timeLabel];
    } else {
        if (indexPath.row == 1) {
            cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton *buyBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 70, 15, 65, 30)];
            buyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [buyBtn setTitle:@"兑换" forState:UIControlStateNormal];
            buyBtn.backgroundColor = THEMECOLOR;
            [buyBtn addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            buyBtn.tag = indexPath.section;
            if ([treasures[indexPath.section][@"rest"]integerValue] == 0) {
                buyBtn.enabled = NO;
                buyBtn.backgroundColor = [UIColor lightGrayColor];
                [buyBtn setTitle:@"库存不足" forState:UIControlStateNormal];
            }
            [cell addSubview:buyBtn];
            UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 100, 20)];
            priceLabel.textColor = THEMECOLOR;
            priceLabel.text = [NSString stringWithFormat:@"价格: %@元", treasures[indexPath.section][@"price"]];
            priceLabel.font = [UIFont systemFontOfSize:13];
            [cell addSubview:priceLabel];
            UILabel *stockLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 15, 100, 20)];
            stockLabel.textColor = THEMECOLOR;
            stockLabel.text = [NSString stringWithFormat:@"库存: %@个", treasures[indexPath.section][@"rest"]];
            stockLabel.font = [UIFont systemFontOfSize:13];
            [cell addSubview:stockLabel];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ImgCell" forIndexPath:indexPath];
            UIImageView *imgView = [cell viewWithTag:999];
            NSString *savedFile = treasures[indexPath.section][@"pics"];
            if ([API getPicByKey:savedFile]) {
                imgView.image = [API getPicByKey:savedFile];
            } else {
                imgView.image = [UIImage imageNamed:@"DefaultAvatar"];
                NSString *str = [NSString stringWithFormat:@"%@%@", HOST, savedFile];
                NSURL *url = [NSURL URLWithString:str];
                NSURLRequest *requst = [NSURLRequest requestWithURL:url];
                [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                    if (connectionError == nil) {
                        UIImage *img = [UIImage imageWithData:data];
                        if (img) {
                            [API setPicByKey:savedFile pic:img];
                            imgView.image = img;
                        }
                    }
                }];
            }

        }
    }
    
    // Configure the cell...
    
    return cell;
}

- (void)lotteryButtonClick {
    if ([[API getInfo][@"lotteryValue"]intValue] <= 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"今日机会已用，请您明天再来！" message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
        [alert show];
    } else if ([[API getInfo][@"flagPhone"]intValue] == 1) {
        [lottery addLotteryRecord];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"绑定手机，抽取大奖" message:@"\n\n\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
        phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 64, 250, 30)];
        phoneTF.borderStyle = UITextBorderStyleRoundedRect;
        phoneTF.placeholder = @"手机号";
        phoneTF.keyboardType = UIKeyboardTypePhonePad;
        [alert.view addSubview:phoneTF];
        codeTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 104, 200, 30)];
        codeTF.borderStyle = UITextBorderStyleRoundedRect;
        codeTF.placeholder = @"验证码";
        codeTF.keyboardType = UIKeyboardTypeNumberPad;
        [alert.view addSubview:codeTF];
        codeButton = [[UIButton alloc]initWithFrame:CGRectMake(210, 104, 50, 30)];
        [codeButton setTitle:@"获取" forState:UIControlStateNormal];
        [codeButton addTarget:self action:@selector(codeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [codeButton setTitleColor:THEMECOLOR forState:UIControlStateNormal];
        [codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [alert.view addSubview:codeButton];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        UIAlertAction *bind = [UIAlertAction actionWithTitle:@"绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (![self->phoneTF.text isEqualToString:@""] && ![self->codeTF.text isEqualToString:@""]) {
                [self->checkCodeApi addPhoneWithVerification:self->phoneTF.text verifyCode:self->codeTF.text];
            }
        }];
        [alert addAction:bind];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)codeButtonClick {
    [phoneTF resignFirstResponder];
    [codeTF resignFirstResponder];
    if (![phoneTF.text isEqualToString:@""]) {
        [sendCodeApi sendAuthCode:phoneTF.text];
    }
}

- (void)sendButtonClick {
    [addInviteCode addLotteryValueWithInviteCode:inviteTF.text];
}

- (void)buyButtonTapped:(UIButton *)button {
    BuyGiftViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BuyGiftViewController"];
    vc.data = treasures[button.tag];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [inviteTF resignFirstResponder];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
