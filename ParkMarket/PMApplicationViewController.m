//
//  PMApplicationViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 7/27/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMApplicationViewController.h"

@interface PMApplicationViewController ()

@property (strong, nonatomic) PMMenuViewController *menu;

// Constraints that can change
@property (strong, nonatomic) NSLayoutConstraint *menuRightAnchorConstraint;
@property (strong, nonatomic) NSLayoutConstraint *menuLeftAnchorConstraint;

@end

@implementation PMApplicationViewController

- (void)viewDidLoad {
    
    // Testing Only
//    [self testPayPalAPICall];
    // Testing Only
    
    [super viewDidLoad];
    
    if ([FIRAuth auth].currentUser) {
        [self showInitialViewController];
    }
    else {
        [self showLoginViewController];
    }
    
    [self configureMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Did receive memory warning");
}

#pragma mark - UI Layout

- (void)configureMenu {
    self.menu = [PMMenuViewController new];
    self.menu.delegate = self;
    [self.view addSubview:self.menu.view];
    
    self.menu.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.menu.view.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.menu.view.heightAnchor constraintEqualToAnchor:self.view.heightAnchor].active = YES;
    [self.menu.view.widthAnchor constraintEqualToAnchor:self.view.widthAnchor
                                   multiplier:1.0 / 3.0].active = YES;
    
    self.menuRightAnchorConstraint = [self.menu.view.rightAnchor constraintEqualToAnchor:self.view.leftAnchor];
    self.menuLeftAnchorConstraint = [self.menu.view.leftAnchor constraintEqualToAnchor:self.view.leftAnchor];
    self.menuRightAnchorConstraint.active = YES;
}

#pragma mark- Container View Methods

- (void)showLoginViewController {
    if (self.childViewControllers.count == 0) {
        PMLoginViewController *loginViewController = [PMLoginViewController new];
        loginViewController.delegate = self;
        [self addChildViewController:loginViewController];
        loginViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:loginViewController.view];
        [loginViewController didMoveToParentViewController:self];
    }
    
    else {
        PMLoginViewController *loginViewController = [PMLoginViewController new];
        loginViewController.delegate = self;
        
        [self cycleFromOldViewController:self.childViewControllers.lastObject
                     toNewViewController:loginViewController];
    }
}

- (void)showInitialViewController {
    if (self.childViewControllers.count == 0) {
        PMInitialViewController *initialViewController = [PMInitialViewController new];
        initialViewController.delegate = self;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:initialViewController];
        [self addChildViewController:navigationController];
        navigationController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:navigationController.view];
        [navigationController didMoveToParentViewController:self];
    }
    
    else {
        PMInitialViewController *initialViewController = [PMInitialViewController new];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:initialViewController];
        initialViewController.delegate = self;
        
        [self cycleFromOldViewController:self.childViewControllers.lastObject
                     toNewViewController:navigationController];
    }
}

- (void)cycleFromOldViewController:(UIViewController *)oldViewController
               toNewViewController:(UIViewController *)newViewController {
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    
    newViewController.view.frame = CGRectMake(0, self.view.frame.size.height, -self.view.frame.size.width, -self.view.frame.size.height);
    CGRect endFrameForOldViewController = CGRectMake(0, self.view.frame.size.height, -self.view.frame.size.width, -self.view.frame.size.height);
    
    [self transitionFromViewController:oldViewController
                      toViewController:newViewController
                              duration:0.25
                               options:0
                            animations:^{
                                newViewController.view.frame = oldViewController.view.frame;
                                oldViewController.view.frame = endFrameForOldViewController;
                            }
                            completion:^(BOOL finished) {
                                [oldViewController removeFromParentViewController];
                                [newViewController didMoveToParentViewController:self];
                            }];
}

#pragma mark - PMLoginViewControllerDelegate Methods

- (void)didLogInUser {
    [self showInitialViewController];
}

#pragma mark - MenuButtonDelegate Methods

- (void)didTapMenuButton {
    
    if (self.view.subviews.lastObject != self.menu.view) {
        [self.view bringSubviewToFront:self.menu.view];
    }

    if (self.menuRightAnchorConstraint.active == YES) {
        [UIView animateWithDuration:0.4
                         animations:^{
                             self.view.subviews[2].alpha = 0.25;
                             self.menuRightAnchorConstraint.active = NO;
                             self.menuLeftAnchorConstraint.active = YES;
                             [self.view layoutIfNeeded];
                         }];
        
    }
    else {
        [UIView animateWithDuration:0.4
                         animations:^{
                             self.view.subviews[2].alpha = 1.0;
                             self.menuLeftAnchorConstraint.active = NO;
                             self.menuRightAnchorConstraint.active = YES;
                             [self.view layoutIfNeeded];
                         }];
    }
}

#pragma mark - PMMenuViewControllerDelegate Methods

- (void)didTapAddCardButton {
        CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
        [self presentViewController:scanViewController
                           animated:YES
                         completion:nil];
}

- (void)didTapLogoutButton {
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (!error) {
        self.menuLeftAnchorConstraint.active = NO;
        self.menuRightAnchorConstraint.active = YES;
        [self showLoginViewController];
    }
}

#pragma mark - CardIOPaymentViewControllerDelegate Methods

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

#pragma mark - Testing

// Testing Only
- (void)testPayPalAPICall {
    
    NSLog(@"Running Test PayPal API Call");
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFJSONRequestSerializer new];
    NSString *payPalURLString = @"https://svcs.sandbox.paypal.com/AdaptivePayments/Pay";
    
    NSDictionary *payloadDictionary = @{
                                        @"actionType" : @"PAY",
                                        @"currencyCode" : @"USD",
                                        @"receiverList" : @{
                                                @"receiver" : @[@{@"amount":@"1.00",
                                                                            @"email" : @"rec1_1312486368_biz@gmail.com"}]},
                                        @"returnUrl" : @"http://www.example.com/success.html",
                                        @"cancelUrl" : @"http://www.example.com/failure.html",
                                        @"requestEnvelope" : @{
                                                @"errorLanguage" : @"en_US",
                                                @"detailLevel" : @"ReturnAll"
                                            }
                                        };
    
    [sessionManager.requestSerializer setValue:@"caller_1312486258_biz_api1.gmail.com" forHTTPHeaderField:@"X-PAYPAL-SECURITY-USERID"];
    [sessionManager.requestSerializer setValue:@"1312486294" forHTTPHeaderField:@"X-PAYPAL-SECURITY-PASSWORD"];
    [sessionManager.requestSerializer setValue:@"AbtI7HV1xB428VygBUcIhARzxch4AL65.T18CTeylixNNxDZUu0iO87e" forHTTPHeaderField:@"X-PAYPAL-SECURITY-SIGNATURE"];
    [sessionManager.requestSerializer setValue:@"APP-80W284485P519543T" forHTTPHeaderField:@"X-PAYPAL-APPLICATION-ID"];
    [sessionManager.requestSerializer setValue:@"JSON" forHTTPHeaderField:@"X-PAYPAL-REQUEST-DATA-FORMAT"];
    [sessionManager.requestSerializer setValue:@"JSON" forHTTPHeaderField:@"X-PAYPAL-RESPONSE-DATA-FORMAT"];
    
    [sessionManager POST:payPalURLString
              parameters:payloadDictionary
                progress:nil
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     NSLog(@"Success! Response Object: %@", responseObject);
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     NSLog(@"%@", error);
                 }];
}

@end
