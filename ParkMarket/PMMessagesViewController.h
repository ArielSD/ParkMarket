//
//  PMMessagesViewController.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 9/27/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import <JSQMessagesViewController.h>
#import <JSQMessage.h>
#import <JSQMessages.h>
#import <JSQMessagesBubbleImageFactory.h>
#import <JSQMessagesBubbleImage.h>

#import "PMFirebaseClient.h"
#import "PMParkingSpot.h"
#import "PMChat.h"

@interface PMMessagesViewController : JSQMessagesViewController

#warning These properties should be private
@property (strong, nonatomic) NSString *chatID;
@property (strong, nonatomic) NSString *receiverID;
@property (strong, nonatomic) NSMutableArray <JSQMessage *> *messages;

- (instancetype)initWithParkingSpot:(PMParkingSpot *)parkingSpot;
- (instancetype)initWithChat:(PMChat *)chat;

@end
