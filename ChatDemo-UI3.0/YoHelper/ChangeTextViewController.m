//
//  ChangeTextViewController.m
//  ChatDemo-UI3.0
//
//  Created by HoJolin on 16/2/8.
//  Copyright © 2016年 HoJolin. All rights reserved.
//

#import "ChangeTextViewController.h"
#import "API.h"

@interface ChangeTextViewController () <APIProtocol> {
    API *myAPI;
}
@property (weak, nonatomic) IBOutlet UITextField *myTF;

@end

@implementation ChangeTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myAPI = [[API alloc]init];
    myAPI.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonClick)];
    if (_type == 3) {
        self.title = NSLocalizedString(@"yohelper.changeAddr", @"修改地址");
    } else if (_type == 5) {
        self.title = NSLocalizedString(@"yohelper.changeEmail", @"修改邮箱");
        _myTF.keyboardType = UIKeyboardTypeEmailAddress;
    } else {
        self.title = NSLocalizedString(@"yohelper.changeNickname", @"修改昵称");
    }
    _myTF.text = _formerValue;
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
    if (![_myTF.text isEqualToString:@""]) {
        if (_type == 3) {
            [myAPI setAddress:_myTF.text];
        } else if (_type == 5) {
            [myAPI setEmail:_myTF.text];
        } else {
            [myAPI setNickname:_myTF.text];
        }
    }
}

- (void)didReceiveAPIErrorOf:(API *)api data:(long)errorNo {
    NSLog(@"%ld", errorNo);
}

- (void)didReceiveAPIResponseOf:(API *)api data:(NSDictionary *)data {
    NSLog(@"%@", data);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_type == 3) {
        return NSLocalizedString(@"Please enter new address", @"请输入新地址");
    } else if (_type == 5) {
        return NSLocalizedString(@"Please enter new Email", @"请输入新邮箱");
    } else {
        return NSLocalizedString(@"Please enter new nickname", @"请输入新昵称");
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
