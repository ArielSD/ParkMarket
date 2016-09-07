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
#import "PMCardIOViewController.h"
#import "PMPostViewController.h"
#import "PMParkViewController.h"

@class PMInitialViewController;

@protocol PMInitialViewControllerDelegate <NSObject>

@required

- (void)didTapMenuButton;

@end

@interface PMInitialViewController : UIViewController <CardIOPaymentViewControllerDelegate> // For Testing only!

@property (weak, nonatomic) id <PMInitialViewControllerDelegate> delegate;

@end
