//
//  SEBlingLordView.m
//  SEBlingLord iOS springboard view
//
//  Created by bryn austin bellomy on 5/19/12.
//  Copyright (c) 2012 robot bubble bath LLC. All rights reserved.
//

#import "SEBlingLordView.h"
#import "SEBlingLordViewController.h"
//#import "KJGridLayoutView.h"


/**
 * private interface
 */

@interface SEBlingLordView () {
  NSMutableArray *_items;
}

@property (nonatomic, strong, readwrite) id closeViewNotificationObserver;

@end



/**
 * implementation
 */

@implementation SEBlingLordView

@dynamic items;

#pragma mark- View lifecycle
#pragma mark-

/**
 * Simple initializer; replaces the -initWithFrame: inherited from UIView.
 */

- (id) initWithFrame: (CGRect)frame {
  self = [self initWithFrame:frame itemSize:CGSizeZero itemMargins:CGSizeZero outerMargins:CGSizeZero items:nil];
  return self;
}



/**
 * Designated initializer.
 */

- (id) initWithFrame: (CGRect)frame
            itemSize: (CGSize)itemSize
         itemMargins: (CGSize)itemMargins
//            gridSize: (KJGridPair)gridSize
        outerMargins: (CGSize)outerMargins
               items: (NSMutableArray *)items {

  self = [super initWithFrame:frame];
  if (self) {
//    // let the view take care of resizing itself upon autorotation
//    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    self.rowSpacing = itemMargins.width;
//    self.columnSpacing = itemMargins.height;
//    _gridSize = gridSize;
    
    _itemSize = itemSize;
    _itemMargins = itemMargins;
    _outerMargins = outerMargins;
    _items = [NSMutableArray arrayWithCapacity:items.count];
    if (items != nil) {
      [self addMenuItems:items];
    }
    
    self.isInEditingMode = NO;
    self.allowsEditing = YES;
    self.userInteractionEnabled = YES;
    self.layoutStyle = SEBlingLordLayoutStyleCenterVertically | SEBlingLordLayoutStyleCenterHorizontally;
    
    
    // create a container view to put the menu items inside
    
    self.itemsContainer = [[UIScrollView alloc] initWithFrame: self.frame];
    self.itemsContainer.delegate = self;
    self.itemsContainer.scrollEnabled = YES;
    self.itemsContainer.pagingEnabled = YES;
    self.itemsContainer.showsHorizontalScrollIndicator = NO;
    [self addSubview: self.itemsContainer];
    
    
    // add a page control to self to represent the scrollview's current page
    
    self.pageControl = [[UIPageControl alloc] initWithFrame: CGRectMake(0.0f, self.frame.size.height - 30.0f, self.frame.size.width, 30.0f)];
    self.pageControl.currentPage = 0;
    [self addSubview: self.pageControl];
    
    
    // add observer to respond to "view closed" events
    
    [self createCloseViewNotificationObserver];
  }
  return self;
}



- (void) dealloc {
  
  // remove the notification observer added in the init method
  
  [self destroyCloseViewNotificationObserver];
  
  
  // unset all inverse delegate relationships before i disappear back into the void
  
  for (SEBlingLordMenuItem *item in _items) {
    if (item.delegate == self)
      item.delegate = nil;
  }
  
  if (self.itemsContainer.delegate == self)
    self.itemsContainer.delegate = nil;
  
  
  // ... *pop!*
}



#pragma mark- Subview layout
#pragma mark-

/**
 * Override the default setter so we can trigger -setNeedsLayout when
 * layoutStyle changes.
 */

- (void) setLayoutStyle:(SEBlingLordLayoutStyle)layoutStyle {
  _layoutStyle = layoutStyle;
  [self setNeedsLayout];
}



/**
 * Overrides UIView's -layoutSubviews.
 */

- (void) layoutSubviews {
  [super layoutSubviews];
  [self layoutMenuItems];
}



/**
 * This is broken out into its own method because it needs to be callable by
 * -removeMenuItem:animated: when animating the re-layout of the menu items after
 * one is removed.  You shouldn't do animations inside of -layoutSubviews, but
 * the required functionality is identical, so moving this code to a separate
 * method callable by both of the aforementioned methods was the most concise
 * solution.
 */

- (void) layoutMenuItems {
  
  // calculate some helpful stuff
  
  NSUInteger itemsPerRow = floor((self.itemsContainer.frame.size.width  - (2 * self.outerMargins.width))
                                 / ((self.itemMargins.width  + self.itemSize.width ) - self.itemMargins.width));
  NSUInteger rowsPerPage = floor((self.itemsContainer.frame.size.height - (2 * self.outerMargins.height))
                                 / ((self.itemMargins.height + self.itemSize.height) - self.itemMargins.height));
  NSUInteger itemsPerPage = rowsPerPage * itemsPerRow;
  NSUInteger numberOfPages = ceil((Float32)_items.count / (Float32)itemsPerPage);
  
  
  // calculate positions for each item within the itemsContainer UIScrollView
  
  NSUInteger currentItem = 0;
  NSUInteger currentPage = 0;
  CGFloat currentXPos = 0.0f;
  CGFloat currentYPos = 0.0f;
  
  // if auto-centering (horiz, vert, or both) is enabled, calculate the number
  // of pixels we'll have to add to the left and/or top margins to center the
  // items in the view
  
  CGSize additionalCenteringPixels = CGSizeZero;
  
  if ((self.layoutStyle & SEBlingLordLayoutStyleCenterHorizontally) != 0) {
    additionalCenteringPixels.width = self.itemsContainer.frame.size.width
                                          - (itemsPerRow * (self.itemSize.width + self.itemMargins.width) - self.itemMargins.width)
                                          - (self.outerMargins.width * 2.0f);
  }
  
  if ((self.layoutStyle & SEBlingLordLayoutStyleCenterVertically) != 0) {
    additionalCenteringPixels.height = self.itemsContainer.frame.size.height
                                          - (rowsPerPage * (self.itemSize.height + self.itemMargins.height) - self.itemMargins.height)
                                          - (self.outerMargins.height * 2.0f);
  }
  
  
  // loop through all of the menu items and place them
  
  for (SEBlingLordMenuItem *item in _items) {
    currentPage = floor((CGFloat)currentItem / (CGFloat)itemsPerPage);
    item.delegate = self;
    item.frame = CGRectMake((additionalCenteringPixels.width  / 2.0f) + self.outerMargins.width  + currentXPos + (currentPage * self.itemsContainer.frame.size.width),
                            (additionalCenteringPixels.height / 2.0f) + self.outerMargins.height + currentYPos,
                            self.itemSize.width, self.itemSize.height);
    
    currentXPos += (self.itemSize.width + self.itemMargins.width);
    currentItem++;
    
    // start over on next row
    if (currentItem % itemsPerRow == 0) {
      currentYPos += (self.itemSize.height + self.itemMargins.height);
      currentXPos = 0;
    }
    
    // start over on new page
    if (currentItem % itemsPerPage == 0) {
      currentYPos = 0;
    }
  }
  
  
  // record the item counts for each page
  
  self.itemsContainer.contentSize = CGSizeMake(self.itemsContainer.frame.size.width * numberOfPages,
                                               self.itemsContainer.frame.size.height);
  
  
  // set the page control's frame relative to the size and position of the scrollview
  
  self.pageControl.frame = CGRectMake(self.itemsContainer.frame.origin.x,
                                      self.itemsContainer.frame.origin.y + self.itemsContainer.frame.size.height,
                                      self.itemsContainer.frame.size.width, 20.0f);
  
  if (numberOfPages > 1)
    self.pageControl.numberOfPages = numberOfPages;
}



#pragma mark- Notification handlers
#pragma mark-

/**
 * Creates the notification observer triggered when the SEBlingLordNotificationCloseView
 * notification is posted.  The notification handler responds to this by performing
 * a UIView animation to make the closed view seem to reduce in size until it
 * disappears.
 */

- (void) createCloseViewNotificationObserver {
  __weak SEBlingLordView *weakSelf = self;
  
  self.closeViewNotificationObserver = 
    [[NSNotificationCenter defaultCenter]
         addObserverForName: SEBlingLordNotificationCloseView
                     object: nil queue: [NSOperationQueue mainQueue]
                 usingBlock: ^(NSNotification *note) {
       
                         __block UIView *viewToRemove = (UIView *)note.object;    
                   
                         // create an animation of the view disappearing
                   
                         [UIView animateWithDuration:0.3f animations:^{
                               __strong SEBlingLordView *strongSelf = weakSelf;
                               
                               viewToRemove.alpha = 0.0f;
                               viewToRemove.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
                               
                               for (SEBlingLordMenuItem *item in strongSelf.items) {
                                 item.transform = CGAffineTransformIdentity;
                                 item.alpha = 1.f;
                               }
             
                         } completion: ^(BOOL finished) {
                               [viewToRemove removeFromSuperview];
                         }];
                 }];
}



/**
 * Destroys the notification handler for SEBlingLordNotificationCloseView.
 */

- (void) destroyCloseViewNotificationObserver {
  if (self.closeViewNotificationObserver != nil) {
    [[NSNotificationCenter defaultCenter] removeObserver:self.closeViewNotificationObserver];
    self.closeViewNotificationObserver = nil;
  }
}



#pragma mark- Public methods for adding/removing items
#pragma mark-

/**
 * Add a single menu item.
 */

- (void) addMenuItem:(SEBlingLordMenuItem *)menuItem {
  NSAssert(menuItem != nil, @"menuItem argument is nil.");
  
  [_items addObject:menuItem];
  [self.itemsContainer addSubview:menuItem];
  
//  KJGridPair newPos = SEGetGridPosition(_items.count, self.gridSize.columns);
//  [self addSubview:menuItem row:newPos.row column:newPos.col];
}



/**
 * Add an array of menu items.
 */

- (void) addMenuItems:(NSArray *)menuItems {
  NSAssert(menuItems != nil, @"menuItems argument is nil.");
  
//  NSUInteger numCols = self.gridSize.columns;
  
  [_items addObjectsFromArray:menuItems];
  
  for (SEBlingLordMenuItem *menuItem in menuItems) {
    [self.itemsContainer addSubview:menuItem];
//    KJGridPair newPos = SEGetGridPosition(_items.count, numCols);
//    [self addSubview:menuItem row:newPos.row column:newPos.col];
  }
  
  [self setNeedsLayout];
}



/**
 * Removes a given menu item.
 */

- (void) removeMenuItemAtIndex: (NSUInteger)idx
                       animate: (BOOL)animate {
  
  NSAssert(idx < _items.count, @"index argument is out of bounds.");
  NSAssert(idx < self.subviews.count, @"index argument is out of bounds.");
  
  if (animate) {
    __weak SEBlingLordView *weakSelf = self;
    
    [UIView animateWithDuration:0.2f animations: ^{
      
      // find the item ...
      __strong SEBlingLordView *strongSelf = weakSelf;
      SEBlingLordMenuItem *item = _items[idx];
      
      [_items removeObjectAtIndex:idx];
      [item removeFromSuperview];  // remove the item from the scrollview
      [strongSelf layoutMenuItems]; // reposition the other items to fill the gap
      
    } completion:^(BOOL finished) {
      
      __strong SEBlingLordView *strongSelf = weakSelf;
      [strongSelf setNeedsLayout]; // just in case
      
    }];
  }
  else {
    SEBlingLordMenuItem *item = _items[idx];
    
    [_items removeObjectAtIndex:idx];
    [item removeFromSuperview]; // remove the item from the scrollview
    [self setNeedsLayout];
  }
}



/**
 * Removes all menu items from the springboard.
 */

- (void) removeAllMenuItems {
  for (SEBlingLordMenuItem *item in _items) {
    [item removeFromSuperview];
  }
  _items = [NSMutableArray array];
  [self setNeedsLayout];
}



/**
 * Make sure we properly remove the existing menu items (if any) before adding
 * a new set.
 */

- (void) setItems:(NSArray *)items {
  [self removeAllMenuItems];
  _items = [items mutableCopy];
}



/**
 * Return a non-mutable version of the items array to prevent improper access.
 */

- (NSArray *) items {
  return [NSArray arrayWithArray:_items];
}


//- (void)removeFromSpringboard:(NSUInteger)index animate:(BOOL)animate {
//  
//  // Remove the selected menu item from the springboard, it will have a animation while disappearing
//  SEBlingLordMenuItem *menuItem = [self.items objectAtIndex:index];
//  [menuItem removeFromSuperview];
//  
//  NSUInteger numberOfItemsInCurrentPage = [((NSNumber *)[self.itemCounts objectAtIndex:self.pageControl.currentPage]) unsignedIntegerValue];
//  
//  // First find the index of the current item with respect of the current page
//  // so that only the items coming after the current item will be repositioned.
//  // The index of the item can be found by looking at its coordinates
//  NSUInteger mult = ((NSUInteger)menuItem.frame.origin.y) / 95;
//  NSUInteger add = ((NSUInteger)menuItem.frame.origin.x % 300)/100;
//  NSUInteger pageSpecificIndex = (mult*3) + add;
//  NSUInteger remainingNumberOfItemsInPage = numberOfItemsInCurrentPage-pageSpecificIndex;    
//  
//  // Select the items listed after the deleted menu item
//  // and move each of the ones on the current page, one step back.
//  // The first item of each row becomes the last item of the previous row.
//  for (NSUInteger i = index+1; i<[self.items count]; i++) {
//    SEBlingLordMenuItem *item = [self.items objectAtIndex:i];
//    if (animate == YES) {
//      [UIView animateWithDuration:0.2 animations:^{
//        
//        // Only reposition the items in the current page, coming after the current item
//        if (i < index + remainingNumberOfItemsInPage) {
//          
//          NSUInteger intVal = item.frame.origin.x;
//          // Check if it is the first item in the row
//          if (intVal % 3 == 0)
//            [item setFrame:CGRectMake(item.frame.origin.x+200, item.frame.origin.y-95, item.frame.size.width, item.frame.size.height)];
//          else 
//            [item setFrame:CGRectMake(item.frame.origin.x-100, item.frame.origin.y, item.frame.size.width, item.frame.size.height)];
//        }            
//        
//        // Update the tag to match with the index. Since the an item is being removed from the array, 
//        // all the items' tags coming after the current item has to be decreased by 1.
//        item.tag--;
//      }];
//    }
//    else {
//      item.tag--;
//    }
//  }
//  // remove the item from the array of items
//  [self.items removeObjectAtIndex:index];
//  // also decrease the record of the count of items on the current page and save it in the array holding the data
//  numberOfItemsInCurrentPage--;
//  [self.itemCounts replaceObjectAtIndex: self.pageControl.currentPage
//                             withObject:[NSNumber numberWithInteger:numberOfItemsInCurrentPage]];
//}




#pragma mark- SEBlingLordMenuItem delegate methods
#pragma mark-


- (void) menuItemWasLongPressed:(SEBlingLordMenuItem *)menuItem {
  if (self.allowsEditing && self.isInEditingMode == NO)
    self.isInEditingMode = YES;
}



- (void) menuItemWasTapped: (SEBlingLordMenuItem *)menuItem
                  runBlock: (dispatch_block_t)tapHandlerBlock {
  
  // first disable the editing mode so that items will stop wiggling when an item is launched
  self.isInEditingMode = NO;
  
  if (tapHandlerBlock != nil) {
    tapHandlerBlock();
  }
}



/**
 * @@TODO: refactor this sumbitch
 */

- (void) menuItemWasTapped: (SEBlingLordMenuItem *)menuItem
      launchViewController: (SEBlingLordViewController *)viewController {
  
  // if the springboard is in editing mode, do not launch any view controller
  if (self.isInEditingMode)
    return;
  
  // first disable the editing mode so that items will stop wiggling when an item is launched
  self.isInEditingMode = NO;
  
  // manually trigger the appear method
  [viewController viewDidAppear:YES];
  
  // attach the launcher image
  viewController.launcherImage = self.launcherImage;
  
  // create a navigation bar
  self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
  [self.navigationController viewDidAppear:YES];
  self.navigationController.view.alpha = 0.0f;
  self.navigationController.view.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
  [self addSubview: self.navigationController.view];
  
  [UIView animateWithDuration: 0.3f animations: ^{
    // fade out the buttons
    for (SEBlingLordMenuItem *item in _items) {
      item.transform = [self offscreenQuadrantTransformForView:item];
      item.alpha = 0.0f;
    }
    
    // fade in the selected view
    self.navigationController.view.alpha = 1.0f;
    self.navigationController.view.transform = CGAffineTransformIdentity;
    self.navigationController.view.frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height);
  }];
}


- (void) removeButtonWasTapped:(SEBlingLordMenuItem *)menuItem {

  NSUInteger index = [_items indexOfObject:menuItem];
  
  if (index != NSNotFound) {
    [self removeMenuItemAtIndex: index
                        animate: YES];
  }
}


/**
 * Transition animation function required for the springboard look and feel.
 * Used by menuItemWasTapped:buttonTag:launchViewController:.
 */

- (CGAffineTransform) offscreenQuadrantTransformForView: (UIView *)theView {
  CGPoint parentMidpoint = CGPointMake(CGRectGetMidX(theView.superview.bounds), CGRectGetMidY(theView.superview.bounds));
  CGFloat xSign = (theView.center.x < parentMidpoint.x) ? -1.f : 1.f;
  CGFloat ySign = (theView.center.y < parentMidpoint.y) ? -1.f : 1.f;
  return CGAffineTransformMakeTranslation(xSign * parentMidpoint.x, ySign * parentMidpoint.y);
}



#pragma mark- UIScrollView Delegate Methods
#pragma mark-

/**
 * Respond to the scrollView scrolling by changing which page we're on.
 */

- (void)scrollViewDidScroll:(UIScrollView *)sender {
  CGFloat pageWidth = self.itemsContainer.frame.size.width;
  NSUInteger page = (NSUInteger) (floor((self.itemsContainer.contentOffset.x - pageWidth / 2) / pageWidth) + 1);
  self.pageControl.currentPage = page;
}



#pragma mark- Editing mode on/off
#pragma mark-

/**
 * Set whether editing the menu items is allowed, and, if we're setting it to
 * "editing not allowed" and we happen to be IN editing mode right now, automatically
 * cancel editing mode.
 */

- (void) setAllowsEditing:(BOOL)allowsEditing {
  
  _allowsEditing = allowsEditing;
  
  // update whether or not we're in editing mode (i.e., if we ARE already, and
  // we've just set "allowsEditing" to NO, then auto-disable editing mode so we
  // don't end up in an inconsistent state
  self.isInEditingMode = self.isInEditingMode;
}



/**
 * Enable or disable editing mode.
 */

- (void) setIsInEditingMode:(BOOL)isInEditingMode {
  
  // if editing isn't allowed, make sure it can't be enabled
  if (self.allowsEditing == NO)
    isInEditingMode = NO;
  else
    _isInEditingMode = isInEditingMode;
      
  // tell all of the menu items what's up
  for (SEBlingLordMenuItem *item in _items)
    item.isInEditingMode = isInEditingMode;
  
  // tell the "done editing" button what's up
  self.doneEditingButton.hidden = !isInEditingMode;
}



/**
 * Default behavior for the "done editing" button (sets editing mode to NO).
 */

- (IBAction) doneEditingButtonClicked {
  self.isInEditingMode = NO;
}



- (void) setItemSize:(CGSize)itemSize {
  _itemSize = itemSize;
  [self setNeedsLayout];
}



- (void) setItemMargins:(CGSize)itemMargins {
  _itemMargins = itemMargins;
  [self setNeedsLayout];
}



- (void) setOuterMargins:(CGSize)outerMargins {
  _outerMargins = outerMargins;
  [self setNeedsLayout];
}





@end






