//
//  PMParkingSpot.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 8/5/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMParkingSpot.h"

@implementation PMParkingSpot

+ (instancetype)parkingSpotFromDictionary:(NSDictionary *)dictionary {
    PMParkingSpot *parkingSpot = [PMParkingSpot new];
    parkingSpot.ownerFirstName = dictionary[@"owner"];
    parkingSpot.ownerUID = dictionary[@"owner UID"];
    parkingSpot.identifier = dictionary[@"identifier"];
    parkingSpot.car = dictionary[@"car"];
    parkingSpot.latitude = dictionary[@"latitude"];
    parkingSpot.longitude = dictionary[@"longitude"];
    return parkingSpot;
}

@end
