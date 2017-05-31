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

@interface PMMessagesViewController : JSQMessagesViewController

@property (strong, nonatomic) NSString *chatID;
@property (strong, nonatomic) NSString *recipient;
@property (strong, nonatomic) PMParkingSpot *parkingSpot;
@property (strong, nonatomic) NSMutableArray *messages;

- (instancetype)init;

@end
