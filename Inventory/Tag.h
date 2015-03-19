//
//  Tag.h
//  Inventory
//
//  Created by Martin Nash on 3/1/15.
//  Copyright (c) 2015 Martin Nash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) Location *location;

+(instancetype)findOrCreateWithTitle:(NSString*)title inMoc:(NSManagedObjectContext*)moc;

@end
