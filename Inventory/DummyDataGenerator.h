//
//  DummyDataGenerator.h
//  Inventory
//
//  Created by Martin Nash on 3/1/15.
//  Copyright (c) 2015 Martin Nash. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface DummyDataGenerator : NSObject
- (instancetype)initWithMoc:(NSManagedObjectContext*)context;
- (void)clearAllData;
- (void)resetData;
@end
