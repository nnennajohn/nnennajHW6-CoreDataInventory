//
//  CreateItemViewController.m
//  Inventory
//
//  Created by Martin Nash on 3/1/15.
//  Copyright (c) 2015 Martin Nash. All rights reserved.
//

#import "SingleStringInputViewController.h"

@interface SingleStringInputViewController () <NSTextFieldDelegate>
@property (weak) IBOutlet NSTextField *titleTextField;
@property (strong) id token;
@end

@implementation SingleStringInputViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.titleTextField.delegate = self;
}

-(void)viewDidAppear
{
    [super viewDidAppear];
    __weak typeof(self) weakself = self;
    self.token = [[NSNotificationCenter defaultCenter] addObserverForName:NSControlTextDidEndEditingNotification object:self.titleTextField queue:nil usingBlock:^(NSNotification *note) {
        weakself.doneBlock();
    }];
}

-(void)viewWillDisappear
{
    [super viewDidDisappear];
    [[NSNotificationCenter defaultCenter] removeObserver:_token];
}

-(NSString *)enteredString
{
    return self.titleTextField.stringValue;
}



// suppress dictionary completion
-(NSArray *)control:(NSControl *)control textView:(NSTextView *)textView completions:(NSArray *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index
{
    return nil;
}

@end
