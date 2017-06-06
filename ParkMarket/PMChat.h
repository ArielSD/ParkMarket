//
//  PMChat.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 6/6/17.
//  Copyright © 2017 Ariel Scott-Dicker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMChat : NSObject

@property (strong, nonatomic) NSString *id;

+ (instancetype)chatFromDictionary:(NSDictionary *)dictionary;

@end
