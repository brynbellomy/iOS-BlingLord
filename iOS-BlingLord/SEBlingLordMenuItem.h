//
//  SEBlingLordMenuItem.h
//  SEBlingLord iOS springboard view
//
//  Created by bryn austin bellomy on 5/19/12.
//  Copyright (c) 2012 robot bubble bath LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SEBlingLordViewController;
@protocol SEBlingLordMenuItemDelegate;

@interface SEBlingLordMenuItem : UIView

@property (nonatomic, assign, readwrite) BOOL isRemovable;
@property (nonatomic, assign, readwrite) BOOL isInEditingMode;
@property (nonatomic, weak,   readwrite) id<SEBlingLordMenuItemDelegate> delegate;
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong, readwrite) UILabel *textLabel;

- (id) initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image removable:(BOOL)removable viewController:(SEBlingLordViewController *)viewController;
- (id) initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image removable:(BOOL)removable tapHandlerBlock:(dispatch_block_t)tapHandlerBlock;

@end


@protocol SEBlingLordMenuItemDelegate <NSObject>
  - (void) menuItemWasTapped:(SEBlingLordMenuItem *)menuItem launchViewController:(SEBlingLordViewController *)viewController;
  - (void) menuItemWasTapped:(SEBlingLordMenuItem *)menuItem runBlock:(dispatch_block_t)tapHandlerBlock;
  - (void) menuItemWasLongPressed:(SEBlingLordMenuItem *)menuItem;
  - (void) removeButtonWasTapped:(SEBlingLordMenuItem *)menuItem;
@end



