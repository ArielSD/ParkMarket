//
//  PMChat.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 6/6/17.
//  Copyright © 2017 Ariel Scott-Dicker. All rights reserved.
//

#import "PMChat.h"

@implementation PMChat

+ (instancetype)chatFromDictionary:(NSDictionary *)dictionary
                                id:(NSString *)id {
    PMChat *chat = [PMChat new];
    chat.messages = [NSMutableArray new];
    chat.id = id;
    chat.receiver = dictionary[@"receiver"];
    NSDictionary *messagesDictionary = dictionary[@"messages"];
    
    for (NSString *key in messagesDictionary) {
        NSDictionary *messageDictionary = messagesDictionary[key];
        JSQMessage *message = [JSQMessage messageWithSenderId:messageDictionary[@"sender"]
                                                  displayName:@"Display Name"
                                                         text:messageDictionary[@"message body"]];
        
        [chat.messages addObject:message];
    }
    return chat;
}

@end
