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
@property (strong, nonatomic) PMParkingSpot *selectedParkingSpot;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UILabel *gettingAvailableParkingSpotsLabel;

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *parkButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@end

@implementation PMParkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureLocationManager];
    [self configureNotificationObservers];
    [self configureNavigationBarItems];
    
    // Firebase call to populate the mapview with 'posted' parking spots.
    [self getAllAvailableParkingSpots];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Layout

-(void)configureMapView {
    GMSCameraPosition *cameraPosition = [GMSCameraPosition cameraWithLatitude:self.currentLocation.coordinate.latitude
                                                                    longitude:self.currentLocation.coordinate.longitude
                                                                         zoom:15];
    
    self.mapView.camera = cameraPosition;
    self.mapView.delegate = self;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.myLocationEnabled = YES;
}

- (void)configureNavigationBarItems {
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(menuButtonTapped)];
    
    self.navigationItem.title = @"Park";
    self.navigationItem.rightBarButtonItem = menuButton;
}

- (void)configureGettingAvailableParkingSpotsLabel {
    self.gettingAvailableParkingSpotsLabel = [UILabel new];
    [self.view addSubview:self.gettingAvailableParkingSpotsLabel];
    
    self.gettingAvailableParkingSpotsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.gettingAvailableParkingSpotsLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.gettingAvailableParkingSpotsLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor
                                                         constant:self.view.frame.size.height / 8.0].active = YES;
    [self.gettingAvailableParkingSpotsLabel.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    
    self.gettingAvailableParkingSpotsLabel.textAlignment = NSTextAlignmentCenter;
    self.gettingAvailableParkingSpotsLabel.text = @"Getting all available spots...";
}

- (void)configureActivityIndicator {
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicator];
    
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.activityIndicator.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.activityIndicator.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.activityIndicator.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.activityIndicator.heightAnchor constraintEqualToAnchor:self.view.heightAnchor].active = YES;
    
    self.activityIndicator.backgroundColor = [UIColor whiteColor];
    
    [self configureGettingAvailableParkingSpotsLabel];
    
    [self.activityIndicator startAnimating];
}

#pragma mark - Core Location

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
    [self configureActivityIndicator];
    
    [PMFirebaseClient getAvailableParkingSpotsWithCompletion:^(NSDictionary *parkingSpots) {
        if (parkingSpots == nil) {
            [self noAvailableSpots];
        }
        
        else {
            [self.activityIndicator stopAnimating];
            self.gettingAvailableParkingSpotsLabel.hidden = YES;
            
            self.parkingSpots = [NSMutableDictionary new];
            
            for (NSString *parkingSpotIdentifier in parkingSpots) {
                PMParkingSpot *parkingSpot = [PMParkingSpot parkingSpotFromDictionary:parkingSpots[parkingSpotIdentifier]];
                
                [self.parkingSpots setObject:parkingSpot
                                      forKey:parkingSpot.identifier];
            }
            
            [self populateMapWithMarkersForParkingSpotsFromDictionary:self.parkingSpots];
        }
    }];
}

#pragma mark - Responder Methods

- (void)menuButtonTapped {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuButtonWasTapped"
                                                        object:self];
}

#pragma mark - Helper Methods

- (void)populateMapWithMarkersForParkingSpotsFromDictionary:(NSDictionary *)dictionary {
    for (NSString *parkingSpotIdentifier in dictionary) {
        PMParkingSpot *parkingSpot = dictionary[parkingSpotIdentifier];
        
        NSDictionary *parkingSpotData = @{@"owner UID" : parkingSpot.ownerUID,
                                          @"identifier" : parkingSpot.identifier};
        
        CLLocationCoordinate2D parkingSpotLocation = CLLocationCoordinate2DMake(parkingSpot.latitude.doubleValue, parkingSpot.longitude.doubleValue);
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            parkingSpot.parkingSpotMarker = [GMSMarker markerWithPosition:parkingSpotLocation];
            parkingSpot.parkingSpotMarker.userData = parkingSpotData;
            parkingSpot.parkingSpotMarker.appearAnimation = kGMSMarkerAnimationPop;
            parkingSpot.parkingSpotMarker.title = [NSString stringWithFormat:@"Owner: %@", parkingSpot.ownerFirstName];
            parkingSpot.parkingSpotMarker.snippet = parkingSpot.car;
            parkingSpot.parkingSpotMarker.map = self.mapView;
        });
    }
}

- (void)parkButtonTapped {
    if (self.selectedParkingSpot == nil) {
        [self noParkingSpotSelected];
    }
    
    else {
        [self.parkingSpots removeObjectForKey:self.selectedParkingSpot.identifier];
        
        [PMFirebaseClient removeClaimedParkingSpotWithIdentifier:self.selectedParkingSpot.identifier];
        [PMFirebaseClient removeClaimedParkingSpotFromOwner:self.selectedParkingSpot.ownerUID
                                             withIdentifier:self.selectedParkingSpot.identifier];
        
        self.selectedParkingSpot.parkingSpotMarker.map = nil;
        [self confirmTakenSpot];
    }
}

- (IBAction)messageButtonTapped:(id)sender {
    [self.delegate didTapMessageButtonForParkingSpot:self.selectedParkingSpot];
}

// Alert controller if there are no available parking spots (This will be useful when I make a distance radius)
- (void)noAvailableSpots {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hmmm..."
                                                                             message:@"There are currently no available spots"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [self.navigationController popToRootViewControllerAnimated:YES];
                                                   }];
    
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

- (void)confirmTakenSpot {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Parked!"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController
                       animated:YES
                     completion:^{
                         [UIView animateWithDuration:0.4
                                          animations:^{
                                              alertController.view.alpha = 0.0;
                                          } completion:^(BOOL finished) {
                                              [self dismissViewControllerAnimated:YES
                                                                       completion:nil];
                                              [self.navigationController popToRootViewControllerAnimated:YES];
                                          }];
                     }];
}

- (void)configureNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(parkButtonTappedInPresentedMessagesViewController:)
                                                 name:@"parkTappedInMessagesViewController"
                                               object:nil];
}

- (void)parkButtonTappedInPresentedMessagesViewController:(NSNotification *)notification {
    NSDictionary *parkingSpotDictionary = notification.userInfo;
    NSString *parkingSpotToTakeIdentifier = parkingSpotDictionary[@"parkingSpotInMessagesViewController"];
    PMParkingSpot *parkingSpotToTake = self.parkingSpots[parkingSpotToTakeIdentifier];
    
    self.selectedParkingSpot = parkingSpotToTake;
    [self parkButtonTapped];
}

#pragma mark - Map View Delegate Methods

- (void)mapView:(GMSMapView *)mapView didLongPressInfoWindowOfMarker:(GMSMarker *)marker {
    if (marker.opacity == 1) {
        self.selectedParkingSpot = self.parkingSpots[marker.userData[@"identifier"]];
        
        for (NSString *parkingSpotIdentifier in self.parkingSpots) {
            PMParkingSpot *parkingSpot = self.parkingSpots[parkingSpotIdentifier];
            
            parkingSpot.parkingSpotMarker.icon = nil;
            parkingSpot.parkingSpotMarker.opacity = 1;
        }
        
        marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
        marker.opacity = 0.5;
        self.parkButton.enabled = YES;
        self.messageButton.hidden = NO;
    }
    
    else {
        self.selectedParkingSpot = nil;
        marker.icon = nil;
        marker.opacity = 1;
        self.parkButton.enabled = NO;
    }
}

@end
