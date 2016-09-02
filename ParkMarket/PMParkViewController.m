//
//  PMParkViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 6/10/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMParkViewController.h"

@interface PMParkViewController ()

@property (strong, nonatomic) NSMutableDictionary *parkingSpots;
@property (strong, nonatomic) NSMutableArray *parkingSpotMarkers;
@property (strong, nonatomic) GMSMarker *selectedMarker;

@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) UILabel *questionLabel;
@property (strong, nonatomic) UIButton *parkButton;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@property CGFloat viewHeight;
@property CGFloat viewWidth;

@end

@implementation PMParkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureLocationManager];
    
    // Firebase call to populate the mapview with 'posted' parking spots.
    [self getAllAvailableParkingSpots];
    
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
    self.mapView.delegate = self;
    
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
                        action:@selector(parkButtonTapped)
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

- (void)getAllAvailableParkingSpots {
    [PMFirebaseClient getAvailableParkingSpotsWithCompletion:^(NSDictionary *parkingSpots) {
        if (parkingSpots == nil) {
            [self noAvailableSpots];
        }
        else {
            self.parkingSpots = [NSMutableDictionary dictionaryWithDictionary:parkingSpots];
            [self populateMapWithMarkersForParkingSpotsFromDictionary:self.parkingSpots];
        }
    }];
}

#pragma mark - Helper Methods

- (void)populateMapWithMarkersForParkingSpotsFromDictionary:(NSDictionary *)dictionary {
    self.parkingSpotMarkers = [NSMutableArray new];
    
    for (NSString *parkingSpotKey in dictionary) {
        NSDictionary *parkingSpot = dictionary[parkingSpotKey];
        
        NSString *parkingSpotIdentifier = parkingSpot[@"identifier"];
        NSString *parkingSpotOwner = parkingSpot[@"owner"];
        NSString *parkingSpotLatitudeString = parkingSpot[@"latitude"];
        NSString *parkingSpotLongitudeString = parkingSpot[@"longitude"];
        
        double parkingSpotLatitudeDouble = parkingSpotLatitudeString.doubleValue;
        double parkingSpotLongitudeDouble = parkingSpotLongitudeString.doubleValue;
        
        CLLocationCoordinate2D parkingSpotLocation = CLLocationCoordinate2DMake(parkingSpotLatitudeDouble, parkingSpotLongitudeDouble);
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            GMSMarker *marker = [GMSMarker markerWithPosition:parkingSpotLocation];
            marker.userData = parkingSpotIdentifier;
            marker.appearAnimation = kGMSMarkerAnimationPop;
            marker.title = parkingSpotOwner;
            marker.snippet = parkingSpotIdentifier;
            marker.map = self.mapView;
            
            [self.parkingSpotMarkers addObject:marker];
        });
    }
}

// Alert controller if there are no available parking spots (This will be useful when I make a distance radius)
- (void)noAvailableSpots {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hmmm..."
                                                                             message:@"There are currently no available spots"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    
    [alertController addAction:action];
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

// Alert controller for when a user tries to "park" without selecting a parking spot first.
- (void)noParkingSpotSelected {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Not so fast!"
                                                                             message:@"You haven't selected a parking spot to take."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    
    [alertController addAction:action];
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

- (void)parkButtonTapped {
    if (self.selectedMarker == nil) {
        [self noParkingSpotSelected];
    }
    else {
    GMSMarker *markerToDelete = self.selectedMarker;
    [self.parkingSpots removeObjectForKey:self.selectedMarker.userData];
    [PMFirebaseClient removeClaimedParkingSpotWithIdentifier:self.selectedMarker.userData];
    [PMFirebaseClient removeClaimedParkingSpotFromOwner:self.selectedMarker.title
                                         withIdentifier:self.selectedMarker.userData];
    markerToDelete.map = nil;
    }
}

#pragma mark - Map View Delegate Methods

- (void)mapView:(GMSMapView *)mapView didLongPressInfoWindowOfMarker:(GMSMarker *)marker {
    
    if (marker.opacity == 1) {
        self.selectedMarker = marker;
        
        for (GMSMarker *marker in self.parkingSpotMarkers) {
            marker.icon = nil;
            marker.opacity = 1;
        }
        
        marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
        marker.opacity = 0.5;
    }
    else {
        self.selectedMarker = nil;
        marker.icon = nil;
        marker.opacity = 1;
    }
}

@end
