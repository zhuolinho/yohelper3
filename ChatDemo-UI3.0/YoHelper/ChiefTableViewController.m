//
//  ChiefTableViewController.m
//  ChatDemo-UI3.0
//
//  Created by HoJolin on 16/1/4.
//  Copyright © 2016年 HoJolin. All rights reserved.
//

#import "ChiefTableViewController.h"
#import "ChatViewController.h"
#import "ConversationListController.h"
#import "API.h"
#import "WebViewController.h"
#import "IBActionSheet.h"

@interface ChiefTableViewController () <APIProtocol, IBActionSheetDelegate> {
    UIScrollView *scrollView;
    API *getCollection;
    NSArray *chiefTeacher;
    API *refresh;
    API *operation;
    NSArray *res;
    NSDictionary *mark;
}

@end

@implementation ChiefTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(timesup) userInfo:nil repeats:YES];
    getCollection = [[API alloc]init];
    getCollection.delegate = self;
    refresh = [[API alloc]init];
    refresh.delegate = self;
    operation = [[API alloc]init];
    operation.delegate = self;
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
    [getCollection getMyCollectionTeachers];
    [refresh getTeachersFromJobTag];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 30;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float x = self.tableView.frame.size.width / 320;
    if (indexPath.section == 2) {
        return 380;
    }
    else if (indexPath.section == 1) {
        return 100;
    }
    return 71 * x;
}

- (void)timesup {
    float x = self.tableView.frame.size.width / 320;
    scrollView.contentOffset = CGPointMake(x * ((int)[[NSDate date]timeIntervalSinceReferenceDate] % 5) * 320, 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    float x = self.tableView.frame.size.width / 320;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"FirstCell" forIndexPath:indexPath];
        scrollView = [cell viewWithTag:999];
        UIImageView *aview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320 * x, 71 * x)];
        aview.image = [UIImage imageNamed:@"a1"];
        [scrollView addSubview:aview];
        UIImageView *bview = [[UIImageView alloc]initWithFrame:CGRectMake(320 * x, 0, 320 * x, 71 * x)];
        bview.image = [UIImage imageNamed:@"a2"];
        [scrollView addSubview:bview];
        UIImageView *cview = [[UIImageView alloc]initWithFrame:CGRectMake(2 * 320 * x, 0, 320 * x, 71 * x)];
        cview.image = [UIImage imageNamed:@"a3"];
        [scrollView addSubview:cview];
        UIImageView *dview = [[UIImageView alloc]initWithFrame:CGRectMake(3 * 320 * x, 0, 320 * x, 71 * x)];
        dview.image = [UIImage imageNamed:@"a4"];
        [scrollView addSubview:dview];
        UIImageView *eview = [[UIImageView alloc]initWithFrame:CGRectMake(4 * 320 * x, 0, 320 * x, 71 * x)];
        eview.image = [UIImage imageNamed:@"a5"];
        [scrollView addSubview:eview];
    } else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SectionCell" forIndexPath:indexPath];
        [cell removeFromSuperview];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SectionCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (chiefTeacher.count == 0) {
            UIImageView *helpImage = [[UIImageView alloc]initWithFrame:CGRectMake(160 * x - 160, 0, 320, 100)];
            helpImage.image = [UIImage imageNamed:@"提示"];
            [cell addSubview:helpImage];
        }
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ThirdCell" forIndexPath:indexPath];
        [cell removeFromSuperview];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ThirdCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        NSMutableArray *myView = [[NSMutableArray alloc]init];
        UIView *view0 = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 160 * x - 15, 185)];
        [myView addObject:view0];
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(160 * x + 5, 0, 160 * x -15, 185)];
        [myView addObject:view1];
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(10, 180 + 10, 160 * x - 15, 185)];
        [myView addObject:view2];
        UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(160 * x + 5, 180 + 10, 160 * x - 15, 185)];
        [myView addObject:view3];
        for (int i = 0; i < res.count; i++) {
            [myView[i]setBackgroundColor:[UIColor whiteColor]];
            [cell addSubview:myView[i]];
            UIImageView *avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(80 * x - 37.5, 20, 60, 60)];
            avatarView.layer.cornerRadius = 30;
            avatarView.layer.masksToBounds = YES;
            [myView[i]addSubview:avatarView];
            UIButton *videoButton = [[UIButton alloc]initWithFrame:CGRectMake(80 * x - 37.5, 20, 60, 60)];
            videoButton.tag = i;
            [videoButton addTarget:self action:@selector(videoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [myView[i]addSubview:videoButton];
            UIImageView *playImg = [[UIImageView alloc]initWithFrame:CGRectMake(80 * x + 1.5, 59, 21, 21)];
            playImg.image = [UIImage imageNamed:@"播放"];
            [myView[i]addSubview:playImg];
            UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(110 * x - 20, 5, 50, 20)];
            [shareButton setBackgroundImage:[UIImage imageNamed:@"设为首席bg"] forState:UIControlStateNormal];
            shareButton.tag = i;
            [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [shareButton setTitle:NSLocalizedString(@"yoheler.setchief", @"设为首席") forState:UIControlStateNormal];
            shareButton.titleLabel.font = [UIFont systemFontOfSize:10];
            [myView[i]addSubview:shareButton];
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 160 * x - 15, 30)];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            nameLabel.text = res[i][@"nickname"];
            nameLabel.textColor = [UIColor lightGrayColor];
            [myView[i]addSubview:nameLabel];
            UILabel *spetor1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, 160 * x - 15, 0.5)];
            spetor1.backgroundColor = [UIColor lightGrayColor];
            [myView[i]addSubview:spetor1];
            UILabel *spetor2 =  [[UILabel alloc]initWithFrame:CGRectMake(0, 145, 160 * x - 15, 0.5)];
            spetor2.backgroundColor = [UIColor lightGrayColor];
            [myView[i]addSubview:spetor2];
            UIImageView *langImage = [[UIImageView alloc]initWithFrame:CGRectMake(80 * x - 43, 116, 9, 11)];
            langImage.image = [UIImage imageNamed:@"语种tag"];
            [myView[i]addSubview:langImage];
            UILabel *langLabel = [[UILabel alloc]initWithFrame:CGRectMake(6, 116, 160 * x - 55, 11)];
            langLabel.font = [UIFont systemFontOfSize:11];
            langLabel.textColor = [UIColor lightGrayColor];
            NSString *lang = [API LanguageString:[res[i][@"lang"]unsignedIntegerValue]];
            langLabel.text = NSLocalizedString(lang, lang);
            langLabel.textAlignment = NSTextAlignmentCenter;
            [myView[i]addSubview:langLabel];
            UIImageView *conImage = [[UIImageView alloc]initWithFrame:CGRectMake(80 * x - 2, 116, 13, 12)];
            conImage.image = [UIImage imageNamed:@"国籍tag"];
            [myView[i]addSubview:conImage];
            NSString *con = [API CountryString:[res[i][@"lang"]unsignedIntegerValue]];
            UILabel *conLabel = [[UILabel alloc]initWithFrame:CGRectMake(80 * x + 13, 116, 80, 11)];
            conLabel.font = [UIFont systemFontOfSize:11];
            conLabel.textColor = [UIColor lightGrayColor];
            conLabel.text = NSLocalizedString(con, con);
            [myView[i]addSubview:conLabel];
            UIImageView *loveImage = [[UIImageView alloc]initWithFrame:CGRectMake(80 * x - 50, 129, 12, 11)];
            loveImage.image = [UIImage imageNamed:@"喜欢"];
            [myView[i]addSubview:loveImage];
            UILabel *loveLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 130, 160 * x, 11)];
            loveLabel.font = [UIFont systemFontOfSize:11];
            loveLabel.textColor = [UIColor lightGrayColor];
            loveLabel.textAlignment = NSTextAlignmentCenter;
            loveLabel.text = [NSString stringWithFormat:NSLocalizedString(@"yohelper.chineseLevel", @"汉语水平：%@"), res[i][@"chineseLevel"]];
            [myView[i]addSubview:loveLabel];
            UIButton *chatButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 153, 160 * x - 45, 25)];
            if ([res[i][@"iffree"]integerValue] == 0) {
                chatButton.backgroundColor = THEMECOLOR;
                chatButton.enabled = YES;
            } else {
                chatButton.backgroundColor = [UIColor lightGrayColor];
                chatButton.enabled = NO;
            }
            [chatButton setTitle:NSLocalizedString(@"yohelper.freechat", @"免费体验") forState:UIControlStateNormal];
            chatButton.layer.cornerRadius = 10;
            chatButton.layer.masksToBounds = YES;
            chatButton.titleLabel.font = [UIFont systemFontOfSize:15];
            chatButton.tag = i;
            [chatButton addTarget:self action:@selector(chatButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [myView[i]addSubview:chatButton];
            NSString *savedFile = res[i][@"avatar"];
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
        }
    }
    
    
    // Configure the cell...
    
    return cell;
}

- (void)videoButtonClick:(UIButton *)button {
    WebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    vc.url = res[button.tag][@"personalUrl"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)shareButtonClick:(UIButton *)button {
    if (chiefTeacher.count == 0) {
        mark = res[button.tag];
        IBActionSheet *sheet = [[IBActionSheet alloc]initWithTitle:NSLocalizedString(@"yohelper.settitle", "分享到朋友圈可免费设置首席语伴，每月一次") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") destructiveButtonTitle:NSLocalizedString(@"yohelper.wxfrd", @"朋友圈") otherButtonTitles:NSLocalizedString(@"yohelper.wxpay", @"微信支付"), NSLocalizedString(@"yohelper.alipay", @"支付宝支付"), nil];
        [sheet setButtonTextColor:[UIColor lightGrayColor] forButtonAtIndex:0];
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)chatButtonClick:(UIButton *)button {
    ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:res[button.tag][@"username"] conversationType:eConversationTypeChat];
    chatVC.title = res[button.tag][@"nickname"];
    chatVC.hidesBottomBarWhenPushed = YES;
    chatVC.isService = NO;
    NSString *avatar = [NSString stringWithFormat:@"%@%@", HOST, res[button.tag][@"avatar"]];
    [API setAvatarByKey:res[button.tag][@"username"] name:avatar];
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        UIView *header = [[UIView alloc]init];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 30)];
        label.text = NSLocalizedString(@"yoheler.showpartner", @"#推荐语伴");
        label.textColor = [UIColor lightGrayColor];
        [header addSubview:label];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(tableView.frame.size.width - 100, 0, 80, 30)];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"yohelper.change", @"换一批") forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"换一批"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(firstButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:button];
        return header;
    }
    return nil;
}

- (void)firstButtonClick {
    [refresh getTeachersFromJobTag];
}

- (void)didReceiveAPIErrorOf:(API *)api data:(long)errorNo {
    NSLog(@"%ld", errorNo);
}

- (void)didReceiveAPIResponseOf:(API *)api data:(NSDictionary *)data {
    if (api == refresh) {
//        NSLog(@"%@", data);
        res = data[@"result"];
        [self.tableView reloadData];
    } else if (api == getCollection) {
        chiefTeacher = data[@"result"];
        [self.tableView reloadData];
    }
}

- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%ld", (long)buttonIndex);
}

- (IBAction)serverButtonClick:(id)sender {
    ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:@"custom_service" conversationType:eConversationTypeChat];
    chatVC.title = @"外语帮手客服";
    chatVC.hidesBottomBarWhenPushed = YES;
    chatVC.isService = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (IBAction)listButtonClick:(id)sender {
    ConversationListController *chatList = [[ConversationListController alloc] initWithNibName:nil bundle:nil];
    chatList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatList animated:YES];
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
