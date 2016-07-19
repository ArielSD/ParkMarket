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
    
    [self configurePostButton];
    [self configureParkButton];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"Did receive memory warning");
}

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

-(void)postButtonTapped {
    PMPostViewController *mapViewController = [PMPostViewController new];
    [self.navigationController pushViewController:mapViewController
                                         animated:YES];
}

-(void)parkButtonTapped {
    PMParkViewController *mapViewController = [PMParkViewController new];
    [self.navigationController pushViewController:mapViewController
                                         animated:YES];
}

@end
