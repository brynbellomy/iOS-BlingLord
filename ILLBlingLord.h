//
//  ILLBlingLord.h
//  ILLBlingLord iOS springboard view
//
//  Created by bryn austin bellomy on 5/19/12.
//  Based on code by Sarp Erdag written on 11/5/11.
//  Copyright (c) 2012 bryn austin bellomy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILLBlingLordMenuItem.h"

@interface ILLBlingLord : UIView <MenuItemDelegate, UIScrollViewDelegate>

@property (nonatomic, assign, readwrite) BOOL allowsEditing;
@property (nonatomic, strong, readonly)  NSString *navbarTitle;
@property (nonatomic, strong, readwrite) UIImage *launcherImage;
@property (nonatomic, strong, readwrite) NSMutableArray *items;
@property (nonatomic, strong, readwrite) NSMutableArray *itemCounts;    // holds how many items there are in each page
@property (nonatomic, assign, readonly)  BOOL isInEditingMode;
@property (nonatomic, weak,   readwrite) UINavigationBar *navigationBar;
@property (nonatomic, strong, readwrite) UINavigationController *navigationController;
@property (nonatomic, weak,   readwrite) UIScrollView *itemsContainer;
@property (nonatomic, weak,   readwrite) UIPageControl *pageControl;
@property (nonatomic, weak,   readwrite) UIButton *doneEditingButton;

+ (id) initWithNavbarTitle:(NSString *)navbarTitle items:(NSMutableArray *)menuItems launcherImage:(UIImage *)launcherImage;

- (void) disableEditingMode;
- (void) enableEditingMode;
- (void) removeAllMenuItemsFromSpringboard;
  
@end
