//
//  UITextField+PMTextField.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 5/31/17.
//  Copyright © 2017 Ariel Scott-Dicker. All rights reserved.
//

#import "UITextField+PMTextField.h"

@implementation UITextField (PMTextField)

+ (void)shake:(UITextField *)textField
         view:(UIView *)view
   constraint:(NSLayoutConstraint *)constraint {
    [view layoutIfNeeded];
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         constraint.constant = 20;
                         textField.layer.borderWidth = 1.0;
                         textField.layer.cornerRadius = 8.0;
                         textField.layer.borderColor = [[UIColor redColor] CGColor];
                         [view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.15
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              constraint.constant = -20;
                                              [view layoutIfNeeded];
                                          }
                                          completion:^(BOOL finished) {
                                              [UIView animateWithDuration:0.6
                                                                    delay:0
                                                   usingSpringWithDamping:0.3
                                                    initialSpringVelocity:0
                                                                  options:0
                                                               animations:^{
                                                                   constraint.constant = 0;
                                                                   [view layoutIfNeeded];
                                                               }
                                                               completion:nil];
                                          }];
                     }];
}

@end
