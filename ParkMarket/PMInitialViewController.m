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
@property (strong, nonatomic) UILabel *postLabel;
@property (strong, nonatomic) UILabel *parkLabel;

@end

@implementation PMInitialViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configureNavigationBarItems];
    [self configurePostButton];
    [self configureParkButton];
    [self configurePostLabel];
    [self configureParkLabel];
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
                                             constant:-(self.view.frame.size.width / 4.0)].active = YES;
    
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
                                             constant:(self.view.frame.size.width / 4.0)].active = YES;
    
    [self.parkButton addTarget:self
                        action:@selector(parkButtonTapped)
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)configurePostLabel {
    self.postLabel = [UILabel new];
    [self.view addSubview:self.postLabel];
    
    self.postLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.postLabel.topAnchor constraintEqualToAnchor:self.postButton.bottomAnchor
                                             constant:self.view.frame.size.height / 20.0].active = YES;
    [self.postLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor
                                                 constant:-(self.view.frame.size.width / 4.0)].active = YES;
    
    self.postLabel.textAlignment = NSTextAlignmentCenter;
    self.postLabel.text = @"Post";
}

- (void)configureParkLabel {
    self.parkLabel = [UILabel new];
    [self.view addSubview:self.parkLabel];
    
    self.parkLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.parkLabel.topAnchor constraintEqualToAnchor:self.parkButton.bottomAnchor
                                             constant:self.view.frame.size.height / 20.0].active = YES;
    [self.parkLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor
                                                 constant:(self.view.frame.size.width / 4.0)].active = YES;
    
    self.parkLabel.textAlignment = NSTextAlignmentCenter;
    self.parkLabel.text = @"Park";
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
