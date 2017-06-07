//
//  PMChat.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 6/6/17.
//  Copyright © 2017 Ariel Scott-Dicker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSQMessage.h>

@interface PMChat : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSMutableArray <JSQMessage *> *messages;

+ (instancetype)chatFromDictionary:(NSDictionary *)dictionary;

@end
