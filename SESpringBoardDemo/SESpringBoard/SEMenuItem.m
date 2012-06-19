//
//  SEMenuItem.m
//  SESpringBoardDemo
//
//  Created by Sarp Erdag on 11/5/11.
//  Copyright (c) 2011 Sarp Erdag. All rights reserved.
//

#import "SEMenuItem.h"
#import "SESpringBoard.h"
#import <QuartzCore/QuartzCore.h>
#include <stdlib.h>

@interface SEMenuItem ()
  @property (nonatomic, weak, readwrite) UIButton *button;
  @property (nonatomic, weak, readwrite) UIButton *removeButton;
  @property (nonatomic, weak, readwrite) UIViewController *vcToLoad;
  @property (nonatomic, copy, readwrite) dispatch_block_t tapHandlerBlock;
  @property (nonatomic, assign, readwrite) BOOL shouldRunCustomBlockOnTap;
@end

@implementation SEMenuItem

@synthesize isRemovable = _isRemovable;
@synthesize isInEditingMode = _isInEditingMode;
@synthesize delegate = _delegate;
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;
@synthesize button = _button;
@synthesize removeButton = _removeButton;
@synthesize vcToLoad = _vcToLoad;
@synthesize tapHandlerBlock = _tapHandlerBlock;
@synthesize shouldRunCustomBlockOnTap = _shouldRunCustomBlockOnTap;


#pragma mark- Initialization
#pragma mark-

- (id) initWithTitle: (NSString *)title
               image: (UIImage *)image
      viewController: (UIViewController *)viewController
           removable: (BOOL)removable {
  
  self = [super initWithFrame:CGRectMake(0, 0, 100, 100)];
  if (self) {
    self.vcToLoad = viewController;
    self.shouldRunCustomBlockOnTap = NO;
    [self commonInitTitle:title image:image removable:removable];
  }
  return self;
}

- (id) initWithTitle: (NSString *)title
               image: (UIImage *)image
           removable: (BOOL)removable
     tapHandlerBlock: (dispatch_block_t)tapHandlerBlock {
  
  self = [super initWithFrame:CGRectMake(0, 0, 100, 100)];
  if (self) {
    self.tapHandlerBlock = tapHandlerBlock;
    self.shouldRunCustomBlockOnTap = YES;
    [self commonInitTitle:title image:image removable:removable];
  }
  return self;
}

- (void) commonInitTitle:(NSString *)title image:(UIImage *)image removable:(BOOL)removable {
  self.backgroundColor = [UIColor clearColor];
  self.isInEditingMode = NO;
  self.isRemovable = removable;
  
  // add the text label's shadow first (so it's underneath)
  UILabel *textLabelShadow = [[UILabel alloc] initWithFrame: CGRectMake(1.0, 71.0, 100, 50.0)];
  [self addSubview: textLabelShadow];
  //  self.textLabelShadow = textLabelShadow;
  textLabelShadow.text = title;
  textLabelShadow.backgroundColor = [UIColor clearColor];
  textLabelShadow.textColor = [UIColor darkTextColor];
  textLabelShadow.textAlignment = NSTextAlignmentCenter;
  textLabelShadow.lineBreakMode = NSLineBreakByWordWrapping;
  textLabelShadow.numberOfLines = 2;
  textLabelShadow.font = [UIFont systemFontOfSize:12.0f];
  textLabelShadow.alpha = 0.7f;
  
  // add the text label
  UILabel *textLabel = [[UILabel alloc] initWithFrame: CGRectMake(0.0, 70.0, 100, 50.0)];
  [self addSubview: textLabel];
  self.textLabel = textLabel;
  textLabel.text = title;
  textLabel.backgroundColor = [UIColor clearColor];
  textLabel.textColor = [UIColor lightTextColor];
  textLabel.textAlignment = NSTextAlignmentCenter;
  textLabel.lineBreakMode = NSLineBreakByWordWrapping;
  textLabel.numberOfLines = 2;
  textLabel.font = [UIFont systemFontOfSize:12.0f];
  

  
//  textLabel.layer.shadowColor = [UIColor darkGrayColor].CGColor;
//  textLabel.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
//  textLabel.layer.shadowOpacity = 1.0f;
//  textLabel.layer.shadowRadius = 4.0f;
  
  // add the image
  UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
  self.imageView = imageView;
  imageView.frame = CGRectMake(10.0, 10.0, 60, 60);
  imageView.layer.shadowColor = [UIColor whiteColor].CGColor;
  imageView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
  imageView.layer.shadowOpacity = 0.8f;
  imageView.layer.shadowRadius = 7.0f;
  imageView.layer.cornerRadius = 5.0f;
  [imageView.layer setMasksToBounds: YES];
  
  UIView *imageViewShadowWrapper = [[UIView alloc] initWithFrame: CGRectMake(10.0, 0.0, 80.0f, 80.0f)];
  imageViewShadowWrapper.layer.shadowColor = [UIColor whiteColor].CGColor;
  imageViewShadowWrapper.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
  imageViewShadowWrapper.layer.shadowOpacity = 0.8f;
  imageViewShadowWrapper.layer.shadowRadius = 7.0f;
  imageViewShadowWrapper.clipsToBounds = NO;
  [imageViewShadowWrapper addSubview: imageView];
  
  [self addSubview: imageViewShadowWrapper];
  
  
  // place a clickable button on top of everything
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setFrame:CGRectMake(0, 0, 100, 110)];
  button.backgroundColor = [UIColor clearColor];
  [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
  button.tag = self.tag;
  self.button = button;
  
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressedLong:)];
  [button addGestureRecognizer:longPress];
  [self addSubview:button];
  
  if (self.isRemovable) {
    // place a remove button on top right corner for removing item from the board
    UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.removeButton = removeButton;
    self.removeButton.frame = CGRectMake(65, 5, 20, 20);
    self.removeButton.backgroundColor = [UIColor clearColor];
    self.removeButton.tag = self.tag;
    self.removeButton.hidden = YES;
    [self.removeButton setImage:[UIImage imageNamed:@"btn_delete.png"] forState:UIControlStateNormal];
    [self.removeButton addTarget:self action:@selector(removeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: self.removeButton];
  }

}

+ (id) initWithTitle:(NSString *)title
               image:(UIImage *)image
           removable:(BOOL)removable
      viewController:(UIViewController *)viewController {
  
	SEMenuItem *tmpInstance = [[SEMenuItem alloc] initWithTitle:title image:image viewController:viewController removable:removable];
	return tmpInstance;
}

+ (id) initWithTitle:(NSString *)title
               image:(UIImage *)image
           removable:(BOOL)removable
     tapHandlerBlock:(dispatch_block_t)tapHandlerBlock {
  
	SEMenuItem *tmpInstance = [[SEMenuItem alloc] initWithTitle:title image:image removable:removable tapHandlerBlock:tapHandlerBlock];
	return tmpInstance;
}

- (void) dealloc {
  self.delegate = nil;
}



#pragma mark- UI actions
#pragma mark-

- (void) clickItem:(id) sender {
  UIButton *theButton = (UIButton *)sender;
  
  // Either run the tapHandlerBlock...
  if (self.shouldRunCustomBlockOnTap == YES && self.tapHandlerBlock != nil)
    [self.delegate menuItemWasTapped: self
                           buttonTag: theButton.tag
                            runBlock: self.tapHandlerBlock];
  
  // ... or launch the provided view controller
  else if (self.vcToLoad != nil)
    [self.delegate menuItemWasTapped: self
                           buttonTag: theButton.tag
                launchViewController: self.vcToLoad];
}

- (void) pressedLong:(id) sender {
    // inform the springboard that the menu items are now editable so that the springboard
    // will place a done button on the navigationbar
    [(SESpringBoard *)self.delegate enableEditingMode];
}

- (void) removeButtonClicked:(id) sender  {
  [self.delegate removeFromSpringboard:self.tag animate:YES];
}



#pragma mark- Editing mode on/off
#pragma mark-

- (void) enableEditing {

    if (self.isInEditingMode == YES)
        return;
    
    // put item in editing mode
    self.isInEditingMode = YES;
    
    // make the remove button visible
    [self.removeButton setHidden:NO];
    
    // start the wiggling animation
    CATransform3D transform;
    
    if (arc4random() % 2 == 1)
        transform = CATransform3DMakeRotation(-0.08, 0, 0, 1.0);  
    else
        transform = CATransform3DMakeRotation(0.08, 0, 0, 1.0);  
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];  
    animation.toValue = [NSValue valueWithCATransform3D:transform];  
    animation.autoreverses = YES;   
    animation.duration = 0.1;   
    animation.repeatCount = 10000;   
    animation.delegate = self;  
    [self.layer addAnimation:animation forKey:@"wiggleAnimation"];
}

- (void) disableEditing {
    [self.layer removeAllAnimations];
    [self.removeButton setHidden:YES];
    self.isInEditingMode = NO;
}

- (void) updateTag:(int) newTag {
    self.tag = newTag;
    self.removeButton.tag = newTag;
}


#pragma mark- UIView method overrides
#pragma mark-

//- (void) removeFromSuperview {
//  
//  [UIView animateWithDuration:0.2
//                   animations: ^{
//                     self.alpha = 0.0;
//                     self.frame = CGRectMake(self.frame.origin.x+50, self.frame.origin.y+50, 0, 0);
//                     self.removeButton.frame = CGRectMake(0, 0, 0, 0);
//                   }
//                   completion:^(BOOL finished) {
//                     [super removeFromSuperview];
//                   }];
//}



#pragma mark- Drawing
#pragma mark-

//- (void) drawRect:(CGRect)rect {
//  // draw the icon image
//  UIImage* img = [UIImage imageNamed: self.image]; // @@TODO: this method is horrible and must die
//  [img drawInRect:CGRectMake(20.0, 10.0, 60, 60)];
  
//  // draw the menu item title shadow
//  NSString* shadowText = self.titleText;
//  [[UIColor blackColor] set];
//  UIFont *bold14 = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//	[shadowText drawInRect:CGRectMake(0.0, 72.0, 100, 20.0) withFont:bold14 lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
  
//  // draw the menu item title
//  NSString* text = self.titleText;
//  [[UIColor whiteColor] set];
//	[text drawInRect:CGRectMake(0.0, 70.0, 100, 20.0) withFont:bold14 lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
  
  
  
//  // place a clickable button on top of everything
//  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//  [button setFrame:CGRectMake(0, 0, 100, 110)];
//  button.backgroundColor = [UIColor clearColor];
//  [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
//  button.tag = self.tag;
//  
//  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressedLong:)];
//  [button addGestureRecognizer:longPress];
//  [self addSubview:button];
//  
//  if (self.isRemovable) {
//    // place a remove button on top right corner for removing item from the board
//    self.removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.removeButton.frame = CGRectMake(65, 5, 20, 20);
//    self.removeButton.backgroundColor = [UIColor clearColor];
//    self.removeButton.tag = self.tag;
//    self.removeButton.hidden = YES;
//    [self.removeButton setImage:[UIImage imageNamed:@"btn_delete.png"] forState:UIControlStateNormal];
//    [self.removeButton addTarget:self action:@selector(removeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.removeButton];
//  }
//}


@end
