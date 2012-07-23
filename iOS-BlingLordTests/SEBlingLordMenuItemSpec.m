//
//  SEBlingLordMenuItemSpec.m
//  SEBlingLord iOS springboard view
//
//  Created by bryn austin bellomy on 5/19/12.
//  Copyright (c) 2012 bryn austin bellomy. All rights reserved.
//

#import "Kiwi.h"
#import "SEBlingLordMenuItem.h"

SPEC_BEGIN(SEBlingLordMenuItemSpec)

describe(@"SEBlingLordMenuItem", ^{
  
  context(@"when initialized", ^{
    
    __block SEBlingLordMenuItem *menuItem = nil;
    
    beforeAll(^{
      menuItem = [[SEBlingLordMenuItem alloc] initWithFrame: CGRectMake(10.0f, 11.0f, 12.0f, 13.0f)
                                                      title: @"The title"
                                                      image: nil
                                                  removable: YES
                                            tapHandlerBlock: ^{}];
    });
    
    it(@"is not nil", ^{
      [[menuItem should] beNonNil];
    });
    
  });
  
});


SPEC_END


