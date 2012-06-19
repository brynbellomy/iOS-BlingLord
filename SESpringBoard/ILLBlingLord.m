//
//  ILLBlingLord.m
//  ILLBlingLord iOS springboard view
//
//  Created by bryn austin bellomy on 5/19/12.
//  Based on code by Sarp Erdag written on 11/5/11.
//  Copyright (c) 2012 bryn austin bellomy. All rights reserved.
//

#import "ILLBlingLord.h"
#import "ILLBlingLordViewController.h"

@interface ILLBlingLord ()
  @property (nonatomic, assign, readwrite) BOOL isInEditingMode;
  @property (nonatomic, strong, readwrite) NSString *navbarTitle;
@end

@implementation ILLBlingLord

@synthesize items = _items;
@synthesize navbarTitle = _navbarTitle;
@synthesize launcherImage = _launcherImage;
@synthesize isInEditingMode = _isInEditingMode;
@synthesize itemCounts = _itemCounts;
@synthesize allowsEditing = _allowsEditing;
@synthesize navigationBar = _navigationBar;
@synthesize navigationController = _navigationController;
@synthesize itemsContainer = _itemsContainer;
@synthesize pageControl = _pageControl;
@synthesize doneEditingButton = _doneEditingButton;


#pragma mark- Initialization
#pragma mark-

- (id) initWithNavbarTitle: (NSString *)navbarTitle
                     items: (NSMutableArray *)menuItems
             launcherImage: (UIImage *) launcherImage {
  
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    self = [super initWithFrame:CGRectMake(0, 0, 320, 460)];
  else self = [super initWithFrame:CGRectMake(0, 0, 768, 1004)]; // @@TODO: is this correct for an iPad?
  
  [self setUserInteractionEnabled:YES];
  if (self) {
    self.launcherImage = launcherImage;
    self.isInEditingMode = NO;
    self.allowsEditing = YES;
    
    // create the top bar
    if (navbarTitle != nil) {
      UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
      // add a simple for displaying a title on the bar
      UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
      titleLabel.textColor = [UIColor whiteColor];
      titleLabel.backgroundColor = [UIColor clearColor];
      titleLabel.textAlignment = UITextAlignmentCenter;
      titleLabel.text = navbarTitle;
      [navigationBar addSubview: titleLabel];
      self.navbarTitle = navbarTitle;
      
      // add a button to the right side that will become visible when the items are in editing mode
      // clicking this button ends editing mode for all items on the springboard
      UIButton *doneEditingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
      doneEditingButton.frame = CGRectMake(265, 5, 50, 34.0);
      [doneEditingButton setTitle:@"Done" forState:UIControlStateNormal];
      doneEditingButton.backgroundColor = [UIColor clearColor];
      [doneEditingButton addTarget:self action:@selector(doneEditingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
      [doneEditingButton setHidden:YES];
      [navigationBar addSubview:doneEditingButton];
      self.doneEditingButton = doneEditingButton;
      
      [self addSubview: navigationBar];
      self.navigationBar = navigationBar;
    }
    
    // create a container view to put the menu items inside
    CGFloat ycoordStart = (navbarTitle == nil ? 0.0f : 50.0f);
    UIScrollView *itemsContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(10, ycoordStart, 300, 400)];
    itemsContainer.delegate = self;
    [itemsContainer setScrollEnabled:YES];
    [itemsContainer setPagingEnabled:YES];
    itemsContainer.showsHorizontalScrollIndicator = NO;
    [self addSubview:itemsContainer];
    self.itemsContainer = itemsContainer;
    
    self.items = menuItems;
    int counter = 0;
    int horgap = 0;
    int vergap = 0;
    int numberOfPages = (ceil((float)[menuItems count] / 12));
    int currentPage = 0;
    for (ILLBlingLordMenuItem *item in self.items) {
      currentPage = counter / 12;
      item.tag = counter;
      item.delegate = self;
      [item setFrame:CGRectMake(item.frame.origin.x + horgap + (currentPage*300), item.frame.origin.y + vergap, 100, 100)];
      [itemsContainer addSubview:item];
      horgap = horgap + 100;
      counter = counter + 1;
      if(counter % 3 == 0){
        vergap = vergap + 95;
        horgap = 0;
      }
      if (counter % 12 == 0) {
        vergap = 0;
      }
    }
    
    // record the item counts for each page
    self.itemCounts = [NSMutableArray array];
    int totalNumberOfItems = [self.items count];
    int numberOfFullPages = totalNumberOfItems % 12;
    int lastPageItemCount = totalNumberOfItems - numberOfFullPages%12;
    for (int i=0; i<numberOfFullPages; i++)
      [self.itemCounts addObject:[NSNumber numberWithInteger:12]];
    if (lastPageItemCount != 0)
      [self.itemCounts addObject:[NSNumber numberWithInteger:lastPageItemCount]];
    
    [itemsContainer setContentSize:CGSizeMake(numberOfPages*300, itemsContainer.frame.size.height)];
    
    // add a page control representing the page the scrollview controls
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 433, 320, 20)];
    if (numberOfPages > 1) {
      pageControl.numberOfPages = numberOfPages;
      pageControl.currentPage = 0;
    }
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    // add listener to detect close view events
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(closeViewEventHandler:)
                                                 name: @"closeView"
                                               object: nil];
  }
  return self;
}

+ (id) initWithNavbarTitle:(NSString *)navbarTitle items:(NSMutableArray *)menuItems launcherImage:(UIImage *)launcherImage {
  ILLBlingLord *tmpInstance = [[ILLBlingLord alloc] initWithNavbarTitle:navbarTitle items:menuItems launcherImage:launcherImage];
	return tmpInstance;
}




#pragma mark- Animation
#pragma mark-

// transition animation function required for the springboard look & feel
- (CGAffineTransform) offscreenQuadrantTransformForView: (UIView *)theView {
  CGPoint parentMidpoint = CGPointMake(CGRectGetMidX(theView.superview.bounds), CGRectGetMidY(theView.superview.bounds));
  CGFloat xSign = (theView.center.x < parentMidpoint.x) ? -1.f : 1.f;
  CGFloat ySign = (theView.center.y < parentMidpoint.y) ? -1.f : 1.f;
  return CGAffineTransformMakeTranslation(xSign * parentMidpoint.x, ySign * parentMidpoint.y);
}




#pragma mark- ILLBlingLord delegate methods
#pragma mark-

- (void) menuItemWasTapped: (ILLBlingLordMenuItem *)menuItem
                 buttonTag: (int)buttonTag
                  runBlock: (dispatch_block_t)tapHandlerBlock {
  
  // first disable the editing mode so that items will stop wiggling when an item is launched
  [self disableEditingMode];
  
  if (tapHandlerBlock != nil) {
    tapHandlerBlock();
  }
}

- (void) menuItemWasTapped: (ILLBlingLordMenuItem *)menuItem
                 buttonTag: (int)buttonTag
      launchViewController: (ILLBlingLordViewController *)viewController {
  
  // if the springboard is in editing mode, do not launch any view controller
  if (self.isInEditingMode)
    return;
  
  // first disable the editing mode so that items will stop wiggling when an item is launched
  [self disableEditingMode];
  
  // manually trigger the appear method
  [viewController viewDidAppear:YES];
  
  viewController.launcherImage = self.launcherImage;
  
  // create a navigation bar
  self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
  [self.navigationController viewDidAppear:YES];
  self.navigationController.view.alpha = 0.f;
  self.navigationController.view.transform = CGAffineTransformMakeScale(.1f, .1f);
  [self addSubview: self.navigationController.view];
  
  [UIView animateWithDuration:.3f  animations:^{
    // fade out the buttons
    for(ILLBlingLordMenuItem *item in self.items) {
      item.transform = [self offscreenQuadrantTransformForView:item];
      item.alpha = 0.f;
    }
    
    // fade in the selected view
    self.navigationController.view.alpha = 1.f;
    self.navigationController.view.transform = CGAffineTransformIdentity;
    [self.navigationController.view setFrame:CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height)];
    
    // fade out the top bar
    [self.navigationBar setFrame:CGRectMake(0, -44, 320, 44)];
  }];
}


- (void) removeAllMenuItemsFromSpringboard {
  for (int i = self.items.count - 1; i >= 0; i--) {
    [self removeFromSpringboard:i animate:NO];
  }
}

- (void)removeFromSpringboard:(int)index animate:(BOOL)animate {
  
  // Remove the selected menu item from the springboard, it will have a animation while disappearing
  ILLBlingLordMenuItem *menuItem = [self.items objectAtIndex:index];
  [menuItem removeFromSuperview];
  
  int numberOfItemsInCurrentPage = [[self.itemCounts objectAtIndex:self.pageControl.currentPage] intValue];
  
  // First find the index of the current item with respect of the current page
  // so that only the items coming after the current item will be repositioned.
  // The index of the item can be found by looking at its coordinates
  int mult = ((int)menuItem.frame.origin.y) / 95;
  int add = ((int)menuItem.frame.origin.x % 300)/100;
  int pageSpecificIndex = (mult*3) + add;
  int remainingNumberOfItemsInPage = numberOfItemsInCurrentPage-pageSpecificIndex;    
  
  // Select the items listed after the deleted menu item
  // and move each of the ones on the current page, one step back.
  // The first item of each row becomes the last item of the previous row.
  for (int i = index+1; i<[self.items count]; i++) {
    ILLBlingLordMenuItem *item = [self.items objectAtIndex:i];
    if (animate == YES) {
      [UIView animateWithDuration:0.2 animations:^{
        
        // Only reposition the items in the current page, coming after the current item
        if (i < index + remainingNumberOfItemsInPage) {
          
          int intVal = item.frame.origin.x;
          // Check if it is the first item in the row
          if (intVal % 3 == 0)
            [item setFrame:CGRectMake(item.frame.origin.x+200, item.frame.origin.y-95, item.frame.size.width, item.frame.size.height)];
          else 
            [item setFrame:CGRectMake(item.frame.origin.x-100, item.frame.origin.y, item.frame.size.width, item.frame.size.height)];
        }            
        
        // Update the tag to match with the index. Since the an item is being removed from the array, 
        // all the items' tags coming after the current item has to be decreased by 1.
        [item updateTag:item.tag-1];
      }];
    }
    else {
      [item updateTag:item.tag-1];
    }
  }
  // remove the item from the array of items
  [self.items removeObjectAtIndex:index];
  // also decrease the record of the count of items on the current page and save it in the array holding the data
  numberOfItemsInCurrentPage--;
  [self.itemCounts replaceObjectAtIndex: self.pageControl.currentPage
                             withObject:[NSNumber numberWithInteger:numberOfItemsInCurrentPage]];
}

- (void)closeViewEventHandler: (NSNotification *) notification {
  NSLog(@"In closeViewEventHandler");
  UIView *viewToRemove = (UIView *) notification.object;    
  [UIView animateWithDuration:.3f animations:^{
    viewToRemove.alpha = 0.f;
    viewToRemove.transform = CGAffineTransformMakeScale(.1f, .1f);
    for(ILLBlingLordMenuItem *item in self.items) {
      item.transform = CGAffineTransformIdentity;
      item.alpha = 1.f;
    }
    self.navigationBar.frame = CGRectMake(0, 0, 320, 44);
  } completion:^(BOOL finished) {
    [viewToRemove removeFromSuperview];
  }];
  
  // release the dynamically created navigation bar
}



#pragma mark- UIScrollView Delegate Methods
#pragma mark-

- (void)scrollViewDidScroll:(UIScrollView *)sender {
  CGFloat pageWidth = self.itemsContainer.frame.size.width;
  int page = floor((self.itemsContainer.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
  self.pageControl.currentPage = page;
}



#pragma mark- Editing mode on/off
#pragma mark-

- (void) disableEditingMode {
  // loop thu all the items of the board and disable each's editing mode
  for (ILLBlingLordMenuItem *item in self.items)
    [item disableEditing];
  
  [self.doneEditingButton setHidden:YES];
  self.isInEditingMode = NO;
}

- (void) enableEditingMode {
  if (self.allowsEditing == NO)
    return;
  
  for (ILLBlingLordMenuItem *item in self.items)
    [item enableEditing];
  
  // show the done editing button
  [self.doneEditingButton setHidden:NO];
  self.isInEditingMode = YES;
}

- (IBAction) doneEditingButtonClicked {
  [self disableEditingMode];
}


@end
