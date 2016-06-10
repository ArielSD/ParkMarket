//
//  PMMapViewController.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 5/25/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "PMInitialViewController.h"

@class PMInitialViewController;

@interface PMMapViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) UILabel *questionLabel;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

-(void)configureMapView;
-(void)configureLocationManager;

@end
