//
//  PMMapViewController.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 5/25/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <FirebaseDatabase/FirebaseDatabase.h>
#import "PMFirebaseClient.h"
#import "PMApplicationViewController.h"

@protocol MenuButtonDelegate;

@interface PMPostViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) id <MenuButtonDelegate> delegate;

@end
