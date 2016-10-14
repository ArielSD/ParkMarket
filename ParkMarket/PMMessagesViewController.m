//
//  PMMessagesViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 9/27/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMMessagesViewController.h"

@interface PMMessagesViewController ()

@property (strong, nonatomic) UIBarButtonItem *doneButton;

@end

@implementation PMMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavigationItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Did receive memory warning");
}

#pragma mark - UI Layout

- (void)configureNavigationItems {
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneButtonTapped)];
    
    self.navigationItem.rightBarButtonItem = self.doneButton;

}

#pragma mark - Delegate Methods

- (void)doneButtonTapped {
    [self.delegate willDismissPMMessagesViewController:self];
}

@end
