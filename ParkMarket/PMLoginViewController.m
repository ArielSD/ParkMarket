//
//  PMLoginViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 7/25/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMLoginViewController.h"
#import "PMFirebaseClient.h"
#import "UITextField+PMTextField.h"

@interface PMLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

// Animatable Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailTextFieldCenterXContstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordTextFieldCenterXConstraint;

@end

@implementation PMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Did receive memory warning");
}

/*

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
 
 */

- (IBAction)logInButtonTapped:(id)sender {
    [PMFirebaseClient loginUserWithEmail:self.emailTextField.text
                                password:self.passwordTextField.text
                                 failure:^(NSDictionary *error) {
                                     if (!error) {
                                         [self.delegate didLogInUser];
                                     }
                                     
                                     else {
                                         if ([error[@"message"] isEqualToString:@"INVALID_EMAIL"]) {
                                             [UITextField shake:self.emailTextField
                                                           view:self.view
                                                     constraint:self.emailTextFieldCenterXContstraint];
                                         }
                                         
                                         if ([error[@"error name"] isEqualToString:@"ERROR_WRONG_PASSWORD"] || [error[@"message"] isEqualToString:@"MISSING_PASSWORD"]) {
                                             [UITextField shake:self.passwordTextField
                                                           view:self.view
                                                     constraint:self.passwordTextFieldCenterXConstraint];
                                         }
                                         
                                         if ([error[@"error name"] isEqualToString:@"ERROR_USER_NOT_FOUND"]) {
                                             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hmmm..."
                                                                                                                      message:@"Looks like you don't have an account yet. Tap Sign Up to make one now!"
                                                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                             
                                             UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                                                              style:UIAlertActionStyleDefault
                                                                                            handler:nil];
                                             
                                             [alertController addAction:action];
                                             [self presentViewController:alertController
                                                                animated:YES
                                                              completion:nil];
                                         }
                                     }
                                 }];
}

- (IBAction)signUpButtonTapped:(id)sender {
    [self presentViewController:self.signUpViewController animated:YES completion:nil];
}

@end
