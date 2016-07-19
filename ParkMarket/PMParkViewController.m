//
//  PMParkViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 6/10/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMParkViewController.h"

@interface PMParkViewController ()

@end

@implementation PMParkViewController

- (void)viewDidLoad {
    
    NSLog(@"Parking View did load");
    
    [super viewDidLoad];
    [self configureLocationManager];
    [self showParkingSpotMarkers];
    
    self.viewHeight = self.view.frame.size.height;
    self.viewWidth = self.view.frame.size.width;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Did receive memory warning");
}

#pragma mark - UI Layout

-(void)configureMapView {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.currentLocation.coordinate.latitude
                                                            longitude:self.currentLocation.coordinate.longitude
                                                                 zoom:15];
    
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, self.viewHeight * 0.2, self.viewWidth, self.viewHeight - (self.viewHeight * 0.2))
                                     camera:camera];
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.myLocationEnabled = YES;
    
    [self.view addSubview:self.mapView];
    
    [self configureQuestionLabel];
    [self configureParkButton];
    
    //    GMSMarker *marker = [GMSMarker new];
    //    marker.position = CLLocationCoordinate2DMake(40.858632, -74.276822);
    //    marker.title = @"1 Sunset Road";
    //    marker.snippet = @"West Caldwell, New Jersey";
    //    marker.map = self.mapView;
}

-(void)configureQuestionLabel {
    self.questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.viewWidth, self.viewHeight * 0.2 - self.navigationController.navigationBar.frame.size.height)];
    self.questionLabel.textAlignment = NSTextAlignmentCenter;
    self.questionLabel.text = @"Where do you want to park?";
    [self.view addSubview:self.questionLabel];
}

-(void)configureParkButton {
    self.parkButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self.view addSubview:self.parkButton];
    
    self.parkButton.backgroundColor = [UIColor whiteColor];
    [self.parkButton setTitle:@"Park"
                     forState:UIControlStateNormal];
    
    self.parkButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.parkButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.parkButton.centerYAnchor constraintEqualToAnchor:self.view.bottomAnchor
                                                  constant:-40].active = YES;
    [self.parkButton.widthAnchor constraintEqualToAnchor:self.view.widthAnchor
                                              multiplier:0.5].active = YES;
    
    [self.parkButton addTarget:self
                        action:@selector(postButtonTapped)
              forControlEvents:UIControlEventTouchUpInside];
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
    CLLocation *mostRecentLocation = [locations lastObject];
    NSDate *locationCaptureTime = mostRecentLocation.timestamp;
    NSTimeInterval timeSinceLocationCapture = [locationCaptureTime timeIntervalSinceNow];
    
    if (timeSinceLocationCapture <= 2) {
        self.currentLocation = mostRecentLocation;
        [self.locationManager stopUpdatingLocation];
        [self configureMapView];
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if ([CLLocationManager authorizationStatus] == 4) {
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - Firebase Methods

- (void)showParkingSpotMarkers {
    
    NSLog(@"Show parking spot markers called");
    
    self.rootReference = [[FIRDatabase database] reference];
    [self.rootReference observeEventType:FIRDataEventTypeChildAdded
                               withBlock:^(FIRDataSnapshot *snapshot) {
                                   NSString *parkingSpotLatitudeString = snapshot.value[@"Latitude"];
                                   NSString *parkingSpotLongitudeString = snapshot.value[@"Longitude"];
                                   double parkingSpotLatitudeDouble = parkingSpotLatitudeString.doubleValue;
                                   double parkingSpotLongitudeDouble = parkingSpotLongitudeString.doubleValue;
                                   
                                   CLLocationCoordinate2D parkingSpot = CLLocationCoordinate2DMake(parkingSpotLatitudeDouble, parkingSpotLongitudeDouble);
                                   GMSMarker *marker = [GMSMarker markerWithPosition:parkingSpot];
                                   
                                   NSLog(@"Marker position: %f", marker.position.latitude);
                                   
                                   marker.appearAnimation = kGMSMarkerAnimationPop;
                                   marker.title = @"Test";
                                   marker.map = self.mapView;
                               }];
}

@end
