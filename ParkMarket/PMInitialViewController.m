//
//  PMInitialViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 5/24/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMInitialViewController.h"

@interface PMInitialViewController ()

@end

@implementation PMInitialViewController

-(void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [CardIOUtilities preload];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Did receive memory warning");
}

#pragma mark - Responder Methods

-(void)postButtonTapped {
    PMPostViewController *postViewController = [PMPostViewController new];
    
    postViewController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:postViewController
                                         animated:YES];
}

-(void)parkButtonTapped {
    PMApplicationViewController *applicationViewController = (PMApplicationViewController *)self.parentViewController.parentViewController;
    
    PMParkViewController *parkViewController = [PMParkViewController new];
    parkViewController.delegate = applicationViewController;

    parkViewController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:parkViewController
                                         animated:YES];
}

- (void)menuButtonTapped {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuButtonWasTapped"
                                                        object:self];
}

@end
