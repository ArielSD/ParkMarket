//
//  PMApplicationViewController.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 7/27/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FirebaseAuth/FirebaseAuth.h>
// Testing only
#import <AFNetworking.h>
// Testing only
#import "PMInitialViewController.h"
#import "PMLoginViewController.h"
#import "PMMenu.h"

@class PMApplicationViewController;

@protocol MenuButtonDelegate <NSObject>

@required

- (void)didTapMenuButton;

@end

@interface PMApplicationViewController : UIViewController <PMLoginViewControllerDelegate, MenuButtonDelegate>

@end
