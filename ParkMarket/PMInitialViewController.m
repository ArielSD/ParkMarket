//
//  PMInitialViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 5/24/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMInitialViewController.h"

@interface PMInitialViewController ()

@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIButton *parkButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@end

@implementation PMInitialViewController

-(void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [CardIOUtilities preload];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Responder Methods

- (IBAction)postButtonTapped:(id)sender {
    UIStoryboard *postParkingSpotStoryboard = [UIStoryboard storyboardWithName:@"PostParkingSpot" bundle:nil];
    PMPostViewController *postViewController = [postParkingSpotStoryboard instantiateViewControllerWithIdentifier:@"postViewController"];
    
    postViewController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:postViewController
                                         animated:YES];
}

- (IBAction)parkButtonTapped:(id)sender {
    PMApplicationViewController *applicationViewController = (PMApplicationViewController *)self.parentViewController.parentViewController;
    
    UIStoryboard *parkStoryboard = [UIStoryboard storyboardWithName:@"Park" bundle:nil];
    PMParkViewController *parkViewController = [parkStoryboard instantiateViewControllerWithIdentifier:@"parkViewController"];
    parkViewController.delegate = applicationViewController;
    
    parkViewController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:parkViewController
                                         animated:YES];
}

- (IBAction)menuButtonTapped:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuButtonWasTapped"
                                                        object:self];
}

@end
