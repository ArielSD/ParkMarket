//
//  PMSignUpViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 6/5/17.
//  Copyright © 2017 Ariel Scott-Dicker. All rights reserved.
//

#import "UITextField+PMTextField.h"
#import "PMSignUpViewController.h"
#import "PMFirebaseClient.h"

@interface PMSignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

// Animatable Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstNameTextFieldCenterXConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailTextFieldCenterXConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordTextFieldCenterXConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmPasswordTextFieldCenterXConstraint;

@end

@implementation PMSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)signUpButtonTapped:(id)sender {
    [PMFirebaseClient createUserWithFirstName:self.firstNameTextField.text
                                        email:self.emailTextField.text
                                     password:self.passwordTextField.text
                              confirmPassword:self.confirmPasswordTextField.text
                                      failure:^(NSDictionary *error) {
                                          if (!error) {
                                              [self.delegate didSignUpUser];
                                              [self dismissViewControllerAnimated:YES completion:nil];
                                          }
                                          
                                          else if ([error[@"error name"] isEqualToString:@"PASSWORDS_DO_NOT_MATCH"]) {
                                              [UITextField shake:self.passwordTextField
                                                            view:self.view
                                                      constraint:self.passwordTextFieldCenterXConstraint];
                                              
                                              [UITextField shake:self.confirmPasswordTextField
                                                            view:self.view
                                                      constraint:self.confirmPasswordTextFieldCenterXConstraint];
                                          }
                                          
                                          else {
                                              if ([error[@"error name"] isEqualToString:@"EMPTY_FIRST_NAME"]) {
                                                  [UITextField shake:self.firstNameTextField
                                                                view:self.view
                                                          constraint:self.firstNameTextFieldCenterXConstraint];
                                              }
                                              
                                              if ([error[@"message"] isEqualToString:@"INVALID_EMAIL"]) {
                                                  [UITextField shake:self.emailTextField
                                                                view:self.view
                                                          constraint:self.emailTextFieldCenterXConstraint];
                                              }
                                              
                                              if ([error[@"message"] isEqualToString:@"MISSING_PASSWORD"] || [error[@"error name"] isEqualToString:@"ERROR_WEAK_PASSWORD"]) {
                                                  [UITextField shake:self.passwordTextField
                                                                view:self.view
                                                          constraint:self.passwordTextFieldCenterXConstraint];
                                              }
                                              
                                              if ([error[@"error name"] isEqualToString:@"ERROR_EMAIL_ALREADY_IN_USE"]) {
                                                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hmmm..."
                                                                                                                           message:@"Looks like you already have an account. Try logging in!"
                                                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                                                  
                                                  UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                                                                   style:UIAlertActionStyleDefault
                                                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                                                     [self dismissViewControllerAnimated:YES completion:nil];
                                                                                                 }];
                                                  
                                                  [alertController addAction:action];
                                                  [self presentViewController:alertController
                                                                     animated:YES
                                                                   completion:nil];
                                              }
                                          }
                                      }];
}

- (IBAction)closeButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
