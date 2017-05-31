//
//  PMLoginViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 7/25/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PMLoginViewController.h"

@interface PMLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

// Constraints that can change
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailTextFieldCenterXContstraint;

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
                                 success:^(FIRUser *user) {
                                     [self.delegate didLogInUser];
                                 }
                                 failure:^(NSError *error) {
                                     
                                     [self.view layoutIfNeeded];
                                     
                                     [UIView animateWithDuration:0.15
                                                           delay:0
                                                         options:UIViewAnimationOptionCurveEaseOut
                                                      animations:^{
                                                          self.emailTextFieldCenterXContstraint.constant = 20;
                                                          self.emailTextField.layer.borderWidth = 1.0;
                                                          self.emailTextField.layer.cornerRadius = 8.0;
                                                          self.emailTextField.layer.borderColor = [[UIColor redColor] CGColor];
                                                          [self.view layoutIfNeeded];
                                                      }
                                                      completion:^(BOOL finished) {
                                                          [UIView animateWithDuration:0.15
                                                                                delay:0
                                                                              options:UIViewAnimationOptionCurveEaseOut
                                                                           animations:^{
                                                                               self.emailTextFieldCenterXContstraint.constant = -20;
                                                                               [self.view layoutIfNeeded];
                                                                           }
                                                                           completion:^(BOOL finished) {
                                                                               [UIView animateWithDuration:0.6
                                                                                                     delay:0
                                                                                    usingSpringWithDamping:0.3
                                                                                     initialSpringVelocity:0
                                                                                                   options:0
                                                                                                animations:^{
                                                                                                    self.emailTextFieldCenterXContstraint.constant = 0;
                                                                                                    [self.view layoutIfNeeded];
                                                                                                }
                                                                                                completion:nil];
                                                                           }];
                                                      }];
                                     
//                                     [UIView animateWithDuration:0.4
//                                                           delay:0
//                                                         options:UIViewAnimationOptionAutoreverse
//                                                      animations:^{
//                                                          self.emailTextFieldCenterXContstraint.constant = 20;
//                                                          [self.view layoutIfNeeded];
//                                                      }
//                                                      completion:nil];
                                     
                                     NSLog(@"Error Logging In: %@", error);
                                 }];
}

@end
