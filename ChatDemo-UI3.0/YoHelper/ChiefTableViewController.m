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

@interface ChiefTableViewController () <APIProtocol> {
    UIScrollView *scrollView;
    API *getCollection;
    NSArray *chiefTeacher;
    API *refresh;
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
        cell = [[UITableViewCell alloc]init];
    }
    
    
    // Configure the cell...
    
    return cell;
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
    NSLog(@"%@", data);
    chiefTeacher = data[@"result"];
    [self.tableView reloadData];
}

- (IBAction)serverButtonClick:(id)sender {
    ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter: @"custom_service" conversationType:eConversationTypeChat];
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
