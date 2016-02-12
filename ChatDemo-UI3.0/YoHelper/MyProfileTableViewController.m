//
//  MyProfileTableViewController.m
//  ChatDemo-UI3.0
//
//  Created by HoJolin on 16/2/2.
//  Copyright © 2016年 HoJolin. All rights reserved.
//

#import "MyProfileTableViewController.h"
#import "API.h"
#import "IBActionSheet.h"
#import "ChangeTextViewController.h"
#import "ChangePasswordViewController.h"
#import "ChangeGenderViewController.h"
#import "ApplyViewController.h"

@interface MyProfileTableViewController () <APIProtocol, IBActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    API *myAPI;
    API *urAPI;
    UIImagePickerController *imagePicker;
    UIActivityIndicatorView *activity;
}

@end

@implementation MyProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"yohelper.myInfo", @"个人信息");
    myAPI = [[API alloc]init];
    myAPI.delegate = self;
    urAPI = [[API alloc]init];
    urAPI.delegate = self;
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.color = THEMECOLOR;
    activity.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    activity.hidesWhenStopped = YES;
    [imagePicker.view addSubview:activity];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, self.view.frame.size.width - 20, 45)];
    logoutButton.layer.cornerRadius = 5;
    logoutButton.layer.masksToBounds = YES;
    logoutButton.backgroundColor = THEMECOLOR;
    [logoutButton setTitle:NSLocalizedString(@"yohelper.logout", @"退出登录") forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView.tableFooterView addSubview:logoutButton];
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
    [myAPI getMyInfo];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if (section == 0) {
        return 1;
    } else {
        return 6;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc]init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        avatarImageView.layer.cornerRadius = 5;
        avatarImageView.layer.masksToBounds = YES;
        [cell addSubview:avatarImageView];
        UILabel *nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 30, 150, 20)];
        nicknameLabel.text = [API getInfo][@"username"];
        [cell addSubview:nicknameLabel];
        NSString *savedFile = [API getInfo][@"avatar"];
        if ([API getPicByKey:savedFile]) {
            avatarImageView.image = [API getPicByKey:savedFile];
        } else {
            avatarImageView.image = [UIImage imageNamed:@"DefaultAvatar"];
            NSString *str = [NSString stringWithFormat:@"%@%@", HOST, savedFile];
            NSURL *url = [NSURL URLWithString:str];
            NSURLRequest *requst = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                if (connectionError == nil) {
                    UIImage *img = [UIImage imageWithData:data];
                    if (img) {
                        [API setPicByKey:savedFile pic:img];
                        avatarImageView.image = img;
                    }
                }
            }];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"OtherCell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"yohelper.nickname", @"昵称");
            cell.detailTextLabel.text = [API getInfo][@"nickname"];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"yohelper.gender", @"性别");
            if ([[API getInfo][@"gender"]isEqualToString:@"M"]) {
                cell.detailTextLabel.text = NSLocalizedString(@"yohelper.male", @"男");
            } else if ([[API getInfo][@"gender"]isEqualToString:@"F"]) {
                cell.detailTextLabel.text = NSLocalizedString(@"yohelper.female", @"女");
            } else {
                cell.detailTextLabel.text = NSLocalizedString(@"yohelper.default", @"默认");
            }
        } else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"yohelper.mobile", @"手机号");
            cell.detailTextLabel.text = [API getInfo][@"phone"];
            UIImageView *lockImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Lock"]];
            cell.accessoryView = lockImage;
        } else if (indexPath.row == 3) {
            cell.textLabel.text = NSLocalizedString(@"yohelper.addr", @"地址");
            cell.detailTextLabel.text = [API getInfo][@"address"];
        } else if (indexPath.row == 4) {
            cell.textLabel.text = NSLocalizedString(@"yohelper.password", @"密码");
            cell.detailTextLabel.text = @"******";
        } else if (indexPath.row == 5) {
            cell.textLabel.text = NSLocalizedString(@"yohelper.email", @"电子邮箱");
            cell.detailTextLabel.text = [API getInfo][@"email"];
        }
       
    }
    // Configure the cell...
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    } else {
        return 44;
    }
}

- (void)didReceiveAPIErrorOf:(API *)api data:(long)errorNo {
    NSLog(@"%ld", errorNo);
}

- (void)didReceiveAPIResponseOf:(API *)api data:(NSDictionary *)data {
    if (api == urAPI) {
        [activity stopAnimating];
        [imagePicker dismissViewControllerAnimated:YES completion:nil];
        [myAPI getMyInfo];
        return;
    }
    [API setInfo:data[@"result"]];
    NSString *avatar = [NSString stringWithFormat:@"%@%@", HOST, [API getInfo][@"avatar"]];
    [API setAvatarByKey:[API getInfo][@"username"] name:avatar];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            ChangeTextViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeTextViewController"];
            vc.type = 0;
            vc.formerValue = [API getInfo][@"nickname"];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 3) {
            ChangeTextViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeTextViewController"];
            vc.type = 3;
            vc.formerValue = [API getInfo][@"address"];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 5) {
            ChangeTextViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeTextViewController"];
            vc.type = 5;
            vc.formerValue = [API getInfo][@"email"];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 4) {
            ChangePasswordViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            ChangeGenderViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeGenderViewController"];
            vc.gender = [API getInfo][@"gender"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        IBActionSheet *changeAvatarActionSheet = [[IBActionSheet alloc]initWithTitle:NSLocalizedString(@"yohelper.changeAvatar", @"修改头像") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"yohelper.takephoto", @"拍照"), NSLocalizedString(@"Pick from library", @"从照片库中选"), nil];
        [changeAvatarActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else if (buttonIndex == 1) {
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    CGFloat height = chosenImage.size.height;
    CGFloat width = chosenImage.size.width;
    if (height > width) {
        width = 150 * width / height;
        height = 150;
    } else {
        height = 150 * height / width;
        width = 150;
    }
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [chosenImage drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *editedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [urAPI setAvatar:editedImage];
    [activity startAnimating];
}

- (void)logoutAction
{
    [self showHudInView:self.view hint:NSLocalizedString(@"setting.logoutOngoing", @"loging out...")];
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        [self hideHud];
        if (error && error.errorCode != EMErrorServerNotLogin) {
            [self showHint:error.description];
        }
        else{
            [[ApplyViewController shareController] clear];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }
    } onQueue:nil];
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
