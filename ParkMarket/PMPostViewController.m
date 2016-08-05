//
//  PMMapViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 5/25/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMPostViewController.h"

@interface PMPostViewController ()

@end

@implementation PMPostViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self configureLocationManager];
    
    self.viewHeight = self.view.frame.size.height;
    self.viewWidth = self.view.frame.size.width;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Did recieve memory warning");
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
    [self configurePostButton];
}

-(void)configureQuestionLabel {
    self.questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.viewWidth, self.viewHeight * 0.2 - self.navigationController.navigationBar.frame.size.height)];
    self.questionLabel.textAlignment = NSTextAlignmentCenter;
    self.questionLabel.text = @"Where's the spot you're posting?";
    [self.view addSubview:self.questionLabel];
}

-(void)configurePostButton {
    
    NSLog(@"Configure post button called");
    
    self.postButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self.view addSubview:self.postButton];
    
    self.postButton.backgroundColor = [UIColor whiteColor];
    [self.postButton setTitle:@"Post"
                     forState:UIControlStateNormal];
    
    self.postButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.postButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.postButton.centerYAnchor constraintEqualToAnchor:self.view.bottomAnchor
                                                  constant:-40].active = YES;
    [self.postButton.widthAnchor constraintEqualToAnchor:self.view.widthAnchor
                                              multiplier:0.5].active = YES;
    
    [self.postButton addTarget:self
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
    
    NSLog(@"Did update locations called");
    
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

-(void)postButtonTapped {
    NSString *currentLocationLatitude = [NSString stringWithFormat:@"%f", self.currentLocation.coordinate.latitude];
    NSString *currentLocationLongitude = [NSString stringWithFormat:@"%f", self.currentLocation.coordinate.longitude];
    
    [PMFirebaseClient postParkingSpotWithLatitude:currentLocationLatitude
                                        longitute:currentLocationLongitude];
    [self confirmPostedParkingSpot];
}

#pragma mark - Helper Methods

- (void)confirmPostedParkingSpot {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Posted!"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController
                       animated:YES
                     completion:^{
                         [UIView animateWithDuration:0.8
                                          animations:^{
                                              alertController.view.alpha = 0.0;
                                          } completion:^(BOOL finished) {
                                              [self dismissViewControllerAnimated:YES
                                                                       completion:nil];
                                          }];
                     }];
}

@end
