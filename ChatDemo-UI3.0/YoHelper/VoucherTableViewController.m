//
//  VoucherTableViewController.m
//  ChatDemo-UI3.0
//
//  Created by HoJolin on 16/2/16.
//  Copyright © 2016年 HoJolin. All rights reserved.
//

#import "VoucherTableViewController.h"
#import "API.h"

@interface VoucherTableViewController () <APIProtocol> {
    API *myAPI;
    NSArray *vouchers;
}

@end

@implementation VoucherTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myAPI = [[API alloc]init];
    myAPI.delegate = self;
    [myAPI getMyVouchers];
    self.title = @"代金券";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return vouchers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.view.frame.size.width;
    UITableViewCell *cell = [[UITableViewCell alloc]init];
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
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([vouchers[indexPath.section][@"del"]integerValue] == 0 && [vouchers[indexPath.section][@"endFlag"]integerValue] == 0) {
        self.vc.del = [vouchers[indexPath.section][@"rmb"]intValue];
        self.vc.voucher = [vouchers[indexPath.section][@"id"]intValue];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveAPIErrorOf:(API *)api data:(long)errorNo {
    NSLog(@"%ld", errorNo);
}

- (void)didReceiveAPIResponseOf:(API *)api data:(NSDictionary *)data {
    vouchers = data[@"result"];
    [self.tableView reloadData];
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
