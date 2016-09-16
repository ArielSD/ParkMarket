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

+ (void)postParkingSpotWithLatitude:(NSString *)latitude longitute:(NSString *)longitude carModel:(NSString *)carModel {
    
    // Posting a spot to the 'parkingSpots' node
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *parkingSpotsReference = [rootReference child:@"parkingSpots"];
    FIRDatabaseReference *newParkingSpotReference = [parkingSpotsReference childByAutoId];
    
    PMFirebaseClient *firebaseClient = [PMFirebaseClient new];
    [firebaseClient getCurrentUserFirstNameWithCompletion:^(NSDictionary *currentUser) {
        NSString *currentUserFirstName = currentUser[@"first name"];
        NSDictionary *parkingSpotInformation = @{@"owner" : currentUserFirstName,
                                                 @"car" : carModel,
                                                 @"identifier" : newParkingSpotReference.key,
                                                 @"latitude" : latitude,
                                                 @"longitude" : longitude};
        
        [newParkingSpotReference setValue:parkingSpotInformation];
    }];
    
    // Posting a spot to the currently logged in user
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    NSString *currentUserUID = currentUser.uid;
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
                                      
                                      if ([parkingSpots isKindOfClass:[NSNull class]]) {
                                          completionBlock(nil);
                                      }
                                      else {
                                          completionBlock(parkingSpots);
                                      }
                                  }];
}

// Remove a spot from the 'parkingSpots' node
+ (void)removeClaimedParkingSpotWithIdentifier:(NSString *)identifier {
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *parkingSpotsReference = [rootReference child:@"parkingSpots"];
    FIRDatabaseReference *parkingSpotToRemoveReference = [parkingSpotsReference child:identifier];
    [parkingSpotToRemoveReference removeValue];
}

+ (void)removeClaimedParkingSpotFromOwner:(NSString *)owner withIdentifier:(NSString *)identifier {
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
