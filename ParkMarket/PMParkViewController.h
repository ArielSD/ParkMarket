//
//  PMParkViewController.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 6/10/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <FirebaseDatabase/FirebaseDatabase.h>

#import "PMFirebaseClient.h"
#import "PMApplicationViewController.h"
#import "PMParkingSpot.h"

@protocol MenuButtonDelegate;

@interface PMParkViewController : UIViewController <CLLocationManagerDelegate, GMSMapViewDelegate>

@property (weak, nonatomic) id <MenuButtonDelegate> delegate;

@end
