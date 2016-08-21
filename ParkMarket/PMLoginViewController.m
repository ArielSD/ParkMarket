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
@property (strong, nonatomic) UITextField *firstNameTextField;
@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UILabel *emailAlreadyTakenLabel;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *confirmPasswordTextField;
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *signUpButton;

// Constraints that can change
@property (strong, nonatomic) NSLayoutConstraint *passwordTextFieldTopConstraint;

@end

@implementation PMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureWelcomeLabel];
    [self configureFirstNameTextField];
    [self configureEmailTextField];
    [self configurePasswordTextField];
    [self configureConfirmPasswordTextField];
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
                                                constant:self.view.frame.size.height / 15.0].active = YES;
    [self.welcomeLabel.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    
    self.welcomeLabel.textAlignment = NSTextAlignmentCenter;
    self.welcomeLabel.text = @"Welcome!";
}

- (void)configureFirstNameTextField {
    self.firstNameTextField = [UITextField new];
    [self.view addSubview:self.firstNameTextField];
    
    self.firstNameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.firstNameTextField.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.firstNameTextField.topAnchor constraintEqualToAnchor:self.welcomeLabel.bottomAnchor
                                                      constant:self.view.frame.size.height / 33].active = YES;
    [self.firstNameTextField.widthAnchor constraintEqualToAnchor:self.view.widthAnchor
                                                      multiplier:0.5].active = YES;
    
    self.firstNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.firstNameTextField.placeholder = @"First Name";
}

- (void)configureEmailTextField {
    self.emailTextField = [UITextField new];
    [self.view addSubview:self.emailTextField];
    
    self.emailTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.emailTextField.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.emailTextField.topAnchor constraintEqualToAnchor:self.firstNameTextField.bottomAnchor
                                                  constant:self.view.frame.size.height / 50.0].active = YES;
    [self.emailTextField.widthAnchor constraintEqualToAnchor:self.view.widthAnchor
                                                  multiplier:0.5].active = YES;
    
    self.emailTextField.adjustsFontSizeToFitWidth = YES;
    self.emailTextField.minimumFontSize = 6.0;
    
    self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailTextField.placeholder = @"Email";
}

- (void)configurePasswordTextField {
    self.passwordTextField = [UITextField new];
    [self.view addSubview:self.passwordTextField];
    
    self.passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.passwordTextField.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    self.passwordTextFieldTopConstraint = [self.passwordTextField.topAnchor constraintEqualToAnchor:self.emailTextField.bottomAnchor
                                                                                           constant:self.view.frame.size.height / 50.0];
    self.passwordTextFieldTopConstraint.active = YES;
    [self.passwordTextField.widthAnchor constraintEqualToAnchor:self.view.widthAnchor
                                                  multiplier:0.5].active = YES;
    
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.placeholder = @"Password";
}

- (void)configureConfirmPasswordTextField {
    self.confirmPasswordTextField = [UITextField new];
    [self.view addSubview:self.confirmPasswordTextField];
    
    self.confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.confirmPasswordTextField.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.confirmPasswordTextField.topAnchor constraintEqualToAnchor:self.passwordTextField.bottomAnchor
                                                            constant:self.view.frame.size.height / 50.0].active = YES;
    [self.confirmPasswordTextField.widthAnchor constraintEqualToAnchor:self.view.widthAnchor
                                                            multiplier:0.5].active = YES;
    
    self.confirmPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.confirmPasswordTextField.secureTextEntry = YES;
    self.confirmPasswordTextField.placeholder = @"Confirm Password";
}

- (void)configureLoginButton {
    self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.loginButton];
    
    self.loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.loginButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.loginButton.bottomAnchor constraintEqualToAnchor:self.confirmPasswordTextField.bottomAnchor
                                                  constant:self.view.frame.size.height / 15].active = YES;
    
    [self.loginButton setTitle:@"Log In"
                      forState:UIControlStateNormal];
}

- (void)configureSignUpButton {
    self.signUpButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.signUpButton];
    
    self.signUpButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.signUpButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.signUpButton.topAnchor constraintEqualToAnchor:self.loginButton.bottomAnchor
                                                constant:self.view.frame.size.height / 50].active = YES;
    
    [self.signUpButton setTitle:@"Sign Up"
                       forState:UIControlStateNormal];
    
    [self.signUpButton addTarget:self
                          action:@selector(signUpButtonTapped)
                forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureEmailAlreadyTakenLabel {
    
    NSLog(@"Calling configure email already taken");
    
    self.emailAlreadyTakenLabel = [UILabel new];
    [self.view addSubview:self.emailAlreadyTakenLabel];
    
    self.emailAlreadyTakenLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.emailAlreadyTakenLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.emailAlreadyTakenLabel.topAnchor constraintEqualToAnchor:self.emailTextField.bottomAnchor
                                                          constant:self.view.frame.size.height / 50.0].active = YES;
    [self.emailAlreadyTakenLabel.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;

    self.passwordTextFieldTopConstraint.active = NO;
    [self.passwordTextField.topAnchor constraintEqualToAnchor:self.emailAlreadyTakenLabel.bottomAnchor
                                                     constant:self.view.frame.size.height / 50.0].active = YES;
    
    self.emailAlreadyTakenLabel.text = @"Email is already taken";
    self.emailAlreadyTakenLabel.textAlignment = NSTextAlignmentCenter;
    self.emailAlreadyTakenLabel.textColor = [UIColor redColor];
}

#pragma  mark - Firebase Methods

- (void)signUpButtonTapped {
    [PMFirebaseClient createUserWithFirstName:self.firstNameTextField.text
                                        email:self.emailTextField.text
                                     password:self.passwordTextField.text
                                   completion:^(NSError *error) {
                                       
                                       if (error.code == 17007) {
                                           
                                           NSLog(@"This email is already taken");
                                           [self configureEmailAlreadyTakenLabel];
                                           self.passwordTextField.text = @"";
                                       }
                                       else {
                                           [self.delegate didLogInUser];
                                           [self.passwordTextField resignFirstResponder];
                                       }
                                   }];
}

@end
