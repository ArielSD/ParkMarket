//
//  PMMapViewController.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 5/25/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <FirebaseDatabase/FirebaseDatabase.h>
#import <CoreLocation/CoreLocation.h>
#import "PMInitialViewController.h"

@interface PMPostViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) FIRDatabaseReference *rootReference;

@property CGFloat viewHeight;
@property CGFloat viewWidth;

@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) UILabel *questionLabel;
@property (strong, nonatomic) UIButton *postButton;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@end
