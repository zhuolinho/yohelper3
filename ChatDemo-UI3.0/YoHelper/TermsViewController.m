//
//  TermsViewController.m
//  ChatDemo-UI3.0
//
//  Created by HoJolin on 16/2/10.
//  Copyright © 2016年 HoJolin. All rights reserved.
//

#import "TermsViewController.h"

@interface TermsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@end

@implementation TermsViewController
- (IBAction)backButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = self.view.bounds.size.width;
    UIImageView *copyrightImg = [[UIImageView alloc]initWithFrame:CGRectMake(4, 0, width, width / 16 * 125)];
    copyrightImg.image = [UIImage imageNamed:@"CopyrightDoc"];
    [_myScrollView addSubview:copyrightImg];
    _myScrollView.contentSize = copyrightImg.bounds.size;
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
