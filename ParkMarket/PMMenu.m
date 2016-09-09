//
//  PMMenu.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 9/8/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMMenu.h"

@implementation PMMenu

- (instancetype)initInViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.addCardButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.addCardButton];
        
        self.addCardButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.addCardButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [self.addCardButton.topAnchor constraintEqualToAnchor:self.topAnchor
                                                     constant:viewController.view.frame.size.height / 5.0].active = YES;
        
        [self.addCardButton setTitle:@"Add Card"
                            forState:UIControlStateNormal];
        
//        [self.addCardButton addTarget:self
//                               action:@selector(testMethod)
//                     forControlEvents:UIControlEventTouchUpInside];
    }
    return  self;
}

@end
