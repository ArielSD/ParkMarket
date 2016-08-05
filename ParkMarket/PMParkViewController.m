//
//  PMParkViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 6/10/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMParkViewController.h"

@interface PMParkViewController ()

@property CGFloat viewHeight;
@property CGFloat viewWidth;

@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) UILabel *questionLabel;
@property (strong, nonatomic) UIButton *parkButton;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@end

@implementation PMParkViewController

- (void)viewDidLoad {
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

#pragma mark - Network Call

- (void)showParkingSpotMarkers {
    [PMFirebaseClient getAvailableParkingSpotsWithCompletion:^(NSDictionary *parkingSpots) {
        
        for (NSString *parkingSpotKey in parkingSpots) {
            NSDictionary *parkingSpot = parkingSpots[parkingSpotKey];
            
            NSString *parkingSpotLatitudeString = parkingSpot[@"latitude"];
            NSString *parkingSpotLongitudeString = parkingSpot[@"longitude"];
            
            double parkingSpotLatitudeDouble = parkingSpotLatitudeString.doubleValue;
            double parkingSpotLongitudeDouble = parkingSpotLongitudeString.doubleValue;
            
            CLLocationCoordinate2D parkingSpotLocation = CLLocationCoordinate2DMake(parkingSpotLatitudeDouble, parkingSpotLongitudeDouble);
            
            GMSMarker *marker = [GMSMarker markerWithPosition:parkingSpotLocation];
            marker.appearAnimation = kGMSMarkerAnimationPop;
            marker.title = @"Test";
            marker.map = self.mapView;
        }
    }];
}

@end
