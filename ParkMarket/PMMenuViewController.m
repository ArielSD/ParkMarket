//
//  PMMenu.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 9/8/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMMenuViewController.h"

@interface PMMenuViewController ()

@property (strong, nonatomic) UIButton *addCardButton;
@property (strong, nonatomic) UIButton *mySpotsButton;
@property (strong, nonatomic) UIButton *logoutButton;

@end

@implementation PMMenuViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureAddCardButton];
        [self configureMySpotsButton];
        [self configureLogoutButton];
    }
    return  self;
}

#pragma mark - UI Layout

- (void)configureAddCardButton {
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.addCardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.addCardButton];
    
    self.addCardButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.addCardButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.addCardButton.topAnchor constraintEqualToAnchor:self.view.topAnchor
                                                 constant:self.view.frame.size.height / 10.0].active = YES;
    
    [self.addCardButton setTitle:@"Add Card"
                        forState:UIControlStateNormal];
    
    [self.addCardButton addTarget:self
                           action:@selector(addCardButtonTapped)
                 forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureMySpotsButton {
    self.mySpotsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.mySpotsButton];
    
    self.mySpotsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mySpotsButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.mySpotsButton.topAnchor constraintEqualToAnchor:self.addCardButton.bottomAnchor
                                                 constant:self.view.frame.size.height / 20.0].active = YES;
    
    [self.mySpotsButton setTitle:@"My Spots"
                        forState:UIControlStateNormal];
    
    [self.mySpotsButton addTarget:self
                           action:@selector(mySpotsButtonTapped)
                 forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureLogoutButton {
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.logoutButton];
    
    self.logoutButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.logoutButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.logoutButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor
                                                constant:-self.view.frame.size.height / 10.0].active = YES;
    
    [self.logoutButton setTitle:@"Log Out"
                       forState:UIControlStateNormal];
    
    [self.logoutButton addTarget:self
                          action:@selector(logoutButtonTapped)
                forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Delegate Methods

- (void)addCardButtonTapped {
    [self.delegate didTapAddCardButton];
}

- (void)mySpotsButtonTapped {
    [self.delegate didTapMySpotsButton];
}

- (void)logoutButtonTapped {
    [self.delegate didTapLogoutButton];
}

@end
