//
//  MyNavViewController.m
//  ChatDemo-UI3.0
//
//  Created by HoJolin on 16/1/4.
//  Copyright © 2016年 HoJolin. All rights reserved.
//

#import "MyNavViewController.h"

@interface MyNavViewController ()

@end

@implementation MyNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *statusBarView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 20)];
    statusBarView.backgroundColor = THEMECOLOR;
    [self.navigationBar addSubview:statusBarView];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: THEMECOLOR}];
    [self.navigationBar setTintColor:THEMECOLOR];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
