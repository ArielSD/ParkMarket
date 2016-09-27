//
//  PMUserPostedSpotsViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 9/23/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMUserPostedSpotsViewController.h"

@interface PMUserPostedSpotsViewController ()

@property (strong, nonatomic) NSMutableDictionary *parkingSpots;
@property (strong, nonatomic) NSMutableArray *parkingSpotMarkers;

@property (strong, nonatomic) GMSMarker *selectedMarker;
@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) UINavigationBar *navigationBar;
@property (strong, nonatomic) UIButton *removeSpotButton;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@property CGFloat viewHeight;
@property CGFloat viewWidth;

@end

@implementation PMUserPostedSpotsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureLocationManager];
    
    [self getAllUserPostedParkingSpots];
    
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
    
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)
                                     camera:camera];
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
}

- (void)configureNavigationBar {
    self.navigationBar = [UINavigationBar new];
    [self.view addSubview:self.navigationBar];
    
    self.navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.navigationBar.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.navigationBar.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.navigationBar.heightAnchor constraintEqualToAnchor:self.view.heightAnchor
                                                  multiplier:0.1].active = YES;
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"My Posted Spots"];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneButtonTapped)];
    
    navigationItem.rightBarButtonItem = doneButton;
    self.navigationBar.items = @[navigationItem];
}

- (void)configureRemoveSpotButton {
    self.removeSpotButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self.view addSubview:self.removeSpotButton];
    
    self.removeSpotButton.backgroundColor = [UIColor whiteColor];
    [self.removeSpotButton setTitle:@"Remove"
                           forState:UIControlStateNormal];
    
    self.removeSpotButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.removeSpotButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.removeSpotButton.centerYAnchor constraintEqualToAnchor:self.view.bottomAnchor
                                                        constant:-40].active = YES;
    [self.removeSpotButton.widthAnchor constraintEqualToAnchor:self.view.widthAnchor
                                                    multiplier:0.5].active = YES;
    
    [self.removeSpotButton addTarget:self
                              action:@selector(removePostedParkingSpot)
                    forControlEvents:UIControlEventTouchUpInside];
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
        
        if (!self.mapView) {
            [self configureMapView];
            [self configureNavigationBar];
            [self configureRemoveSpotButton];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if ([CLLocationManager authorizationStatus] == 4) {
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - Network Call

- (void)getAllUserPostedParkingSpots {
    [PMFirebaseClient getCurrentUserPostedSpots:^(NSDictionary *currentUsersPostedSpots) {
        if (currentUsersPostedSpots == nil) {
            [self noUserPostedSpots];
        }
        
        else {
            self.parkingSpots = [NSMutableDictionary dictionaryWithDictionary:currentUsersPostedSpots];
            [self populateMapWithMarkersForParkingSpotsFromDictionary:self.parkingSpots];
        }
    }];
}
                                   
#pragma mark - Helper Methods
                                   
- (void)doneButtonTapped {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)noUserPostedSpots {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hmmm..."
                                                                             message:@"You don't have any posted spots!"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [self dismissViewControllerAnimated:YES
                                                                                completion:nil];
                                                   }];
    
    [alertController addAction:action];
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

- (void)populateMapWithMarkersForParkingSpotsFromDictionary:(NSDictionary *)dictionary {
    self.parkingSpotMarkers = [NSMutableArray new];
    
    for (NSString *parkingSpotKey in dictionary) {
        NSDictionary *parkingSpot = dictionary[parkingSpotKey];
        
        NSString *typeOfCarParked = parkingSpot[@"car"];
        NSString *parkingSpotLatitudeString = parkingSpot[@"latitude"];
        NSString *parkingSpotLongitudeString = parkingSpot[@"longitude"];
        
        double parkingSpotLatitudeDouble = parkingSpotLatitudeString.doubleValue;
        double parkingSpotLongitudeDouble = parkingSpotLongitudeString.doubleValue;
        
        CLLocationCoordinate2D parkingSpotLocation = CLLocationCoordinate2DMake(parkingSpotLatitudeDouble, parkingSpotLongitudeDouble);
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            GMSMarker *marker = [GMSMarker markerWithPosition:parkingSpotLocation];
            marker.appearAnimation = kGMSMarkerAnimationPop;
            marker.title = [NSString stringWithFormat:@"Car: %@", typeOfCarParked];
            marker.icon = [GMSMarker markerImageWithColor:[UIColor yellowColor]];
            marker.map = self.mapView;
            
            [self.parkingSpotMarkers addObject:marker];
        });
    }
}

@end
