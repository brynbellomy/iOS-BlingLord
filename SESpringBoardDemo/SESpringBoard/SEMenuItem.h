//
//  SEMenuItem.h
//  SESpringBoardDemo
//
//  Created by Sarp Erdag on 11/5/11.
//  Copyright (c) 2011 Sarp Erdag. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuItemDelegate;
@class SEViewController;

@interface SEMenuItem : UIView

//@property (nonatomic, assign, readwrite) int tag;
@property (atomic,    assign, readwrite) BOOL isRemovable;
@property (atomic,    assign, readwrite) BOOL isInEditingMode;
@property (nonatomic, weak,   readwrite) id<MenuItemDelegate> delegate;
@property (nonatomic, weak,   readwrite) UIImageView *imageView;
@property (nonatomic, weak,   readwrite) UILabel *textLabel;

+ (id) initWithTitle:(NSString *)title image:(UIImage *)image removable:(BOOL)removable viewController:(UIViewController *)viewController;
+ (id) initWithTitle:(NSString *)title image:(UIImage *)image removable:(BOOL)removable tapHandlerBlock:(dispatch_block_t)tapHandlerBlock;

- (void) enableEditing;
- (void) disableEditing;
- (void) updateTag: (int)newTag;

@end


@protocol MenuItemDelegate <NSObject>
  @optional
//    - (void) launch:(int)index :(UIViewController *)vcToLoad;
    - (void) removeFromSpringboard:(int)index animate:(BOOL)animate;
    - (void) menuItemWasTapped:(SEMenuItem *)menuItem buttonTag:(int)buttonTag launchViewController:(SEViewController *)viewController;
    - (void) menuItemWasTapped:(SEMenuItem *)menuItem buttonTag:(int)buttonTag runBlock:(dispatch_block_t)tapHandlerBlock;
@end



