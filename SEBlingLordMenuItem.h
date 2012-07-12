//
//  SEBlingLordMenuItem.h
//  SEBlingLord iOS springboard view
//
//  Created by bryn austin bellomy on 5/19/12.
//  Copyright (c) 2012 bryn austin bellomy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SEBlingLordMenuItemDelegate;
@class SEBlingLordViewController;

@interface SEBlingLordMenuItem : UIView

@property (atomic,    assign, readwrite) BOOL isRemovable;
@property (atomic,    assign, readwrite) BOOL canTriggerSpringboardEditingMode;
@property (atomic,    assign, readwrite) BOOL isInEditingMode;
@property (nonatomic, weak,   readwrite) id<SEBlingLordMenuItemDelegate> delegate;
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong, readwrite) UILabel *textLabel;

- (id) initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image removable:(BOOL)removable canTriggerEditing:(BOOL)canTriggerSpringboardEditingMode viewController:(SEBlingLordViewController *)viewController;
- (id) initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image removable:(BOOL)removable canTriggerEditing:(BOOL)canTriggerSpringboardEditingMode tapHandlerBlock:(dispatch_block_t)tapHandlerBlock;
  
@end


@protocol SEBlingLordMenuItemDelegate <NSObject>
  @optional
    - (void) removeFromSpringboard:(NSUInteger)index animate:(BOOL)animate;
    - (void) menuItemWasTapped:(SEBlingLordMenuItem *)menuItem buttonTag:(NSUInteger)buttonTag launchViewController:(SEBlingLordViewController *)viewController;
    - (void) menuItemWasTapped:(SEBlingLordMenuItem *)menuItem buttonTag:(NSUInteger)buttonTag runBlock:(dispatch_block_t)tapHandlerBlock;
@end



