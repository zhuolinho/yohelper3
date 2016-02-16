//
//  PayTableViewController.m
//  ChatDemo-UI3.0
//
//  Created by HoJolin on 16/2/16.
//  Copyright © 2016年 HoJolin. All rights reserved.
//

#import "PayTableViewController.h"
#import "API.h"
#import "AppDelegate.h"
#import "VoucherTableViewController.h"
#import "AlipayHeader.h"
#import "payRequsestHandler.h"

@interface PayTableViewController () <WXApiDelegate, AlipayDelegate>

@end

@implementation PayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首席语伴";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, self.view.frame.size.width - 20, 45)];
    logoutButton.layer.cornerRadius = 5;
    logoutButton.layer.masksToBounds = YES;
    logoutButton.backgroundColor = THEMECOLOR;
    [logoutButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(payButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView.tableFooterView addSubview:logoutButton];
    _voucher = -1;
    _del = 0;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).payVC = self;
    [AlipayRequestConfig setDelegate:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    } else {
        return 44;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"FirstCell" forIndexPath:indexPath];
        UIImageView *avatarView = [cell viewWithTag:999];
        avatarView.layer.cornerRadius = 20;
        avatarView.layer.masksToBounds = YES;
        NSString *savedFile = [API getAvatarByKey:_username];
        if ([API getPicByKey:savedFile]) {
            avatarView.image = [API getPicByKey:savedFile];
        } else {
            avatarView.image = [UIImage imageNamed:@"DefaultAvatar"];
            NSString *str = [NSString stringWithFormat:@"%@%@", HOST, savedFile];
            NSURL *url = [NSURL URLWithString:str];
            NSURLRequest *requst = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                if (connectionError == nil) {
                    UIImage *img = [UIImage imageWithData:data];
                    if (img) {
                        [API setPicByKey:savedFile pic:img];
                        avatarView.image = img;
                    }
                }
            }];
        }
        UILabel *textLabel = [cell viewWithTag:888];
        textLabel.text = [NSString stringWithFormat:@"首席语伴：%@ 有效期：5天", [API getNameByKey:_username]];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SectionCell" forIndexPath:indexPath];
        if (indexPath.row == 1) {
            cell.textLabel.text = @"应付金额";
            cell.detailTextLabel.text = @"30元";
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"代金券";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.textLabel.text = @"实际金额";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d元", 30 - _del];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    // Configure the cell...
    
    return cell;
}

- (void)AlipayRequestBack:(NSDictionary *)result {
    if ([result[@"resultStatus"] isEqualToString:@"9000"]) {
        [self.navigationController popViewControllerAnimated:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"yohelper.success", @"设置成功") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
        [alert show];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        VoucherTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VoucherTableViewController"];
        vc.vc = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)payButtonClick {
    if (_isWX) {
        payRequsestHandler *reg = [[payRequsestHandler alloc]init];
        [reg setKey:PARTNER_ID];
        NSString *notifyURL = [NSString stringWithFormat:@"%@_%@_%d_%d_", [API getInfo][@"uid"], [API getUidByKey:_username], _voucher, 30 - _del];
        NSDictionary *dict = [reg sendPay_demo:@"首席语伴" order_price:[NSString stringWithFormat:@"%d", 3000 - _del * 100] notify_url:notifyURL];
        if (dict) {
            PayReq *req = [[PayReq alloc]init];
            req.openID = dict[@"appid"];
            req.partnerId = dict[@"partnerid"];
            req.prepayId = dict[@"prepayid"];
            req.nonceStr = dict[@"noncestr"];
            req.timeStamp = [dict[@"timestamp"]unsignedIntValue];
            req.package = dict[@"package"];
            req.sign = dict[@"sign"];
            [WXApi sendReq:req];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"服务器繁忙" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *yo_token = [ud objectForKey:@"yo_token"];
        [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:[NSString stringWithFormat:@"%.0f", [NSDate timeIntervalSinceReferenceDate]] productName:@"首席语伴" productDescription:@"外语帮手" amount:[NSString stringWithFormat:@"%d", 30 - _del] notifyURL:[NSString stringWithFormat:@"%@/yozaii2/api/addCollectionTeacher.action?token=%@&teacherUID=%@", HOST, yo_token, [API getUidByKey:_username]] itBPay:@"30m"];
    }
}

- (void)onResp:(BaseResp *)resp {
    if (resp.errCode == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"yohelper.success", @"设置成功") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
        [alert show];
    }
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
