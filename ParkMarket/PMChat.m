//
//  PMChat.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 6/6/17.
//  Copyright © 2017 Ariel Scott-Dicker. All rights reserved.
//

#import "PMChat.h"

@implementation PMChat

+ (instancetype)chatFromDictionary:(NSDictionary *)dictionary {
    PMChat *chat = [PMChat new];
    chat.messages = [NSMutableArray new];
    chat.id = dictionary.allKeys.firstObject;
    NSDictionary *chatDictionary = dictionary[chat.id];
    chat.receiver = chatDictionary[@"receiver"];
    NSDictionary *messagesDictionary = chatDictionary[@"messages"];
    
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
