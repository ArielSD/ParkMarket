//
//  PMFirebaseClient.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 8/2/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMFirebaseClient.h"

@implementation PMFirebaseClient

+ (void)createUserWithEmail:(NSString *)email password:(NSString *)password {
    [[FIRAuth auth] createUserWithEmail:email
                               password:password
                             completion:^(FIRUser *user, NSError *error) {
                                 
                                 NSDictionary *userInformation = @{@"email" : email};
                                 
                                 FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
                                 FIRDatabaseReference *usersReference = [rootReference child:@"users"];
                                 FIRDatabaseReference *newUserReference = [usersReference child:user.uid];
                                 [newUserReference setValue:userInformation];
                             }];
}

+ (void)postParkingSpotWithLatitude:(NSString *)latitude longitute:(NSString *)longitude {
    NSDictionary *parkingSpotCoordinates = @{@"latitude" : latitude,
                                             @"longitude" : longitude};
    
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *parkingSpotsReference = [rootReference child:@"parkingSpots"];
    FIRDatabaseReference *newParkingSpotReference = [parkingSpotsReference childByAutoId];
    [newParkingSpotReference setValue:parkingSpotCoordinates];
}

+ (void)getAvailableParkingSpotsWithCompletion:(void (^)(NSDictionary *parkingSpots))completionBlock {
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *parkingSpotsReference = [rootReference child:@"parkingSpots"];
    [parkingSpotsReference observeSingleEventOfType:FIRDataEventTypeValue
                                  withBlock:^(FIRDataSnapshot *snapshot) {
                                      NSDictionary *parkingSpots = snapshot.value;
                                      completionBlock(parkingSpots);
                                  }];
}

@end
