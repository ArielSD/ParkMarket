//
//  UITextField+PMTextField.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 5/31/17.
//  Copyright © 2017 Ariel Scott-Dicker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (PMTextField)

+ (void)shake:(UITextField *)textField
         view:(UIView *)view
   constraint:(NSLayoutConstraint *)constraint;

@end
