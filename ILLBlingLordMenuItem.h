//
//  ILLBlingLord.h
//  ILLBlingLord iOS springboard view
//
//  Created by bryn austin bellomy on 5/19/12.
//  Based on code by Sarp Erdag written on 11/5/11.
//  Copyright (c) 2012 bryn austin bellomy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuItemDelegate;
@class ILLBlingLordViewController;

@interface ILLBlingLordMenuItem : UIView

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
    - (void) menuItemWasTapped:(ILLBlingLordMenuItem *)menuItem buttonTag:(int)buttonTag launchViewController:(ILLBlingLordViewController *)viewController;
    - (void) menuItemWasTapped:(ILLBlingLordMenuItem *)menuItem buttonTag:(int)buttonTag runBlock:(dispatch_block_t)tapHandlerBlock;
@end



