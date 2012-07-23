//
//  SEBlingLordView.h
//  SEBlingLord iOS springboard view
//
//  Created by bryn austin bellomy on 5/19/12.
//  Copyright (c) 2012 robot bubble bath LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEBlingLordMenuItem.h"
//#import "KJGridLayoutView.h"

typedef enum {
  SEBlingLordLayoutStyleNone = 0,
  SEBlingLordLayoutStyleCenterVertically = (1 << 0),
  SEBlingLordLayoutStyleCenterHorizontally = (1 << 1)
} SEBlingLordLayoutStyle;

static NSString *const SEBlingLordNotificationCloseView = @"SEBlingLordNotificationCloseView";

//static inline KJGridPair SEGetGridPosition(NSUInteger newItemIdx, NSUInteger numCols) {
//  NSUInteger col = newItemIdx % numCols;
//  return KJGridPairMake((newItemIdx - col) / numCols, col);
//}


@interface SEBlingLordView : UIView /*KJGridLayoutView*/ <SEBlingLordMenuItemDelegate, UIScrollViewDelegate>

@property (nonatomic, assign, readwrite) BOOL allowsEditing;
@property (nonatomic, assign, readwrite) BOOL isInEditingMode;
@property (nonatomic, assign, readwrite) SEBlingLordLayoutStyle layoutStyle;
@property (nonatomic, strong, readwrite) UIImage *launcherImage;
@property (nonatomic, strong, readwrite) NSArray *items;
@property (nonatomic, strong, readwrite) IBOutlet UINavigationController *navigationController;
@property (nonatomic, strong, readwrite) IBOutlet UIScrollView *itemsContainer;
@property (nonatomic, strong, readwrite) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong, readwrite) IBOutlet UIButton *doneEditingButton;
@property (nonatomic, assign, readwrite) CGSize itemSize;
@property (nonatomic, assign, readwrite) CGSize itemMargins;
@property (nonatomic, assign, readwrite) CGSize outerMargins;
//@property (nonatomic, assign, readwrite) KJGridPair gridSize;


- (id) initWithFrame: (CGRect)frame;
- (id) initWithFrame: (CGRect)frame itemSize:(CGSize)itemSize itemMargins:(CGSize)itemMargins outerMargins:(CGSize)outerMargins /*gridSize: (KJGridSize)gridSize*/ items:(NSMutableArray *)items;

- (void) addMenuItem:(SEBlingLordMenuItem *)menuItem;
- (void) addMenuItems:(NSArray *)menuItems;
- (void) removeMenuItemAtIndex:(NSUInteger)idx animate:(BOOL)animate;
- (void) removeAllMenuItems;
  
@end
