//
//  PMSignUpViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 6/5/17.
//  Copyright © 2017 Ariel Scott-Dicker. All rights reserved.
//

#import "PMSignUpViewController.h"

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
    
    [self.closeButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)closeButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
