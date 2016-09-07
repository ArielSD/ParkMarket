//
//  PMInitialViewController.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 5/24/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CardIO.h>
#import "PMApplicationViewController.h"
#import "PMCardIOViewController.h"
#import "PMPostViewController.h"
#import "PMParkViewController.h"

@protocol MenuButtonDelegate;

@interface PMInitialViewController : UIViewController <CardIOPaymentViewControllerDelegate> // For Testing only!

@property (weak, nonatomic) id <MenuButtonDelegate> delegate;

@end
