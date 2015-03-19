//
//  CreateItemViewController.h
//  Inventory
//
//  Created by Martin Nash on 3/1/15.
//  Copyright (c) 2015 Martin Nash. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class SingleStringInputViewController;

@interface SingleStringInputViewController : NSViewController
@property (copy) void (^doneBlock)();
-(NSString*)enteredString;
@end
