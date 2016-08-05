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

+ (void)createUserWithEmail:(NSString *)email
                   password:(NSString *)password;

+ (void)postParkingSpotWithLatitude:(NSString *)latitude
                          longitute:(NSString *)longitude;

+ (void)getAvailableParkingSpotsWithCompletion:(void (^)(NSDictionary *parkingSpots))completionBlock;

@end
