//
//  PMMapViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 5/25/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMPostViewController.h"

@interface PMPostViewController ()

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@property CGFloat viewHeight;
@property CGFloat viewWidth;

@end

@implementation PMPostViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureLocationManager];
    [self configureNavigationBarItems];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Layout

-(void)configureMapView {
    GMSCameraPosition *cameraPosition = [GMSCameraPosition cameraWithLatitude:self.currentLocation.coordinate.latitude
                                                                    longitude:self.currentLocation.coordinate.longitude
                                                                         zoom:15];
    
    self.mapView.camera = cameraPosition;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.myLocationEnabled = YES;
}

- (void)configureNavigationBarItems {
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(menuButtonTapped)];
    
    self.navigationItem.title = @"Post";
    self.navigationItem.rightBarButtonItem = menuButton;
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

- (IBAction)postButtonTapped:(id)sender {
    UIAlertController *carModelAlertController = [UIAlertController alertControllerWithTitle:@"What kind of car are you parking?"
                                                                                     message:nil
                                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *post = [UIAlertAction actionWithTitle:@"Post"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     NSString *currentLocationLatitude = [NSString stringWithFormat:@"%f", self.currentLocation.coordinate.latitude];
                                                     NSString *currentLocationLongitude = [NSString stringWithFormat:@"%f", self.currentLocation.coordinate.longitude];
                                                     NSString *carModel = carModelAlertController.textFields.firstObject.text;
                                                     
                                                     [PMFirebaseClient postParkingSpotWithLatitude:currentLocationLatitude
                                                                                         longitute:currentLocationLongitude
                                                                                          carModel:carModel];
                                                     
                                                     [self confirmPostedParkingSpot];
                                                 }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    
    [carModelAlertController addAction:post];
    [carModelAlertController addAction:cancel];
    [carModelAlertController addTextFieldWithConfigurationHandler:nil];
    carModelAlertController.preferredAction = post;
    
    [self presentViewController:carModelAlertController
                       animated:YES
                     completion:nil];
}

#pragma mark - Responder Methods

- (void)menuButtonTapped {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuButtonWasTapped"
                                                        object:self];
}

#pragma mark - Helper Methods

- (void)confirmPostedParkingSpot {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Posted!"
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

@end
