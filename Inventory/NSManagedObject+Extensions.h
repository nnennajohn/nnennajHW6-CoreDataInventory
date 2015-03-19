//
//  Extensions.h
//  Inventory
//
//  Created by Martin Nash on 3/1/15.
//  Copyright (c) 2015 Martin Nash. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Extensions)

+(NSString*)entityName; // must override
+(instancetype)createInMoc:(NSManagedObjectContext*)moc;
+(NSArray*)allInContext:(NSManagedObjectContext*)moc;
+(NSFetchRequest*)basicFetchRequest;
+(void)deleteAllInMoc:(NSManagedObjectContext*)ctx;
@end
