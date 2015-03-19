//
//  Item.h
//  Inventory
//
//  Created by Martin Nash on 3/1/15.
//  Copyright (c) 2015 Martin Nash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tag, Location;
@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) NSSet *images;

@end
