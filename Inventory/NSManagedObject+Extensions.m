//
//  Extensions.m
//  Inventory
//
//  Created by Martin Nash on 3/1/15.
//  Copyright (c) 2015 Martin Nash. All rights reserved.
//

#import "NSManagedObject+Extensions.h"

@implementation NSManagedObject (Extensions)

+(NSString*)entityName
{
    @throw @"Overrie in subclass";
}

+(instancetype)createInMoc:(NSManagedObjectContext *)moc
{
    NSEntityDescription *ed = [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:moc];
    NSManagedObject *obj = [[self alloc] initWithEntity:ed insertIntoManagedObjectContext:moc];
    return obj;
}

+(NSFetchRequest *)basicFetchRequest
{
    return [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
}

+(NSArray *)allInContext:(NSManagedObjectContext *)moc
{
    return [moc executeFetchRequest:[self basicFetchRequest] error:nil];
}

+(void)deleteAllInMoc:(NSManagedObjectContext*)ctx
{
    NSArray *all = [ctx executeFetchRequest:[self basicFetchRequest] error:nil];
    for (NSManagedObject *obj in all) {
        [ctx deleteObject:obj];
    }
    [ctx save:nil];
}

@end
