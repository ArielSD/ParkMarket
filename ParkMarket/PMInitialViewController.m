//
//  PMInitialViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 5/24/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMInitialViewController.h"

@interface PMInitialViewController ()

@property (strong, nonatomic) UIButton *postButton;
@property (strong, nonatomic) UIButton *parkButton;

@end

@implementation PMInitialViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configureNavigationBarItems];
    [self configurePostButton];
    [self configureParkButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [CardIOUtilities preload];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Did receive memory warning");
}

#pragma mark - UI Layout

-(void)configurePostButton {
    UIImage *postButtonImage = [UIImage imageNamed:@"postButton"];
    UIImage *postButtonImageScaled = [UIImage imageWithCGImage:[postButtonImage CGImage]
                                                        scale:3
                                                 orientation:UIImageOrientationUp];
    
    self.postButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.postButton setImage:postButtonImageScaled
                     forState:UIControlStateNormal];
    
    [self.view addSubview:self.postButton];
  
    self.postButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.postButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.postButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor
                                             constant:-(self.view.frame.size.width / 4)].active = YES;
    
    [self.postButton addTarget:self
                        action:@selector(postButtonTapped)
              forControlEvents:UIControlEventTouchUpInside];
}

-(void)configureParkButton {
    UIImage *parkButtonImage = [UIImage imageNamed:@"parkButton"];
    UIImage *parkButtonImageScaled = [UIImage imageWithCGImage:[parkButtonImage CGImage]
                                                         scale:3
                                                   orientation:UIImageOrientationUp];
    
    self.parkButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.parkButton setImage:parkButtonImageScaled
                forState:UIControlStateNormal];
    
    [self.view addSubview:self.parkButton];
    
    self.parkButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.parkButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.parkButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor
                                             constant:(self.view.frame.size.width / 4)].active = YES;
    
    [self.parkButton addTarget:self
                        action:@selector(parkButtonTapped)
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureNavigationBarItems {
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(menuButtonTapped)];
    
    self.navigationItem.title = @"Park Or Post?";
    self.navigationItem.rightBarButtonItem = menuButton;
}

#pragma mark - Responder Methods

-(void)postButtonTapped {
    PMPostViewController *mapViewController = [PMPostViewController new];
    mapViewController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:mapViewController
                                         animated:YES];
}

-(void)parkButtonTapped {
    PMParkViewController *mapViewController = [PMParkViewController new];
    mapViewController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:mapViewController
                                         animated:YES];
}

- (void)menuButtonTapped {
    [self.delegate didTapMenuButton];
}

@end
