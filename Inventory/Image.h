//
//  Image.h
//  Inventory
//
//  Created by Martin Nash on 3/12/15.
//  Copyright (c) 2015 Martin Nash. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Item;

@interface Image : NSManagedObject
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) Item *item;
@end
