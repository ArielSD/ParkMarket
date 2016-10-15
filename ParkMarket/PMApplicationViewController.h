//
//  PMApplicationViewController.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 7/27/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FirebaseAuth/FirebaseAuth.h>
#import <CardIO.h>

// Testing only
#import <AFNetworking.h>
// Testing only

#import "PMPayPalClient.h"

#import "PMLoginViewController.h"
#import "PMInitialViewController.h"
#import "PMMenuViewController.h"
#import "PMUserPostedSpotsViewController.h"
#import "PMMessagesViewController.h"

@class PMApplicationViewController;

@protocol MenuButtonDelegate <NSObject>

@required

- (void)didTapMenuButton;

@end

@interface PMApplicationViewController : UIViewController <PMLoginViewControllerDelegate,
                                                           MenuButtonDelegate,
                                                           PMMenuViewControllerDelegate,
                                                           CardIOPaymentViewControllerDelegate,
                                                           PMMessagesViewControllerDelegate>

@end
