//
//  ChangePasswordViewController.m
//  ChatDemo-UI3.0
//
//  Created by HoJolin on 16/2/9.
//  Copyright © 2016年 HoJolin. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "API.h"

@interface ChangePasswordViewController () <APIProtocol> {
    API *myAPI;
}
@property (weak, nonatomic) IBOutlet UITextField *myTF;
@property (weak, nonatomic) IBOutlet UITextField *urTF;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonClick)];
    myAPI = [[API alloc]init];
    myAPI.delegate = self;
    self.title = NSLocalizedString(@"yohelper.changePassword", @"修改密码");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveButtonClick {
    if ([_myTF.text isEqualToString:@""] || [_urTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"password cannot be empty", @"密码不能为空") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
        [alert show];
    } else if (_urTF.text.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"passwored should be more than 6 digits", @"密码需要至少6位") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
        [alert show];
    } else {
        [myAPI setPassword:_urTF.text oldPass:_myTF.text];
    }
}

- (void)didReceiveAPIErrorOf:(API *)api data:(long)errorNo {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Set Failed", @"设置失败") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveAPIResponseOf:(API *)api data:(NSDictionary *)data {
    if ([data[@"result"]integerValue] == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([data[@"result"]integerValue] == -1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Old password is wrong", @"旧密码错误") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"yohelper.oldPassword", @"旧密码");
    } else {
        return NSLocalizedString(@"yohelper.newPassword", @"新密码（需要至少6位）");
    }
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
