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
    
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (!error) {
        NSLog(@"A user has been signed out");
    }
    
    if ([FIRAuth auth].currentUser) {
        NSLog(@"There is a current user: %@", [FIRAuth auth].currentUser.uid);
        
        PMInitialViewController *initialViewController = [PMInitialViewController new];
        [self addChildViewController:initialViewController];
        initialViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:initialViewController.view];
        [initialViewController didMoveToParentViewController:self];
    }
    else {
        NSLog(@"No User");
        
        PMLoginViewController *loginViewController = [PMLoginViewController new];
        [self addChildViewController:loginViewController];
        loginViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:loginViewController.view];
        [loginViewController didMoveToParentViewController:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Did receive memory warning");
}

@end
