//
//  PMChat.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 6/6/17.
//  Copyright © 2017 Ariel Scott-Dicker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSQMessage.h>

#import "PMParkingSpot.h"

@interface PMChat : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *receiver;
@property (strong, nonatomic) PMParkingSpot *parkingSpot;
@property (strong, nonatomic) NSMutableArray <JSQMessage *> *messages;

+ (instancetype)chatFromDictionary:(NSDictionary *)dictionary
                                id:(NSString *)id;

@end
