# // bling lord


## what

**SEBlingLord** is an iOS springboard view controller class (y’know, it looks like the iPhone/iPad home screen).  Setup is pretty easy.  See below.




## how

```objective-c
vc1 = [[MyFacebookViewController alloc] initWithNibName:@"MyFacebookViewController" bundle:nil];
vc2 = [[MyTwitterViewController alloc] initWithNibName:@"MyTwitterViewController" bundle:nil];
// create or reference more view controllers here
// ... also be sure to extend your view controllers from SEBlingLordViewController
    
NSString *facebookIconPath = [[NSBundle mainBundle] pathForResource: @"facebook" ofType: @"png"];
UIImage *facebookIcon = [UIImage imageWithContentsOfFile: iconPath];

NSString *twitterIconPath = [[NSBundle mainBundle] pathForResource: @"twitter" ofType: @"png"];
UIImage *twitterIcon = [UIImage imageWithContentsOfFile: iconPath];

CGRect menuItemFrame = CGRectMake(0.0f, 0.0f, 60.0f, 60.0f);

// these first two menu items automatically push the user to the specified view controller when they're tapped
SEBlingLordMenuItem *item1 =
    [[SEBlingLordMenuItem alloc] initWithFrame: menuItemFrame
                                         title: @"Facebook"
                                         image: facebookIcon
                                     removable: NO
                             canTriggerEditing: NO
                                viewController: vc1];
SEBlingLordMenuItem *item2 =
    [[SEBlingLordMenuItem alloc] initWithFrame: menuItemFrame
                                         title: @"Twitter"
                                         image: twitterIcon
                                     removable: NO
                             canTriggerEditing: NO
                                viewController: vc2];

// this menu item executes a block when it's tapped
SEBlingLordMenuItem *item3 =
    [[SEBlingLordMenuItem alloc] initWithFrame: menuItemFrame
                                         title: @"Some alert"
                                         image: someOtherIcon
                                     removable: NO
                             canTriggerEditing: NO
                               tapHandlerBlock: ^{
                                   UIAlertView *someStupidAlert = ...
                                   // ... etc.
                                   // note that the block is a simple dispatch_block_t,
                                   // i.e., it takes no params and returns void.
                               }];
// ... etc


// create an array containing the menu items and pass it to a newly created SEBlingLordView 
NSArray *items = [NSArray arrayWithObjects: item1, item2, item3, nil];
SEBlingLordView *board = [[SEBlingLordView alloc] initWithFrame: self.view.frame
                                                       itemSize: menuItemFrame.size
                                                    itemMargins: CGSizeMake(15.0f, 15.0f)
                                                   outerMargins: CGSizeMake(10.0f, 10.0f)
                                                          items: items];

// ... and add the BlingLordView to your view
[self.view addSubview:board];

// add more menu items later if necessary
[board addMenuItem: item4];
[board addMenuItems: [NSArray arrayWithObjects: item5, item6, item7, nil]];

// and remove them as well
[board removeMenuItemAtIndex:4 animate:NO];
[board removeAllMenuItems];

```

more to come, perhaps.




## screenshots

![alt text](http://dl.dropbox.com/u/1124427/SESpringBoard.png "SEBlingLord Paged")
![alt text](http://dl.dropbox.com/u/1124427/sepringboard_wiggle.png "SEBlingLord Wiggling")




## license (WTFPL)

DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
Version 2, December 2004

Copyright (C) 2004 Sam Hocevar <[sam@hocevar.net](mailto:sam@hocevar.net)>

Everyone is permitted to copy and distribute verbatim or modified 
copies of this license document, and changing it is allowed as long 
as the name is changed. 

DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

0. You just DO WHAT THE FUCK YOU WANT TO. 
