//
//  ShowFontViewController.m
//  CustomFontDemo
//
//  Created by JC_CP3 on 15/8/24.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "ShowFontViewController.h"

@interface ShowFontViewController ()

@end

@implementation ShowFontViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *fontLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth([UIScreen mainScreen].bounds), 0)];
    fontLabel.numberOfLines = 0;
    fontLabel.lineBreakMode = NSLineBreakByClipping;
    fontLabel.textColor = [UIColor lightGrayColor];
    fontLabel.font = [UIFont fontWithName:self.fontName size:18.f];
    [fontLabel sizeToFit];
    [self.view addSubview:fontLabel];
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
