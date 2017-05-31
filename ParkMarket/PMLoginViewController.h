//
//  PMLoginViewController.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 7/25/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PMFirebaseClient.h"

@class PMLoginViewController;

@protocol PMLoginViewControllerDelegate <NSObject>

@required

- (void)didLogInUser;

@end

@interface PMLoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@property (weak, nonatomic) id <PMLoginViewControllerDelegate> delegate;

@end
