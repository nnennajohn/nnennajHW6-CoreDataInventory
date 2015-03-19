//
//  Item.m
//  Inventory
//
//  Created by Martin Nash on 3/1/15.
//  Copyright (c) 2015 Martin Nash. All rights reserved.
//

#import "Item.h"
#import "NSManagedObject+Extensions.h"


@implementation Item

@dynamic details;
@dynamic title;
@dynamic uuid;
@dynamic dateCreated;
@dynamic location;
@dynamic tags;
@dynamic images;


+(NSString*)entityName
{
    return @"Item";
}

@end
