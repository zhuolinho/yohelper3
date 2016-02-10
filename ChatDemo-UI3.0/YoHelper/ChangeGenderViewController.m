//
//  ChangeGenderViewController.m
//  ChatDemo-UI3.0
//
//  Created by HoJolin on 16/2/9.
//  Copyright © 2016年 HoJolin. All rights reserved.
//

#import "ChangeGenderViewController.h"
#import "API.h"

@interface ChangeGenderViewController () <APIProtocol> {
    API *myAPI;
}

@end

@implementation ChangeGenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"yohelper.setGender", @"设置性别");
    myAPI = [[API alloc]init];
    myAPI.delegate = self;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"男";
        if ([_gender isEqualToString:@"M"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else {
        cell.textLabel.text = @"女";
        if ([_gender isEqualToString:@"F"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *gender;
    if (indexPath.row == 0) {
        gender = @"M";
    } else {
        gender = @"F";
    }
    [myAPI setGender:gender];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveAPIErrorOf:(API *)api data:(long)errorNo {
    NSLog(@"%ld", errorNo);
}

- (void)didReceiveAPIResponseOf:(API *)api data:(NSDictionary *)data {
    [self.navigationController popViewControllerAnimated:YES];
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
