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

@class PMParkViewController;

@protocol PMParkViewControllerMessageDelegate <NSObject>

@required

- (void)didTapMessageButtonForParkingSpot:(PMParkingSpot *)parkingSpot;

@end

@interface PMParkViewController : UIViewController <CLLocationManagerDelegate, GMSMapViewDelegate>

@property (weak, nonatomic) id <PMParkViewControllerMessageDelegate> delegate;

@end
