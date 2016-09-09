//
//  PMMenu.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 9/8/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMMenuViewController.h"

@implementation PMMenuViewController

- (instancetype)initInViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.addCardButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:self.addCardButton];
        
        self.addCardButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.addCardButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
        [self.addCardButton.topAnchor constraintEqualToAnchor:self.view.topAnchor
                                                     constant:viewController.view.frame.size.height / 5.0].active = YES;
        
        [self.addCardButton setTitle:@"Add Card"
                            forState:UIControlStateNormal];
        
        [self.addCardButton addTarget:self
                                    action:@selector(showCardIOController)
                          forControlEvents:UIControlEventTouchUpInside];
    }
    return  self;
}

#pragma mark - Card IO Delegate Methods

- (void)showCardIOController {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    [self presentViewController:scanViewController
                       animated:YES
                     completion:nil];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)cardInfo
             inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"Info: %@", cardInfo);
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
