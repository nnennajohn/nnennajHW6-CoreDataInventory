//
//  AllItemsViewController.m
//  Inventory
//
//  Created by Martin Nash on 3/1/15.
//  Copyright (c) 2015 Martin Nash. All rights reserved.
//

#import "AllItemsViewController.h"
#import "ConfigurableCoreDataStack.h"
#import "CoreDataStackConfiguration.h"
#import "NSManagedObject+Extensions.h"
#import "Item.h"
#import "Tag.h"
#import "DummyDataGenerator.h"
#import "SingleStringInputViewController.h"
#import "CoreDataChangeObserver.h"
#import "ItemEditViewController.h"

@import CoreData;
@import QuartzCore;

@interface AllItemsViewController () <NSTableViewDataSource, NSTableViewDelegate>
@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) NSArray *items;
@property (weak, nonatomic) IBOutlet NSTableView *tableView;
@property (strong, nonatomic) CoreDataChangeObserver *observer;
@end




@implementation AllItemsViewController

-(CoreDataStackConfiguration*)mainConfig
{
    CoreDataStackConfiguration *config =
    [CoreDataStackConfiguration configurationWithStoreType:NSSQLiteStoreType
                modelName:@"Inventory"
                appIdentifier:@"my.throwaway.app.identifier"
                dataFileNameWithExtension:@"Data.sqlite"
                searchPathDirectory:NSApplicationSupportDirectory];
    
    return config;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.wantsLayer = YES;
    
    ConfigurableCoreDataStack *stack = [ConfigurableCoreDataStack stackWithConfiguration:[self mainConfig]];
    self.moc = [stack managedObjectContext];
    
    
    NSFetchRequest *fr = [Item basicFetchRequest];
    fr.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] ];

    __weak typeof(self) weakself = self;
    
    // setup observer
    self.observer = [[CoreDataChangeObserver alloc] initWithFetchRequest:fr andMoc:self.moc];
    self.observer.beginChangesHandler = ^{
        [weakself.tableView beginUpdates];
    };
    self.observer.endChangesHandler = ^{
        [weakself.tableView endUpdates];
    };
    self.observer.insertionHandler = ^(id obj, NSUInteger idx) {
        [weakself.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:idx] withAnimation:NSTableViewAnimationEffectFade];
    };
    self.observer.multipleDeletionHandler = ^(id objs, NSIndexSet* indexes){
        [weakself.tableView removeRowsAtIndexes:indexes withAnimation:NSTableViewAnimationEffectFade];
    };
    self.observer.movementHandler  = ^(id obj, NSUInteger oldIndex, NSUInteger newIndex) {

        NSIndexSet *old = [NSIndexSet indexSetWithIndex:oldIndex];
        NSIndexSet *zero = [NSIndexSet indexSetWithIndex:0];
        [weakself.tableView reloadDataForRowIndexes:old columnIndexes:zero];

        if (oldIndex != newIndex) {
            [weakself.tableView moveRowAtIndex:oldIndex toIndex:newIndex];
        }
        
        // FADE BACKGROUND COLOR
        [[NSAnimationContext currentContext] setCompletionHandler:^{
            [weakself.tableView enumerateAvailableRowViewsUsingBlock:^(NSTableRowView *rowView, NSInteger row) {
                CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
                anim.fromValue = (id)rowView.layer.backgroundColor;
                anim.toValue = (id)rowView.backgroundColor.CGColor;
                [rowView.layer addAnimation:anim forKey:@"backgroundColor"];
                rowView.layer.backgroundColor = rowView.backgroundColor.CGColor;
            }];
        }];
        
    };
    [self.observer performFetch];
    
    // setup tableview
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.intercellSpacing = CGSizeZero;
    self.tableView.gridStyleMask = NSTableViewDashedHorizontalGridLineMask;
    self.tableView.target = self;
    self.tableView.doubleAction = @selector(doubleClicked:);
}

-(void)addItemWithTitle:(NSString*)title
{
    if (title == nil) {
        return;
    }
    
    if (title.length == 0) {
        return;
    }
    
    Item *newItem = [Item createInMoc:self.moc];
    newItem.title = title;
    [newItem.managedObjectContext save: nil];
}




#pragma mark - Table View

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.observer.fetchedObjects.count;
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *tcv = [tableView makeViewWithIdentifier:@"BasicCell" owner:nil];
    tcv.textField.stringValue =  [(Item*)self.observer.fetchedObjects[row] title];
    return tcv;
}

-(NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
{
    return [[NSTableRowView alloc] initWithFrame:CGRectZero];
}


#pragma mark - Event Handling

-(IBAction)clickedNewItem:(id)sender
{
    SingleStringInputViewController *vc = [self.storyboard instantiateControllerWithIdentifier:@"SingleStringInputVC"];
    __weak typeof(vc) weakvc = vc;
    vc.doneBlock = ^{
        [self addItemWithTitle:weakvc.enteredString];
        [self dismissViewController:weakvc];
    };
    
    [self presentViewController:vc
        asPopoverRelativeToRect:[sender bounds]
                         ofView:sender
                  preferredEdge:CGRectMinXEdge
                       behavior:NSPopoverBehaviorSemitransient];
}

-(void)keyDown:(NSEvent *)theEvent
{
    [self interpretKeyEvents:@[theEvent]];
}

-(void)deleteBackward:(id)sender
{
    if ([[self.tableView selectedRowIndexes] count] >= 1) {
        NSArray *selectedItems = [self.observer.fetchedObjects objectsAtIndexes:self.tableView.selectedRowIndexes];
        for (NSManagedObject *obj in selectedItems) {
            [obj.managedObjectContext deleteObject:obj];
        }
        [self.observer.moc save:nil];
    }
}

-(void)doubleClicked:(id)sender
{
    // select only clicked row
    NSIndexSet *clickedIndex = [NSIndexSet indexSetWithIndex:self.tableView.clickedRow];
    [self.tableView selectRowIndexes:clickedIndex byExtendingSelection:NO];
    
    ItemEditViewController *vc = [self.storyboard instantiateControllerWithIdentifier:@"ItemEditVC"];
    vc.item = self.observer.fetchedObjects[self.tableView.clickedRow];
    [self presentViewControllerAsSheet:vc];
}



@end
