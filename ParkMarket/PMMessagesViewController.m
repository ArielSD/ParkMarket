//
//  PMMessagesViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 9/27/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMMessagesViewController.h"

@interface PMMessagesViewController ()

// Testing
@property(strong, nonatomic) UIButton *dismissButton;
// Testing

@end

@implementation PMMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Testing
    [self configureDismissButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Did receive memory warning");
}

// Testing
- (void)configureDismissButton {
    self.dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.dismissButton];
    
    self.dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dismissButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.dismissButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    
    [self.dismissButton setTitle:@"Dismiss"
                        forState:UIControlStateNormal];
    
    [self.dismissButton addTarget:self
                           action:@selector(dismissButtonTapped)
                 forControlEvents:UIControlEventTouchUpInside];
}

- (void)dismissButtonTapped {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
