//
//  ItemEditViewController.m
//  Inventory
//
//  Created by Martin Nash on 3/2/15.
//  Copyright (c) 2015 Martin Nash. All rights reserved.
//

#import "ItemEditViewController.h"
#import "NSManagedObject+Extensions.h"
#import "Item.h"
#import "Tag.h"

@interface ItemEditViewController () <NSTextFieldDelegate>
@property (weak) IBOutlet NSTextField *titleView;
@property (weak) IBOutlet NSTextField *tagsView;
@end

@implementation ItemEditViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
    
    self.tagsView.delegate = self;
    self.titleView.delegate = self;
}

- (IBAction)clickedSave:(id)sender
{
    [self.presentingViewController dismissViewController:self];
}

- (IBAction)clickedCancel:(id)sender
{
    [self.presentingViewController dismissViewController:self];
}

-(void)updateUI
{
    self.titleView.stringValue = self.item.title;
    self.tagsView.stringValue = [[self.item.tags.allObjects valueForKeyPath:@"title"] componentsJoinedByString:@", "];
}

-(void)processInput
{
    // PROCESS TITLE
    self.item.title = self.titleView.stringValue;
    
    // PROCESS TAGS
    NSArray *unprocessedTokens = [self.tagsView.stringValue componentsSeparatedByString:@","];
    NSMutableSet *mutableTags = [self.item mutableSetValueForKeyPath:@"tags"];
    [mutableTags removeAllObjects];
    for (NSString *unprocessed in unprocessedTokens) {
        NSString *trimmed = [unprocessed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (trimmed.length > 0) {
            Tag *t = [Tag findOrCreateWithTitle:trimmed inMoc:self.item.managedObjectContext];
            [mutableTags addObject:t];
        }
    }
    
    [self.item.managedObjectContext save:nil];
}

-(BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
{
    if (commandSelector == @selector(insertNewline:)) {
        [self processInput];
        [self.presentingViewController dismissViewController:self];
        return YES;
    }
    
    return NO;
}

@end
