//
//  PMApplicationViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 7/27/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMApplicationViewController.h"

@interface PMApplicationViewController ()

@end

@implementation PMApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Comment out to keep a user signed in
//    NSError *error;
//    [[FIRAuth auth] signOut:&error];
//    if (!error) {
//        NSLog(@"A user has been signed out");
//    }
    
    if ([FIRAuth auth].currentUser) {
        [self showInitialViewController];
    }
    else {
        [self showLoginViewController];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Did receive memory warning");
}

#pragma - Helper Methods

- (void)showLoginViewController {
    PMLoginViewController *loginViewController = [PMLoginViewController new];
    loginViewController.delegate = self;
    [self addChildViewController:loginViewController];
    loginViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:loginViewController.view];
    [loginViewController didMoveToParentViewController:self];
}

- (void)showInitialViewController {
    PMInitialViewController *initialViewController = [PMInitialViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:initialViewController];
    [self addChildViewController:navigationController];
    navigationController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:navigationController.view];
    [navigationController didMoveToParentViewController:self];
}

#pragma mark - Delegate Methods

- (void)didLogInUser {
    [self showInitialViewController];
}

@end
