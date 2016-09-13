//
//  PMMenu.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 9/8/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMMenuViewController.h"

@implementation PMMenuViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.addCardButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:self.addCardButton];
        
        self.addCardButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.addCardButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
        [self.addCardButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
        
        [self.addCardButton setTitle:@"Add Card"
                            forState:UIControlStateNormal];
        
        [self.addCardButton addTarget:self
                                    action:@selector(addCardButtonTapped)
                          forControlEvents:UIControlEventTouchUpInside];
    }
    return  self;
}

#pragma mark - Card IO Delegate Methods

- (void)addCardButtonTapped {
    [self.delegate didTapAddCardButton];
}

@end
