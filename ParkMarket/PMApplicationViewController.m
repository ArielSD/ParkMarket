//
//  PMApplicationViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 7/27/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMApplicationViewController.h"

@interface PMApplicationViewController ()

@property (strong, nonatomic) UIView *menu;

// Constraints that can change
@property (strong, nonatomic) NSLayoutConstraint *menuRightAnchorConstraint;

@end

@implementation PMApplicationViewController

- (void)viewDidLoad {
    NSLog(@"Application View Controller Did Load");
    
    // Testing Only
//    [self testPayPalAPICall];
    // Testing Only
    
    [super viewDidLoad];
    
    // Comment out to keep a user signed in
//    NSError *error;
//    [[FIRAuth auth] signOut:&error];
//    if (!error) {
//        NSLog(@"A user has been signed out");
//    }
    
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
    
    NSLog(@"Configure Menu Called");
    
    self.menu = [UIView new];
    [self.view addSubview:self.menu];
    
    self.menu.translatesAutoresizingMaskIntoConstraints = NO;
    [self.menu.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    self.menuRightAnchorConstraint = [self.menu.rightAnchor constraintEqualToAnchor:self.view.leftAnchor];
    self.menuRightAnchorConstraint.active = YES;
    [self.menu.heightAnchor constraintEqualToAnchor:self.view.heightAnchor].active = YES;
    [self.menu.widthAnchor constraintEqualToAnchor:self.view.widthAnchor
                                        multiplier:1.0 / 3.0].active = YES;
    
    self.menu.backgroundColor = [UIColor blueColor];
    
    
//    self.menu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width / 3.0), self.view.frame.size.height)];
//    [self.view addSubview:self.menu];
//    self.menu.backgroundColor = [UIColor blueColor];
}

#pragma mark- Container View Methods

- (void)showLoginViewController {
    PMLoginViewController *loginViewController = [PMLoginViewController new];
    loginViewController.delegate = self;
    [self addChildViewController:loginViewController];
    loginViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:loginViewController.view];
    [loginViewController didMoveToParentViewController:self];
}

- (void)showInitialViewController {
    PMInitialViewController *initialViewController = [PMInitialViewController new];
    initialViewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:initialViewController];
    [self addChildViewController:navigationController];
    navigationController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:navigationController.view];
    [navigationController didMoveToParentViewController:self];
}

#pragma mark - Delegate Methods

- (void)didLogInUser {
    [self showInitialViewController];
}

- (void)didTapMenuButton {
    NSLog(@"Did Tap Menu Button In Application View Controller");
    
    [UIView animateWithDuration:0.6
                     animations:^{
                         self.menuRightAnchorConstraint.active = NO;
                         [self.menu.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
                         [self.view layoutIfNeeded];
                     }];
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
