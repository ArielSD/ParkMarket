//
//  PMMapViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 5/25/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMPostViewController.h"

@interface PMPostViewController ()

@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) UILabel *questionLabel;
@property (strong, nonatomic) UIButton *postButton;

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
    self.questionLabel = [UILabel new];
    [self.view addSubview:self.questionLabel];
    
    self.questionLabel.textAlignment = NSTextAlignmentCenter;
    self.questionLabel.text = @"Where's the spot you're posting?";
    
    CGFloat bottomOfNavigationBar = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat topYCoordinateOfMapView = CGRectGetMinY(self.mapView.frame);
    CGFloat distanceBetweenBottomOfNavigationBarAndTopOfMapView = topYCoordinateOfMapView - bottomOfNavigationBar;
    CGSize questionLabelSize = [self.questionLabel sizeThatFits:self.questionLabel.frame.size];
    
    self.questionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.questionLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.questionLabel.topAnchor constraintEqualToAnchor:self.navigationController.navigationBar.bottomAnchor
                                                 constant:(distanceBetweenBottomOfNavigationBarAndTopOfMapView / 2.0) - questionLabelSize.height / 2.0].active = YES;
    [self.questionLabel.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
}

-(void)configurePostButton {
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
        
        if (!self.mapView) {
            [self configureMapView];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if ([CLLocationManager authorizationStatus] == 4) {
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - Firebase Methods

-(void)postButtonTapped {
    [self askForCarModelBeingParked];
}

#pragma mark - Responder Methods

- (void)menuButtonTapped {
    [self.delegate didTapMenuButton];
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

- (void)askForCarModelBeingParked {
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

@end
