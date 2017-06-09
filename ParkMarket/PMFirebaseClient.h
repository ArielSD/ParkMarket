//
//  PMFirebaseClient.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 8/2/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FirebaseDatabase/FirebaseDatabase.h>
#import <FirebaseAuth/FirebaseAuth.h>

#import <JSQMessagesViewController.h>
#import <JSQMessage.h>

#import "PMParkingSpot.h"
#import "PMChat.h"

@class PMMessagesViewController;

@interface PMFirebaseClient : NSObject

#pragma mark - User Management

+ (void)createUserWithFirstName:(NSString *)firstName
                          email:(NSString *)email
                       password:(NSString *)password
                confirmPassword:(NSString *)confirmPassword
                        failure:(void (^)(NSDictionary *error))failure;

#warning This needs to be refactored with a success block
+ (void)loginUserWithEmail:(NSString *)email
                  password:(NSString *)password
                   failure:(void (^)(NSDictionary *error))failure;

#pragma mark - Posting Spots

+ (void)postParkingSpotWithLatitude:(NSString *)latitude
                          longitute:(NSString *)longitude
                           carModel:(NSString *)carModel;

#pragma mark - Retrieving Spots

+ (void)getAvailableParkingSpotsWithCompletion:(void (^)(NSDictionary *parkingSpots))completionBlock;

+ (void)getCurrentUserPostedSpots:(void (^)(NSDictionary *currentUsersPostedSpots))completionBlock;

#pragma mark - Removing Spots

+ (void)removeClaimedParkingSpotWithIdentifier:(NSString *)identifier;

+ (void)removeClaimedParkingSpotFromOwner:(NSString *)owner
                           withIdentifier:(NSString *)identifier;

#pragma mark - Messaging

+ (void)addMessageFromMessagesViewController:(PMMessagesViewController *)messagesViewController
                                    receiver:(NSString *)receiver
                                 messageBody:(NSString *)messageBody;

+ (void)observeNewMessagesInViewController:(PMMessagesViewController *)messagesViewController;

+ (void)getCurrentUserChatsWithSuccess:(void (^)(NSArray *chats))success
                               failure:(void (^)(NSError *error))failure;

//+ (void)getChatWithKey:(NSString *)key
//               success:(void (^) (NSDictionary *chat))success
//               failure:(void (^) (NSError *error))failure;

+ (void)getParkingSpotFromChat:(PMChat *)chat
                       success:(void (^)(PMParkingSpot *parkingSpot))success
                       failure:(void (^)(NSError *error))failure;

@end
