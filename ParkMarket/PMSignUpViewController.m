//
//  PMSignUpViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 6/5/17.
//  Copyright © 2017 Ariel Scott-Dicker. All rights reserved.
//

#import "PMSignUpViewController.h"
#import "PMFirebaseClient.h"

@interface PMSignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

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
                                      failure:^(NSError *error) {
                                          if (error) {
                                              NSLog(@"Sign In Error: %@", error);
                                          }
                                          
                                          else {
                                              [self.delegate didSignUpUser];
                                              [self dismissViewControllerAnimated:YES completion:nil];
                                          }
                                      }];
}

- (IBAction)closeButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
