//
//  PMFirebaseClient.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 8/2/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMFirebaseClient.h"

@implementation PMFirebaseClient

#pragma mark - Class Methods

#warning Refactor with 'success' and 'failure' blocks
+ (void)createUserWithFirstName:(NSString *)firstName email:(NSString *)email password:(NSString *)password completion:(void (^)(NSError *))completionBlock {
    [[FIRAuth auth] createUserWithEmail:email
                               password:password
                             completion:^(FIRUser *user, NSError *error) {
                                 
                                 if (error) {
                                     completionBlock(error);
                                 }
                                 
                                 else{
                                     NSDictionary *userInformation = @{@"first name" : firstName,
                                                                       @"email" : email};
                                     
                                     FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
                                     FIRDatabaseReference *usersReference = [rootReference child:@"users"];
                                     FIRDatabaseReference *newUserReference = [usersReference child:user.uid];
                                     [newUserReference setValue:userInformation];
                                     
                                     completionBlock(nil);
                                 }
                             }];
}

+ (void)loginUserWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(NSError *))completionBlock {
    [[FIRAuth auth] signInWithEmail:email
                           password:password
                         completion:^(FIRUser *user, NSError *error) {
                             
                             if (error) {
                                 completionBlock(error);
                             }
                             
                             else {
                                 completionBlock(nil);
                             }
                         }];
}

#warning Refactor this to two separate methods
+ (void)postParkingSpotWithLatitude:(NSString *)latitude longitute:(NSString *)longitude carModel:(NSString *)carModel {
    
    // Posting a spot to the 'parkingSpots' node
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    NSString *currentUserUID = currentUser.uid;
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *parkingSpotsReference = [rootReference child:@"parkingSpots"];
    FIRDatabaseReference *newParkingSpotReference = [parkingSpotsReference childByAutoId];
    
    PMFirebaseClient *firebaseClient = [PMFirebaseClient new];
    [firebaseClient getCurrentUserFirstNameWithCompletion:^(NSDictionary *currentUser) {
        NSString *currentUserFirstName = currentUser[@"first name"];
        NSDictionary *parkingSpotInformation = @{@"owner" : currentUserFirstName,
                                                 @"owner UID" : currentUserUID,
                                                 @"car" : carModel,
                                                 @"identifier" : newParkingSpotReference.key,
                                                 @"latitude" : latitude,
                                                 @"longitude" : longitude};
        
        [newParkingSpotReference setValue:parkingSpotInformation];
    }];
    
    // Posting a spot to the currently logged in user
    FIRDatabaseReference *usersReference = [rootReference child:@"users"];
    FIRDatabaseReference *currentUserReference = [usersReference child:currentUserUID];
    FIRDatabaseReference *postedParkingSpotsReference = [currentUserReference child:@"postedParkingSpots"];
    FIRDatabaseReference *newPostedParkingSpotReference = [postedParkingSpotsReference child:newParkingSpotReference.key];
    
    NSDictionary *parkingSpotCoordinates = @{@"identifier" : newParkingSpotReference.key,
                                             @"latitude" : latitude,
                                             @"longitude" : longitude};
    
    [newPostedParkingSpotReference setValue:parkingSpotCoordinates];
}

+ (void)getAvailableParkingSpotsWithCompletion:(void (^)(NSDictionary *parkingSpots))completionBlock {
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *parkingSpotsReference = [rootReference child:@"parkingSpots"];
    
    [parkingSpotsReference observeSingleEventOfType:FIRDataEventTypeValue
                                  withBlock:^(FIRDataSnapshot *snapshot) {
                                      NSDictionary *parkingSpots = snapshot.value;
                                      
                                      if ([snapshot exists]) {
                                          completionBlock(parkingSpots);
                                      }
                                      
                                      else if (![snapshot exists]) {
                                          completionBlock(nil);
                                      }
                                  }];
}

+ (void)getCurrentUsersPostedSpots:(void (^)(NSDictionary *parkingSpots))completionBlock {
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *usersReference = [rootReference child:@"users"];
    FIRDatabaseReference *currentUserReference = [usersReference child:[FIRAuth auth].currentUser.uid];
    FIRDatabaseReference *currentUserPostedParkingSpotsReference = [currentUserReference child:@"postedParkingSpots"];
    
    [currentUserPostedParkingSpotsReference observeSingleEventOfType:FIRDataEventTypeValue
                                                           withBlock:^(FIRDataSnapshot *snapshot) {
                                                               NSDictionary *parkingSpots = snapshot.value;
                                                               
                                                               if ([snapshot exists]) {
                                                                   completionBlock(parkingSpots);
                                                               }
                                                               
                                                               else if (![snapshot exists]) {
                                                                   completionBlock(nil);
                                                               }
                                                           }];
}

// Remove a spot from the 'parkingSpots' node
+ (void)removeClaimedParkingSpotWithIdentifier:(NSString *)identifier {
    
    NSLog(@"Removing a spot from parking spots");
    
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *parkingSpotsReference = [rootReference child:@"parkingSpots"];
    FIRDatabaseReference *parkingSpotToRemoveReference = [parkingSpotsReference child:identifier];
    [parkingSpotToRemoveReference removeValue];
}

// Remove a spot from the 'users' node
+ (void)removeClaimedParkingSpotFromOwner:(NSString *)owner withIdentifier:(NSString *)identifier {
    
    NSLog(@"Removing a spot from a user");
    
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *usersReference = [rootReference child:@"users"];
    FIRDatabaseReference *parkingSpotOwnerReference = [usersReference child:owner];
    FIRDatabaseReference *ownersParkingSpotsReference = [parkingSpotOwnerReference child:@"postedParkingSpots"];
    FIRDatabaseReference *parkingSpotToRemoveReference = [ownersParkingSpotsReference child:identifier];
    [parkingSpotToRemoveReference removeValue];
}

#pragma mark - Helper Methods

- (void)getCurrentUserFirstNameWithCompletion:(void (^)(NSDictionary *currentUser))completionBlock {
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *usersReference = [rootReference child:@"users"];
    FIRDatabaseReference *currentUserReference = [usersReference child:[FIRAuth auth].currentUser.uid];
    
    [currentUserReference observeSingleEventOfType:FIRDataEventTypeValue
                                         withBlock:^(FIRDataSnapshot *snapshot) {
                                             NSDictionary *currentUserDictionary = snapshot.value;
                                             completionBlock(currentUserDictionary);
                                         }];
}

@end
