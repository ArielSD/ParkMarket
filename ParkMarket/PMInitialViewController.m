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
// For testing only
@property (strong, nonatomic) UIButton *scanButton;
// For testing only

@end

@implementation PMInitialViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"Navigation Controller In Initial ViewController: %@", self.navigationController);
    
    
//    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"Park or Post?"];
//    UIBarButtonItem *editButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
//                                                                                    target:self
//                                                                                    action:@selector(showMenu)];
//    navigationItem.rightBarButtonItem = editButtonItem;
//    
//    self.navigationController.navigationBar.items = @[navigationItem];
    
    [self configurePostButton];
    [self configureParkButton];
    // For testing only
    [self configureScanCardButton];
    // For testing only
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

// For Testing Only!
//
//
//
- (void)configureScanCardButton {
    self.scanButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.scanButton];
    
    [self.scanButton setTitle:@"Scan"
                     forState:UIControlStateNormal];
    
    self.scanButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scanButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.scanButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor
                                                 constant:-50.0].active = YES;
    [self.scanButton.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    
    [self.scanButton addTarget:self
                        action:@selector(showCardIOController)
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)showCardIOController {
    NSLog(@"Showing Card IO controller");
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
//
//
//
// For Testing Only!

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

@end
