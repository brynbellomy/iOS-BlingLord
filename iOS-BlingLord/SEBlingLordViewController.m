//
//  SEBlingLordViewController.m
//  SEBlingLord iOS springboard view
//
//  Created by bryn austin bellomy on 5/19/12.
//  Copyright (c) 2012 robot bubble bath LLC. All rights reserved.
//

#import "SEBlingLordViewController.h"
#import "SEBlingLordView.h"

@implementation SEBlingLordViewController

@synthesize launcherImage = _launcherImage;


- (void) quitView:(id)sender {
  [[NSNotificationCenter defaultCenter] postNotificationName:SEBlingLordNotificationCloseView object:self.navigationController.view];
}


- (void) viewDidLoad {
  [super viewDidLoad];
  
  // add a button to the navigation bar to switch back to the springboard interface (home)
  
  UIButton *closeViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [closeViewButton setBackgroundImage:self.launcherImage forState:UIControlStateNormal];
  [closeViewButton setFrame:CGRectMake(0, 0, 41, 33)]; // @@TODO: don't hard-code this
  [closeViewButton addTarget:self action:@selector(quitView:) forControlEvents:UIControlEventTouchUpInside];
  
  UIBarButtonItem *closeViewBarItem = [[UIBarButtonItem alloc] initWithCustomView:closeViewButton];
  self.navigationItem.leftBarButtonItem = closeViewBarItem;
}



@end
