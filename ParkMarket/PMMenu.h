//
//  PMMenu.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 9/8/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMMenu : UIView

@property (strong, nonatomic) UIButton *addCardButton;
@property (strong, nonatomic) UIButton *logoutButton;

- (instancetype)initInViewController:(UIViewController *)viewController;

@end
