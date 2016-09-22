//
//  PMMenu.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 9/8/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMMenuViewController;

@protocol PMMenuViewControllerDelegate <NSObject>

@required

- (void)didTapAddCardButton;
- (void)didTapMySpotsButton;
- (void)didTapLogoutButton;

@end

@interface PMMenuViewController : UIViewController

@property (weak, nonatomic) id <PMMenuViewControllerDelegate> delegate;

- (instancetype)init;

@end
