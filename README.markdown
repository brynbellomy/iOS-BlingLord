# // bling lord


## what

**ILLBlingLord** is an iOS springboard view controller class (y’know, it looks like the iPhone/iPad home screen).  Setup is pretty easy.  See below.




## how

```objective-c
vc1 = [[MyFacebookViewController alloc] initWithNibName:@"MyFacebookViewController" bundle:nil];
vc2 = [[MyTwitterViewController alloc] initWithNibName:@"MyTwitterViewController" bundle:nil];
// create or reference more view controllers here
// ... also be sure to extend your view controllers from ILLBlingLordViewController
    
NSString *facebookIconPath = [[NSBundle mainBundle] pathForResource: @"facebook" ofType: @"png"]; // @@TODO: refactor to framework style
UIImage *facebookIcon = [UIImage imageWithContentsOfFile: iconPath];

NSString *twitterIconPath = [[NSBundle mainBundle] pathForResource: @"twitter" ofType: @"png"]; // @@TODO: refactor to framework style
UIImage *twitterIcon = [UIImage imageWithContentsOfFile: iconPath];

// create an array of ILLBlingLordMenuItem objects
NSMutableArray *items = [NSMutableArray array];

// these first two menu items automatically push the user to the specified view controller when they're tapped
[items addObject:[ILLBlingLordMenuItem initWithTitle:@"facebook" image:facebookIcon removable:YES viewController:vc1]];
[items addObject:[ILLBlingLordMenuItem initWithTitle:@"twitter" image:twitterIcon removable:NO viewController:vc2]];

// this menu item executes a block when it's tapped
[items addObject:[ILLBlingLordMenuItem initWithTitle: @"twitter"
                                               image: twitterIcon
                                           removable: NO
                                     tapHandlerBlock: ^{
                                       UIAlertView *someStupidAlert = ...
                                       // ... etc.
                                       // note that the block is a simple dispatch_block_t,
                                       // i.e., it takes no params and returns void.
                                     }]];
// ... etc
    
// pass the array to a newly created ILLBlingLord and add it to your view
// ... but for the love of god, please don't use [UIImage imageNamed:]
ILLBlingLord *board = [ILLBlingLord initWithTitle:@"Welcome" items:items launcherImage:[UIImage imageNamed:@"navbtn_home.png"]];
[self.view addSubview:board];
```




## customization

### automatic navigation bar on/off

if you don't want the navbar, pass `nil` as the title parameter to **ILLBlingLord**'s init method, like so:

```objective-c
ILLBlingLord *board = [ILLBlingLord initWithTitle:nil items:items launcherImage:[UIImage imageNamed:@"navbtn_home.png"]];
```

more to come, perhaps.




## screenshots

![alt text](http://dl.dropbox.com/u/1124427/SESpringBoard.png "ILLBlingLord Paged")
![alt text](http://dl.dropbox.com/u/1124427/sepringboard_wiggle.png "ILLBlingLord Wiggling")




## license (MIT)

Copyright (c) 2012 bryn austin bellomy < <bryn@signals.io> >

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
