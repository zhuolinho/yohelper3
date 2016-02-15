//
//  CourseTableViewController.m
//  ChatDemo-UI3.0
//
//  Created by HoJolin on 16/1/4.
//  Copyright © 2016年 HoJolin. All rights reserved.
//

#import "CourseTableViewController.h"
#import "API.h"
#import "ChatViewController.h"
#import "IBActionSheet.h"
#import "WebViewController.h"
#import "WXApi.h"
#import "AppDelegate.h"

@interface CourseTableViewController () <APIProtocol, IBActionSheetDelegate, AlipayDelegate, WXApiDelegate> {
    UIImageView *networkErr;
    API *chiefAPI;
    API *refreshCourses;
    NSArray *dataSource;
    NSDictionary *mark;
    API *operationAdd;
}

@end

@implementation CourseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    networkErr = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 28, 180, 56, 56)];
    networkErr.image = [UIImage imageNamed:@"NetworkError"];
    [self.tableView addSubview:networkErr];
    networkErr.hidden = YES;
    chiefAPI = [[API alloc]init];
    chiefAPI.delegate = self;
    refreshCourses = [[API alloc]init];
    refreshCourses.delegate = self;
    operationAdd = [[API alloc]init];
    operationAdd.delegate = self;
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
    [refreshCourses getTopicNews];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).payVC = self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    } else if (indexPath.row == 2) {
        return 22;
    }
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 12;
    } else {
        return 6;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TopicNewsCell" forIndexPath:indexPath];
        UIImageView *coverImage = [cell viewWithTag:222];
        coverImage.contentMode = UIViewContentModeScaleAspectFill;
        coverImage.clipsToBounds = YES;
        UILabel *titleLabel = [cell viewWithTag:111];
        titleLabel.text = dataSource[indexPath.section][@"title"];
        UILabel *desLabel = [cell viewWithTag:333];
        desLabel.text = dataSource[indexPath.section][@"description"];
        NSString *savedFile = dataSource[indexPath.section][@"cover_url"];
        if ([API getPicByKey:savedFile]) {
            coverImage.image = [API getPicByKey:savedFile];
        } else {
            coverImage.image = [UIImage imageNamed:@"DefaultAvatar"];
            NSString *str = [NSString stringWithFormat:@"%@%@", HOST, savedFile];
            NSURL *url = [NSURL URLWithString:str];
            NSURLRequest *requst = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                if (connectionError == nil) {
                    UIImage *img = [UIImage imageWithData:data];
                    if (img) {
                        [API setPicByKey:savedFile pic:img];
                        coverImage.image = img;
                    }
                }
            }];
        }
    } else if (indexPath.row == 0) {
        cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(8, 0, self.view.bounds.size.width - 16, 60)];
        blankView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:blankView];
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(56, 10, 100, 20)];
        nameLabel.text = dataSource[indexPath.section][@"teacherNickname"];
        [blankView addSubview:nameLabel];
        UIImageView *avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 10, 40, 40)];
        avatarView.layer.cornerRadius = 20;
        avatarView.layer.masksToBounds = YES;
        [blankView addSubview:avatarView];
        UILabel *conLabel = [[UILabel alloc]initWithFrame:CGRectMake(56, 30, 100, 20)];
        NSString *con = [API CountryString:[dataSource[indexPath.section][@"lang"]unsignedIntegerValue]];
        conLabel.text = [NSString stringWithFormat:NSLocalizedString(@"yohelper.lang", @"语言：%@"), NSLocalizedString(con, con)];
        conLabel.font = [UIFont systemFontOfSize:15];
        conLabel.textColor = [UIColor lightGrayColor];
        [blankView addSubview:conLabel];
        UIButton *chatButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 168, 20, 68, 20)];
        [chatButton setBackgroundImage:[UIImage imageNamed:@"未标题-1"] forState:UIControlStateNormal];
        [chatButton setTitle:NSLocalizedString(@"yohelper.freechat", @"免费体验") forState:UIControlStateNormal];
        chatButton.titleLabel.font = [UIFont systemFontOfSize:13];
        chatButton.tag = indexPath.section;
        [chatButton setTitleColor:RGBACOLOR(246, 107, 107, 1) forState:UIControlStateNormal];
        [chatButton addTarget:self action:@selector(chatButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [blankView addSubview:chatButton];
        UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 92, 20, 68, 20)];
        [shareButton setBackgroundImage:[UIImage imageNamed:@"未标题-2"] forState:UIControlStateNormal];
        [shareButton setTitle:NSLocalizedString(@"yoheler.setchief", @"设置首席") forState:UIControlStateNormal];
        shareButton.titleLabel.font = [UIFont systemFontOfSize:13];
        shareButton.tag = indexPath.section;
        [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [blankView addSubview:shareButton];
        NSString *savedFile = dataSource[indexPath.section][@"teacherAvatar"];
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
    } else {
        cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(8, 1, self.view.bounds.size.width - 16, 21)];
        blankView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:blankView];
        UILabel *viewLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 1, self.view.bounds.size.width - 24, 21)];
        viewLabel.textColor = [UIColor lightGrayColor];
        viewLabel.text = NSLocalizedString(@"yoheler.viewall", @"查看全文");
        viewLabel.textAlignment = NSTextAlignmentRight;
        viewLabel.font = [UIFont systemFontOfSize:13];
        [cell addSubview:viewLabel];
    }
    
    // Configure the cell...
    
    return cell;
}

- (void)chatButtonClick:(UIButton *)button {
    ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:dataSource[button.tag][@"teacherUsername"] conversationType:eConversationTypeChat];
    chatVC.title = dataSource[button.tag][@"teacherNickname"];
    chatVC.hidesBottomBarWhenPushed = YES;
    chatVC.isService = NO;
    NSString *avatar = [NSString stringWithFormat:@"%@%@", HOST, dataSource[button.tag][@"teacherAvatar"]];
    [API setAvatarByKey:dataSource[button.tag][@"teacherUsername"] name:avatar];
    [API setUidByKey:dataSource[button.tag][@"teacherUsername"] uid:[NSString stringWithFormat:@"%@", dataSource[button.tag][@"teacherUID"]]];
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)shareButtonClick:(UIButton *)button {
    if ([API getChief].count == 0) {
        mark = dataSource[button.tag];
        IBActionSheet *sheet = [[IBActionSheet alloc]initWithTitle:NSLocalizedString(@"yohelper.settitle", "分享到朋友圈可免费设置首席语伴，每月一次") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"yohelper.wxfrd", @"朋友圈"), NSLocalizedString(@"yohelper.wxpay", @"微信支付"), NSLocalizedString(@"yohelper.alipay", @"支付宝支付"), nil];
        if ([[API getInfo][@"requestValue"]integerValue] == 0) {
            [sheet setButtonTextColor:[UIColor lightGrayColor] forButtonAtIndex:0];
        }
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"yohelper.alreadyChief", @"您已设置首席语伴，暂不能重新设置") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveAPIErrorOf:(API *)api data:(long)errorNo {
    if (api == refreshCourses && dataSource.count == 0) {
        networkErr.hidden = NO;
    }
}

- (void)didReceiveAPIResponseOf:(API *)api data:(NSDictionary *)data {
    if (api == refreshCourses) {
        networkErr.hidden = YES;
        dataSource = data[@"result"];
        [self.tableView reloadData];
    } else if (api == operationAdd) {
        [chiefAPI getMyCollectionTeachers];
        if ([data[@"result"]integerValue] == 1) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"yohelper.success", @"设置成功") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
            [alert show];
        }
    } else {
        [API setChief:data[@"result"]];
    }
}

- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[API getInfo][@"requestValue"]integerValue] > 0 && buttonIndex == 0) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = dataSource[actionSheet.tag][@"shareTitle"];
        message.description = dataSource[actionSheet.tag][@"shareContent"];
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = dataSource[actionSheet.tag][@"share_url"];
        message.mediaObject = ext;
        [message setThumbImage:[UIImage imageNamed:@"1385977285"]];
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;
        [WXApi sendReq:req];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        WebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        vc.url = dataSource[indexPath.section][@"url"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)AlipayRequestBack:(NSDictionary *)result {
    
}

- (void)onResp:(BaseResp *)resp {
    if (resp.errCode == 0) {
        [operationAdd addCollectionTeacher:[NSString stringWithFormat:@"%@", mark[@"teacherUID"]]];
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
