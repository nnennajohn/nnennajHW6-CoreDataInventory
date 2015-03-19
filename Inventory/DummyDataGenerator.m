//
//  DummyDataGenerator.m
//  Inventory
//
//  Created by Martin Nash on 3/1/15.
//  Copyright (c) 2015 Martin Nash. All rights reserved.
//

#import "DummyDataGenerator.h"
#import "NSManagedObject+Extensions.h"
#import "Item.h"

@interface DummyDataGenerator ()
@property (strong, nonatomic) NSManagedObjectContext *moc;
@end

@implementation DummyDataGenerator


- (instancetype)initWithMoc:(NSManagedObjectContext*)context
{
    self = [super init];
    if (self) {
        _moc = context;
    }
    return self;
}

- (void)clearAllData
{
    [Item deleteAllInMoc:self.moc];
}

- (void)resetData
{
    [self clearAllData];
    
    NSArray *titles = @[ @"Cheese", @"Bread", @"Chicken", @"Daffodils", @"Eclairs", @"Fudge", @"Gelato" ];
    for (NSString *singleTitle in titles) {
        Item *i = [Item createInMoc:self.moc];
        i.title = singleTitle;
    }
    [self.moc save:nil];
}



@end
