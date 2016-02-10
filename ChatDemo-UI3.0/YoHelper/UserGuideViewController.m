//
//  UserGuideViewController.m
//  ChatDemo-UI3.0
//
//  Created by HoJolin on 16/2/9.
//  Copyright © 2016年 HoJolin. All rights reserved.
//

#import "UserGuideViewController.h"

@interface UserGuideViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@end

@implementation UserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"User Guide", @"使用帮助");
    CGFloat height = self.view.bounds.size.height - 64;
    CGFloat width = self.view.bounds.size.width + 8;
//    _myScrollView.backgroundColor = [UIColor redColor];
    _myScrollView.contentSize = CGSizeMake(width * 6, height);
    UIImageView *aview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    aview.image = [UIImage imageNamed:@"guiding-1"];
    [_myScrollView addSubview:aview];
    UIImageView *bview = [[UIImageView alloc]initWithFrame:CGRectMake(width, 0, width, height)];
    bview.image = [UIImage imageNamed:@"guiding-2"];
    [_myScrollView addSubview:bview];
    UIImageView *cview = [[UIImageView alloc]initWithFrame:CGRectMake(width * 2, 0, width, height)];
    cview.image = [UIImage imageNamed:@"guiding-3"];
    [_myScrollView addSubview:cview];
    UIImageView *dview = [[UIImageView alloc]initWithFrame:CGRectMake(width * 3, 0, width, height)];
    dview.image = [UIImage imageNamed:@"guiding-4"];
    [_myScrollView addSubview:dview];
    UIImageView *eview = [[UIImageView alloc]initWithFrame:CGRectMake(width * 4, 0, width, height)];
    eview.image = [UIImage imageNamed:@"guiding-5"];
    [_myScrollView addSubview:eview];
    UIImageView *fview = [[UIImageView alloc]initWithFrame:CGRectMake(width * 5, 0, width, height)];
    fview.image = [UIImage imageNamed:@"guiding-6"];
    [_myScrollView addSubview:fview];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
