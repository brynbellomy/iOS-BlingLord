//
//  SEBlingLordMenuItem.m
//  SEBlingLord iOS springboard view
//
//  Created by bryn austin bellomy on 5/19/12.
//  Copyright (c) 2012 robot bubble bath LLC. All rights reserved.
//

#import <stdlib.h>
#import <QuartzCore/QuartzCore.h>
#import "SEBlingLordMenuItem.h"
#import "SEBlingLordView.h"

@interface SEBlingLordMenuItem ()
  @property (nonatomic, strong, readwrite) UIButton *button;
  @property (nonatomic, weak,   readwrite) CALayer *glowLayer;
  @property (nonatomic, strong, readwrite) UIButton *removeButton;
  @property (nonatomic, weak,   readwrite) SEBlingLordViewController *vcToLoad;
  @property (nonatomic, copy,   readwrite) dispatch_block_t tapHandlerBlock;
  @property (nonatomic, assign, readwrite) BOOL shouldRunCustomBlockOnTap;
  @property (nonatomic, strong, readwrite) UIView *imageViewShadowWrapper;
  @property (nonatomic, strong, readwrite) UILabel *textLabelShadowWrapper;
@end

@implementation SEBlingLordMenuItem

@synthesize isRemovable = _isRemovable;
@synthesize isInEditingMode = _isInEditingMode;
@synthesize delegate = _delegate;
@synthesize imageView = _imageView;
@synthesize imageViewShadowWrapper = _imageViewShadowWrapper;
@synthesize textLabel = _textLabel;
@synthesize textLabelShadowWrapper = _textLabelShadowWrapper;
@synthesize button = _button;
@synthesize removeButton = _removeButton;
@synthesize vcToLoad = _vcToLoad;
@synthesize tapHandlerBlock = _tapHandlerBlock;
@synthesize shouldRunCustomBlockOnTap = _shouldRunCustomBlockOnTap;
@synthesize glowLayer = _glowLayer;


#pragma mark- Initialization
#pragma mark-

- (id) initWithFrame: (CGRect)frame
               title: (NSString *)title
               image: (UIImage *)image
           removable: (BOOL)removable
      viewController: (SEBlingLordViewController *)viewController {

  self = [super initWithFrame:frame];
  if (self) {
    self.vcToLoad = viewController;
    self.shouldRunCustomBlockOnTap = NO;
    [self commonInitTitle:title image:image removable:removable];
  }
  return self;
}



- (id) initWithFrame: (CGRect)frame
               title: (NSString *)title
               image: (UIImage *)image
           removable: (BOOL)removable
     tapHandlerBlock: (dispatch_block_t)tapHandlerBlock {

  self = [super initWithFrame:frame];
  if (self) {
    self.tapHandlerBlock = tapHandlerBlock;
    self.shouldRunCustomBlockOnTap = YES;
    [self commonInitTitle:title image:image removable:removable];
  }
  return self;
}



- (void) commonInitTitle: (NSString *)title
                   image: (UIImage *)image
               removable: (BOOL)removable {

  self.backgroundColor = [UIColor clearColor];
  self.isInEditingMode = NO;
  self.isRemovable = removable;


  // create the UIImageView

  self.imageView = [[UIImageView alloc] initWithImage:image];
  self.imageView.frame = CGRectZero;
  self.imageView.layer.shadowColor = [UIColor whiteColor].CGColor;
  self.imageView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
  self.imageView.layer.shadowOpacity = 0.8f;
  self.imageView.layer.shadowRadius = 7.0f;
  self.imageView.layer.cornerRadius = 5.0f;
  self.imageView.layer.masksToBounds = YES;


  // create the shadow wrapper for the UIImageView

  self.imageViewShadowWrapper = [[UIView alloc] initWithFrame:CGRectZero];
  self.imageViewShadowWrapper.layer.shadowColor = [UIColor whiteColor].CGColor;
  self.imageViewShadowWrapper.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
  self.imageViewShadowWrapper.layer.shadowOpacity = 0.8f;
  self.imageViewShadowWrapper.layer.shadowRadius = 7.0f;
  self.imageViewShadowWrapper.clipsToBounds = NO;


  // add the UIImageView into the shadow wrapper UIView

  [self.imageViewShadowWrapper addSubview: self.imageView];
  [self addSubview: self.imageViewShadowWrapper];

  self.glowLayer = self.imageViewShadowWrapper.layer; // store a reference to the shadow wrapper's layer for easy access


  // create the text label's shadow

  self.textLabelShadowWrapper = [[UILabel alloc] initWithFrame:CGRectZero];
  self.textLabelShadowWrapper.text = title;
  self.textLabelShadowWrapper.backgroundColor = [UIColor clearColor];
  self.textLabelShadowWrapper.textColor = [UIColor darkTextColor];
  self.textLabelShadowWrapper.textAlignment = UITextAlignmentCenter; // NSTextAlignmentCenter (in iOS 6.0)
  self.textLabelShadowWrapper.lineBreakMode = UILineBreakModeWordWrap; // NSLineBreakByWordWrapping (in iOS 6.0)
  self.textLabelShadowWrapper.numberOfLines = 2;
  self.textLabelShadowWrapper.font = [UIFont systemFontOfSize:15.0f];
  self.textLabelShadowWrapper.alpha = 0.7f;


  // create the text label

  self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.textLabel.text = title;
  self.textLabel.backgroundColor = [UIColor clearColor];
  self.textLabel.textColor = [UIColor lightTextColor];
  self.textLabel.textAlignment = UITextAlignmentCenter; // NSTextAlignmentCenter
  self.textLabel.lineBreakMode = UILineBreakModeWordWrap; // NSLineBreakByWordWrapping;
  self.textLabel.numberOfLines = 2;
  self.textLabel.font = [UIFont systemFontOfSize:15.0f];


  // add the text label and its drop shadow

  [self addSubview: self.textLabelShadowWrapper];
  [self addSubview: self.textLabel];


  // place a clickable button on top of everything

  self.button = [UIButton buttonWithType:UIButtonTypeCustom];
  self.button.frame = CGRectZero;
  self.button.backgroundColor = [UIColor clearColor];
  [self.button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:self.button];


  // add a long-press gesture recognizer for triggering editing mode on the whole springboard

  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressedLong:)];
  [self.button addGestureRecognizer:longPress];


  // create a remove button for removing item from the board (if it's removable)

  if (self.isRemovable) {
    self.removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.removeButton.frame = CGRectZero;
    self.removeButton.backgroundColor = [UIColor clearColor];
    self.removeButton.hidden = YES;
    [self.removeButton setImage:[UIImage imageNamed:@"btn_delete.png"] forState:UIControlStateNormal]; // @@TODO: remove +imageNamed:
    [self.removeButton addTarget:self action:@selector(removeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.removeButton];

    self.removeButton.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  }


  // set up autoresizing masks

  self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.imageViewShadowWrapper.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.textLabelShadowWrapper.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}


- (void) layoutSubviews {
  CGFloat iconDimension = MIN(self.frame.size.width, self.frame.size.height);

  CGFloat labelHeight =  MAX(0.2f * iconDimension, 20.0f);
  labelHeight = MAX(self.frame.size.height - iconDimension, labelHeight);

  iconDimension = MIN(self.frame.size.height - labelHeight, iconDimension);

  CGPoint labelLocation = CGPointMake(0.0f, iconDimension);
  CGSize labelSize = CGSizeMake(self.frame.size.width, labelHeight);


  // set the UIImageView's shadow wrapper's frame within self
  self.imageViewShadowWrapper.frame = CGRectMake(0.0f, 0.0f, iconDimension, iconDimension);

  // set the UIImageView's frame within its shadow wrapper
  self.imageView.frame = CGRectMake(0.0f, 0.0f, iconDimension, iconDimension);


  // set the text drop shadow's frame within self
  self.textLabelShadowWrapper.frame = CGRectMake(labelLocation.x + 1.0f,
                                                 labelLocation.y + 1.0f,
                                                 labelSize.width, labelSize.height);

  // set the text's frame within self
  self.textLabel.frame = CGRectMake(labelLocation.x,
                                    labelLocation.y,
                                    labelSize.width, labelSize.height);

  // set the button's frame within self (it should span the entirety of self so the whole thing is clickable)
  self.button.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);

  // set the remove button's frame if this item is removable
  if (self.isRemovable)
    self.removeButton.frame = CGRectMake(65.0f, 5.0f, 20.0f, 20.0f); // @@TODO: don't hard-code this
}



#pragma mark- UI actions
#pragma mark-

- (void) clickItem: (id) sender {

  // do quick glow-stronger/fade animation

  CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
  anim.duration = 0.07f;
  anim.fromValue = [NSNumber numberWithFloat:7.0f];
  anim.toValue = [NSNumber numberWithFloat:17.0f];
  anim.autoreverses = YES;

  CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
  anim2.duration = 0.07f;
  anim2.fromValue = [NSNumber numberWithFloat:0.8f];
  anim2.toValue = [NSNumber numberWithFloat:1.0f];
  anim2.autoreverses = YES;

  [self.glowLayer addAnimation:anim forKey:@"shadowRadius"];
  [self.glowLayer addAnimation:anim2 forKey:@"shadowOpacity"];


  // Either run the tapHandlerBlock...

  if (self.shouldRunCustomBlockOnTap == YES && self.tapHandlerBlock != nil)
    [self.delegate menuItemWasTapped: self
                            runBlock: self.tapHandlerBlock];


  // ... or launch the provided view controller

  else if (self.vcToLoad != nil)
    [self.delegate menuItemWasTapped: self
                launchViewController: self.vcToLoad];
}



- (void) pressedLong: (id)sender {
  [self.delegate menuItemWasLongPressed:self];
}



- (void) removeButtonTapped:(id) sender  {
  [self.delegate removeButtonWasTapped:self];
}



#pragma mark- Editing mode on/off
#pragma mark-

- (void) setIsInEditingMode:(BOOL)isInEditingMode {

  _isInEditingMode = isInEditingMode;

  // set the remove button's visibility
  self.removeButton.hidden = !isInEditingMode;

  if (isInEditingMode) {
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
  else {
    [self.layer removeAllAnimations];
  }
}





@end



