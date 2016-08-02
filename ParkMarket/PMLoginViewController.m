//
//  PMLoginViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 7/25/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMLoginViewController.h"

@interface PMLoginViewController ()

@property (strong, nonatomic) UILabel *welcomeLabel;
@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *signUpButton;

@end

@implementation PMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureWelcomeLabel];
    [self configureEmailTextField];
    [self configurePasswordTextField];
    [self configureLoginButton];
    [self configureSignUpButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Did receive memory warning");
}

#pragma mark - UI Layout

- (void)configureWelcomeLabel {
    self.welcomeLabel = [UILabel new];
    [self.view addSubview:self.welcomeLabel];
    
    self.welcomeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.welcomeLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.welcomeLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor
                                                constant:self.view.frame.size.height / 3.0].active = YES;
    [self.welcomeLabel.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    
    self.welcomeLabel.textAlignment = NSTextAlignmentCenter;
    self.welcomeLabel.text = @"Welcome!";
}

- (void)configureEmailTextField {
    self.emailTextField = [UITextField new];
    [self.view addSubview:self.emailTextField];
    
    self.emailTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.emailTextField.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.emailTextField.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.emailTextField.widthAnchor constraintEqualToAnchor:self.view.widthAnchor
                                                  multiplier:0.5].active = YES;
    
    self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailTextField.placeholder = @"Email";
}

- (void)configurePasswordTextField {
    self.passwordTextField = [UITextField new];
    [self.view addSubview:self.passwordTextField];
    
    self.passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.passwordTextField.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.passwordTextField.topAnchor constraintEqualToAnchor:self.emailTextField.bottomAnchor
                                                     constant:self.view.frame.size.height / 50.0].active = YES;
    [self.passwordTextField.widthAnchor constraintEqualToAnchor:self.view.widthAnchor
                                                  multiplier:0.5].active = YES;
    
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.placeholder = @"Password";
}

- (void)configureLoginButton {
    self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.loginButton];
    
    self.loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.loginButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.loginButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor
                                                  constant:-self.view.frame.size.height / 4].active = YES;
    
    [self.loginButton setTitle:@"Log In"
                      forState:UIControlStateNormal];
}

- (void)configureSignUpButton {
    self.signUpButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.signUpButton];
    
    self.signUpButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.signUpButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.signUpButton.topAnchor constraintEqualToAnchor:self.loginButton.bottomAnchor
                                                constant:self.view.frame.size.height / 25].active = YES;
    
    [self.signUpButton setTitle:@"Sign Up"
                       forState:UIControlStateNormal];
}

@end
