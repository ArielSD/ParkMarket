//
//  PMParkingSpot.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 8/5/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FirebaseAuth/FirebaseAuth.h>

@interface PMParkingSpot : NSObject

@property (strong, nonatomic) FIRUser *owner;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

@end
