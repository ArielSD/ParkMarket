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
@property (strong, nonatomic) UILabel *emailAlreadyTakenLabel;
@property (strong, nonatomic) UILabel *whatShouldWeCallYouLabel;
@property (strong, nonatomic) UILabel *loggingYouInLabel;

@property (strong, nonatomic) UITextField *firstNameTextField;
@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *confirmPasswordTextField;

@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *signUpButton;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

// Constraints that can change
@property (strong, nonatomic) NSLayoutConstraint *passwordTextFieldTopConstraint;
@property (strong, nonatomic) NSLayoutConstraint *emailTextFieldTopConstraint;

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
    self.emailTextFieldTopConstraint = [self.firstNameTextField.topAnchor constraintEqualToAnchor:self.welcomeLabel.bottomAnchor
                                                      constant:self.view.frame.size.height / 33];
    self.emailTextFieldTopConstraint.active = YES;
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
    self.emailTextFieldTopConstraint = [self.emailTextField.topAnchor constraintEqualToAnchor:self.firstNameTextField.bottomAnchor
                                                  constant:self.view.frame.size.height / 50.0];
    self.emailTextFieldTopConstraint.active = YES;
    [self.emailTextField.widthAnchor constraintEqualToAnchor:self.view.widthAnchor
                                                  multiplier:0.5].active = YES;
    
    self.emailTextField.adjustsFontSizeToFitWidth = YES;
    self.emailTextField.minimumFontSize = 4.0;
    
    self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailTextField.placeholder = @"Email";
    
    self.emailTextField.delegate = self;
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
    
    self.passwordTextField.delegate = self;
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
    
    self.confirmPasswordTextField.delegate = self;
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
    
    [self.loginButton addTarget:self
                         action:@selector(loginButtonTapped)
               forControlEvents:UIControlEventTouchUpInside];
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
    self.emailAlreadyTakenLabel = [UILabel new];
    [self.view addSubview:self.emailAlreadyTakenLabel];
    
    self.emailAlreadyTakenLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.emailAlreadyTakenLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.emailAlreadyTakenLabel.topAnchor constraintEqualToAnchor:self.emailTextField.bottomAnchor
                                                          constant:self.view.frame.size.height / 50.0].active = YES;
    [self.emailAlreadyTakenLabel.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    
    self.passwordTextFieldTopConstraint.active = NO;
    self.passwordTextFieldTopConstraint = [self.passwordTextField.topAnchor constraintEqualToAnchor:self.emailAlreadyTakenLabel.bottomAnchor
                                                                                           constant:self.view.frame.size.height / 50.0];
    self.passwordTextFieldTopConstraint.active = YES;
    
    self.emailAlreadyTakenLabel.text = @"Email is already taken";
    self.emailAlreadyTakenLabel.textAlignment = NSTextAlignmentCenter;
    self.emailAlreadyTakenLabel.textColor = [UIColor redColor];
}

- (void)configureWhatShouldWeCallYouLabel {
    self.whatShouldWeCallYouLabel = [UILabel new];
    [self.view addSubview:self.whatShouldWeCallYouLabel];
    
    self.whatShouldWeCallYouLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.whatShouldWeCallYouLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.whatShouldWeCallYouLabel.topAnchor constraintEqualToAnchor:self.firstNameTextField.bottomAnchor
                                                            constant:self.view.frame.size.height / 50.0].active = YES;
    [self.whatShouldWeCallYouLabel.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    
    self.emailTextFieldTopConstraint.active = NO;
    self.emailTextFieldTopConstraint = [self.emailTextField.topAnchor constraintEqualToAnchor:self.whatShouldWeCallYouLabel.bottomAnchor
                                                                                     constant:self.view.frame.size.height / 50.0];
    self.emailTextFieldTopConstraint.active = YES;
    
    self.whatShouldWeCallYouLabel.text = @"What should we call you?";
    self.whatShouldWeCallYouLabel.textAlignment = NSTextAlignmentCenter;
    self.whatShouldWeCallYouLabel.textColor = [UIColor redColor];
}

- (void)configureLoggingYouInLabel {
    self.loggingYouInLabel = [UILabel new];
    [self.view addSubview:self.loggingYouInLabel];
    
    self.loggingYouInLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.loggingYouInLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.loggingYouInLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor
                                                         constant:self.view.frame.size.height / 8.0].active = YES;
    [self.loggingYouInLabel.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    
    self.loggingYouInLabel.textAlignment = NSTextAlignmentCenter;
    self.loggingYouInLabel.text = @"Logging you in...";
}

- (void)configureActivityIndicator {
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicator];
    
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.activityIndicator.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.activityIndicator.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.activityIndicator.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.activityIndicator.heightAnchor constraintEqualToAnchor:self.view.heightAnchor].active = YES;
    
    self.activityIndicator.backgroundColor = [UIColor whiteColor];
    
    [self configureLoggingYouInLabel];
    
    [self.activityIndicator startAnimating];
}

#pragma mark - UITextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.backgroundColor == [UIColor redColor]) {
        textField.backgroundColor = [UIColor whiteColor];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ((textField == self.emailTextField) && (textField.text.length > 0)) {
        textField.backgroundColor = [UIColor whiteColor];
    }
}

#pragma  mark - Firebase Methods

- (void)signUpButtonTapped {
    
    // Check if the 'First Name' field is blank
    if ([self.firstNameTextField.text isEqualToString:@""]) {
        [self configureWhatShouldWeCallYouLabel];
    }
    
    // Check if the two password fields don't match
    else if (self.passwordTextField.text != self.confirmPasswordTextField.text) {
        self.passwordTextField.backgroundColor = [UIColor redColor];
        self.confirmPasswordTextField.backgroundColor = [UIColor redColor];
        
        self.passwordTextField.text = @"";
        self.confirmPasswordTextField.text = @"";
    }
    
    else {
        [self.confirmPasswordTextField resignFirstResponder];
        [self configureActivityIndicator];
        self.loggingYouInLabel.text = @"Signing you in...";
        
    [PMFirebaseClient createUserWithFirstName:self.firstNameTextField.text
                                        email:self.emailTextField.text
                                     password:self.passwordTextField.text
                                   completion:^(NSError *error) {
                                       
                                       if (error) {
                                           
                                           NSLog(@"Error: %@", error.localizedDescription);
                                           NSLog(@"Error Code: %lu", error.code);
                                           
                                           // Check if an email is already taken
                                           if (error.code == 17007) {
                                               [self configureEmailAlreadyTakenLabel];
                                               self.passwordTextField.text = @"";
                                               self.confirmPasswordTextField.text = @"";
                                           }
                                           
                                           // Check if the 'email' field is invalid or left blank
                                           if (error.code == 17999) {
                                               self.emailTextField.backgroundColor = [UIColor redColor];
                                               
                                               self.passwordTextFieldTopConstraint.active = NO;
                                               self.passwordTextFieldTopConstraint = [self.passwordTextField.topAnchor constraintEqualToAnchor:self.emailTextField.bottomAnchor
                                                                                                                                      constant:self.view.frame.size.height / 50.0];
                                               
                                               self.passwordTextField.text = @"";
                                               self.confirmPasswordTextField.text = @"";
                                               
                                               self.passwordTextFieldTopConstraint.active = YES;
                                               [self.emailAlreadyTakenLabel removeFromSuperview];
                                           }
                                       }
                                       
                                       else {
                                           [self.activityIndicator stopAnimating];
                                           self.loggingYouInLabel.hidden = YES;
                                           [self.delegate didLogInUser];
                                       }
                                   }];
    }
}

- (void)loginButtonTapped {
    
    // Check if the two password fields don't match
    if (self.passwordTextField.text != self.confirmPasswordTextField.text) {
        self.passwordTextField.backgroundColor = [UIColor redColor];
        self.confirmPasswordTextField.backgroundColor = [UIColor redColor];
        
        self.passwordTextField.text = @"";
        self.confirmPasswordTextField.text = @"";
    }
    
    else {
        [self.confirmPasswordTextField resignFirstResponder];
        [self configureActivityIndicator];
        
    [PMFirebaseClient loginUserWithEmail:self.emailTextField.text
                                password:self.passwordTextField.text
                              completion:^(NSError *error) {
                                  
                                  if (error) {
                                      NSLog(@"Error logging in: %@", error);
                                      NSLog(@"%@", error.localizedDescription);
                                  }
                                  
                                  else {
                                      [self.activityIndicator stopAnimating];
                                      self.loggingYouInLabel.hidden = YES;
                                      [self.delegate didLogInUser];
                                  }
                              }];
    }
}

@end
