//
//  Tag.m
//  Inventory
//
//  Created by Martin Nash on 3/1/15.
//  Copyright (c) 2015 Martin Nash. All rights reserved.
//

#import "Tag.h"
#import "Item.h"
#import "Location.h"
#import "NSManagedObject+Extensions.h"


@implementation Tag

@dynamic title;
@dynamic items;
@dynamic location;


+(NSString *)entityName
{
    return @"Tag";
}

+(instancetype)findOrCreateWithTitle:(NSString*)title inMoc:(NSManagedObjectContext*)moc
{
    NSFetchRequest *fr = [self basicFetchRequest];
    fr.predicate = [NSPredicate predicateWithFormat:@"title == %@", title];
    if ([moc countForFetchRequest:fr error:nil] == 1) {
        return [[moc executeFetchRequest:fr error:nil] firstObject];
    }
    
    Tag *t = [self createInMoc:moc];
    t.title = title;
    return t;
}

@end
