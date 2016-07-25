//
//  PMInitialViewController.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 5/24/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PMPostViewController.h"
#import "PMParkViewController.h"

// The below import is for testing only
#import "PMLoginViewController.h"

@interface PMInitialViewController : UIViewController

@property (strong, nonatomic) UIButton *postButton;
@property (strong, nonatomic) UIButton *parkButton;

@end
