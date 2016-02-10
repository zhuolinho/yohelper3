//
//  MeTableViewController.m
//  ChatDemo-UI3.0
//
//  Created by HoJolin on 16/2/2.
//  Copyright © 2016年 HoJolin. All rights reserved.
//

#import "MeTableViewController.h"
#import "API.h"
#import "WebViewController.h"

@interface MeTableViewController ()

@end

@implementation MeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if (section == 0) {
        return 1;
    } else {
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    } else {
        return 44;
    }
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
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"My Collections", @"我的收藏");
            cell.imageView.image = [UIImage imageNamed:@"MyFavorites"];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"yohelper.setting", @"设置");
            cell.imageView.image = [UIImage imageNamed:@"AccountSettings"];
        } else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"User Guide", @"使用帮助");
            cell.imageView.image = [UIImage imageNamed:@"UserGuide"];
        } else if (indexPath.row == 3) {
            cell.textLabel.text = NSLocalizedString(@"Contact Us", @"联系我们");
            cell.imageView.image = [UIImage imageNamed:@"ContactUs"];
        } else {
            cell.textLabel.text = NSLocalizedString(@"Copyright", @"版权声明");
            cell.imageView.image = [UIImage imageNamed:@"Copyright"];
        }
    }
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileTableViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if (indexPath.row == 0) {
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyCollectionsViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 2) {
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserGuideViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 3) {
            WebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            vc.url = @"http://www.yozaii.com/contact.html";
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 4) {
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CopyrightViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
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
