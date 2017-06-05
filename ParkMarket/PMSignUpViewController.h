//
//  PMSignUpViewController.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 6/5/17.
//  Copyright © 2017 Ariel Scott-Dicker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMSignUpViewController;

@protocol PMSignUpViewControllerDelegate <NSObject>

@required

- (void)didSignUpUser;

@end

@interface PMSignUpViewController : UIViewController

@property (weak, nonatomic) id <PMSignUpViewControllerDelegate> delegate;

@end
