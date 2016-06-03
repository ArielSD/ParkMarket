//
//  PMMapViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 5/25/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMMapViewController.h"

@interface PMMapViewController ()

@end

@implementation PMMapViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self configureLocationManager];
    [self configureMapView];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"Did recieve memory warning");
}

#pragma mark - UI Layout

-(void)configureMapView {
    
    NSLog(@"Configure Map View Called");
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.currentLocation.coordinate.latitude
                                                            longitude:self.currentLocation.coordinate.longitude
                                                                 zoom:15];

    CGFloat viewHeight = self.view.frame.size.height;
    CGFloat viewWidth = self.view.frame.size.width;
    
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, viewHeight * 0.2, viewWidth, viewHeight - (viewHeight * 0.2))
                                     camera:camera];
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.myLocationEnabled = YES;
    
    [self.view addSubview:self.mapView];
    
//    GMSMarker *marker = [GMSMarker new];
//    marker.position = CLLocationCoordinate2DMake(40.858632, -74.276822);
//    marker.title = @"1 Sunset Road";
//    marker.snippet = @"West Caldwell, New Jersey";
//    marker.map = self.mapView;
    
    self.questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, viewWidth, viewHeight * 0.2 - self.navigationController.navigationBar.frame.size.height)];
    self.questionLabel.textAlignment = NSTextAlignmentCenter;
    self.questionLabel.text = @"Where do you want to park?";
    [self.view addSubview:self.questionLabel];
}

-(void)configureLocationManager {
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager requestWhenInUseAuthorization];
}

#pragma mark - CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    NSLog(@"Did update locations called");
    
    CLLocation *mostRecentLocation = [locations lastObject];
    NSDate *locationCaptureTime = mostRecentLocation.timestamp;
    NSTimeInterval timeSinceLocationCapture = [locationCaptureTime timeIntervalSinceNow];
    
    if (timeSinceLocationCapture <= 2) {
        self.currentLocation = mostRecentLocation;
        
        NSLog(@"Current location in the if: %@", self.currentLocation);
        NSLog(@"Current location latitude: %f   ", self.currentLocation.coordinate.latitude);
        
//        [GMSCameraUpdate setCamera:[GMSCameraPosition cameraWithLatitude:self.currentLocation.coordinate.latitude
//                                                               longitude:self.currentLocation.coordinate.longitude
//                                                                    zoom:15]];
        
        
        [self.locationManager stopUpdatingLocation];
        
        NSLog(@"Current Location: %@", self.currentLocation);
        
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    NSLog(@"Did change authorization status called");
    
    if ([CLLocationManager authorizationStatus] == 4) {
        [self.locationManager startUpdatingLocation];
    }
}

@end
