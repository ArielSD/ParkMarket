//
//  PMFirebaseClient.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 8/2/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FirebaseDatabase/FirebaseDatabase.h>
#import <FirebaseAuth/FirebaseAuth.h>

@interface PMFirebaseClient : NSObject

+ (void)createUserWithFirstName:(NSString *)firstName
                          email:(NSString *)email
                       password:(NSString *)password
                     completion:(void (^)(NSError *error))completionBlock;

+ (void)loginUserWithEmail:(NSString *)email
                  password:(NSString *)password
                completion:(void (^)(NSError *error))completionBlock;

+ (void)postParkingSpotWithLatitude:(NSString *)latitude
                          longitute:(NSString *)longitude
                           carModel:(NSString *)carModel;

+ (void)getAvailableParkingSpotsWithCompletion:(void (^)(NSDictionary *parkingSpots))completionBlock;

+ (void)getCurrentUserPostedSpots:(void (^)(NSDictionary *currentUsersPostedSpots))completionBlock;

+ (void)removeClaimedParkingSpotWithIdentifier:(NSString *)identifier;

+ (void)removeClaimedParkingSpotFromOwner:(NSString *)owner
                           withIdentifier:(NSString *)identifier;

@end
