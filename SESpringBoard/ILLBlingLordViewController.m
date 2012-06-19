//
//  ILLBlingLordViewController.m
//  ILLBlingLord iOS springboard view
//
//  Created by bryn austin bellomy on 5/19/12.
//  Based on code by Sarp Erdag written on 11/5/11.
//  Copyright (c) 2012 bryn austin bellomy. All rights reserved.
//

#import "ILLBlingLordViewController.h"

@implementation ILLBlingLordViewController

@synthesize launcherImage;

- (void)quitView: (id) sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeView" object:self.navigationController.view];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // add a button to the navigation bar to switch back to the springboard interface (home)
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:launcherImage forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 41, 33)];
    [btn addTarget:self action:@selector(quitView:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *showLauncher = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = showLauncher;
}



@end
