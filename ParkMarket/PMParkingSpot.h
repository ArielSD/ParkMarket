//
//  PMParkingSpot.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 8/5/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FirebaseAuth/FirebaseAuth.h>
#import <GoogleMaps/GoogleMaps.h>

@interface PMParkingSpot : NSObject

@property (strong, nonatomic) NSString *ownerFirstName;
@property (strong, nonatomic) NSString *ownerUID;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *car;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

@property (strong, nonatomic) GMSMarker *parkingSpotMarker;

+ (instancetype)parkingSpotFromDictionary:(NSDictionary *)dictionary;

@end
