//
//  PMFirebaseClient.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 8/2/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMFirebaseClient.h"

// Because of an import loop issue
#import "PMMessagesViewController.h"

@implementation PMFirebaseClient

#pragma mark - Class Methods

#pragma mark - User Management

#warning Refactor with 'success' and 'failure' blocks
+ (void)createUserWithFirstName:(NSString *)firstName email:(NSString *)email password:(NSString *)password completion:(void (^)(NSError *))completionBlock {
    [[FIRAuth auth] createUserWithEmail:email
                               password:password
                             completion:^(FIRUser *user, NSError *error) {
                                 
                                 if (error) {
                                     completionBlock(error);
                                 }
                                 
                                 else{
                                     NSDictionary *userInformation = @{@"first name" : firstName,
                                                                       @"email" : email};
                                     
                                     FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
                                     FIRDatabaseReference *usersReference = [rootReference child:@"users"];
                                     FIRDatabaseReference *newUserReference = [usersReference child:user.uid];
                                     [newUserReference setValue:userInformation];
                                     
                                     completionBlock(nil);
                                 }
                             }];
}

+ (void)loginUserWithEmail:(NSString *)email
                  password:(NSString *)password
                   success:(void (^)(FIRUser *))success
                   failure:(void (^)(NSError *))failure {
    [[FIRAuth auth] signInWithEmail:email
                           password:password
                         completion:^(FIRUser *user, NSError *error) {
                             if (error) {
                                 failure(error);
                             }
                             
                             else {
                                 success(user);
                             }
                         }];
}

//+ (void)loginUserWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(NSError *))completionBlock {
//    [[FIRAuth auth] signInWithEmail:email
//                           password:password
//                         completion:^(FIRUser *user, NSError *error) {
//                             
//                             if (error) {
//                                 completionBlock(error);
//                             }
//                             
//                             else {
//                                 completionBlock(nil);
//                             }
//                         }];
//}

#pragma mark - Posting Spots

#warning Refactor this to two separate methods
+ (void)postParkingSpotWithLatitude:(NSString *)latitude longitute:(NSString *)longitude carModel:(NSString *)carModel {
    
    // Posting a spot to the 'parkingSpots' node
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    NSString *currentUserUID = currentUser.uid;
    
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *parkingSpotsReference = [rootReference child:@"parkingSpots"];
    FIRDatabaseReference *newParkingSpotReference = [parkingSpotsReference childByAutoId];
    
    PMFirebaseClient *firebaseClient = [PMFirebaseClient new];
    [firebaseClient getCurrentUserFirstNameWithCompletion:^(NSDictionary *currentUser) {
        NSString *currentUserFirstName = currentUser[@"first name"];
        NSDictionary *parkingSpotInformation = @{@"owner" : currentUserFirstName,
                                                 @"owner UID" : currentUserUID,
                                                 @"car" : carModel,
                                                 @"identifier" : newParkingSpotReference.key,
                                                 @"latitude" : latitude,
                                                 @"longitude" : longitude};
        
        [newParkingSpotReference setValue:parkingSpotInformation];
    }];
    
    // Posting a spot to the currently logged in user
    FIRDatabaseReference *usersReference = [rootReference child:@"users"];
    FIRDatabaseReference *currentUserReference = [usersReference child:currentUserUID];
    FIRDatabaseReference *postedParkingSpotsReference = [currentUserReference child:@"postedParkingSpots"];
    FIRDatabaseReference *newPostedParkingSpotReference = [postedParkingSpotsReference child:newParkingSpotReference.key];
    
    NSDictionary *parkingSpotCoordinates = @{@"identifier" : newParkingSpotReference.key,
                                             @"car" : carModel,
                                             @"latitude" : latitude,
                                             @"longitude" : longitude};
    
    [newPostedParkingSpotReference setValue:parkingSpotCoordinates];
}

#pragma mark - Retrieving Spots

+ (void)getAvailableParkingSpotsWithCompletion:(void (^)(NSDictionary *parkingSpots))completionBlock {
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *parkingSpotsReference = [rootReference child:@"parkingSpots"];
    
    [parkingSpotsReference observeSingleEventOfType:FIRDataEventTypeValue
                                  withBlock:^(FIRDataSnapshot *snapshot) {
                                      NSDictionary *parkingSpots = snapshot.value;
                                      
                                      if ([snapshot exists]) {
                                          completionBlock(parkingSpots);
                                      }
                                      
                                      else if (![snapshot exists]) {
                                          completionBlock(nil);
                                      }
                                  }];
}

+ (void)getCurrentUserPostedSpots:(void (^)(NSDictionary *parkingSpots))completionBlock {
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *usersReference = [rootReference child:@"users"];
    FIRDatabaseReference *currentUserReference = [usersReference child:[FIRAuth auth].currentUser.uid];
    FIRDatabaseReference *currentUserPostedParkingSpotsReference = [currentUserReference child:@"postedParkingSpots"];
    
    [currentUserPostedParkingSpotsReference observeSingleEventOfType:FIRDataEventTypeValue
                                                           withBlock:^(FIRDataSnapshot *snapshot) {
                                                               NSDictionary *parkingSpots = snapshot.value;
                                                               if ([snapshot exists]) {
                                                                   completionBlock(parkingSpots);
                                                               }
                                                               
                                                               else if (![snapshot exists]) {
                                                                   completionBlock(nil);
                                                               }
                                                           }];
}

#pragma mark - Removing Spots

// Remove a spot from the 'parkingSpots' node
+ (void)removeClaimedParkingSpotWithIdentifier:(NSString *)identifier {
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *parkingSpotsReference = [rootReference child:@"parkingSpots"];
    FIRDatabaseReference *parkingSpotToRemoveReference = [parkingSpotsReference child:identifier];
    [parkingSpotToRemoveReference removeValue];
}

// Remove a spot from the 'users' node
+ (void)removeClaimedParkingSpotFromOwner:(NSString *)owner withIdentifier:(NSString *)identifier {
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *usersReference = [rootReference child:@"users"];
    FIRDatabaseReference *parkingSpotOwnerReference = [usersReference child:owner];
    FIRDatabaseReference *ownersParkingSpotsReference = [parkingSpotOwnerReference child:@"postedParkingSpots"];
    FIRDatabaseReference *parkingSpotToRemoveReference = [ownersParkingSpotsReference child:identifier];
    [parkingSpotToRemoveReference removeValue];
}

#pragma mark - Messaging

+ (void)addMessageFromMessagesViewController:(PMMessagesViewController *)messagesViewController
                                 messageBody:(NSString *)messageBody {
    
    // Add message to the "chats" node
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *chatsReference = [rootReference child:@"chats"];
    FIRDatabaseReference *currentChatReference = [chatsReference child:messagesViewController.chatID];
    FIRDatabaseReference *newMessageReference = [currentChatReference childByAutoId];
    
    NSDictionary *messageInformation = @{@"sender" : [FIRAuth auth].currentUser.uid,
                                         @"message body" : messageBody};
    
    [newMessageReference setValue:messageInformation];
    
    // Add chat to the sender's (current user) node
    FIRDatabaseReference *usersReference = [rootReference child:@"users"];
    FIRDatabaseReference *currentUserReference = [usersReference child:[FIRAuth auth].currentUser.uid];
    FIRDatabaseReference *currentUserAllChatsReference = [currentUserReference child:@"chats"];
    FIRDatabaseReference *currentUserCurrentChatReference = [currentUserAllChatsReference child:messagesViewController.chatID];
    [currentUserCurrentChatReference setValue:@{@"chatID" : messagesViewController.chatID}];
    
    // Add chat to the receiver's node
    FIRDatabaseReference *messageReceiverReference = [usersReference child:messagesViewController.recipient];
    FIRDatabaseReference *messageReceiverAllChatsReference = [messageReceiverReference child:@"chats"];
    FIRDatabaseReference *messageReceiverCurrentChatReference = [messageReceiverAllChatsReference child:messagesViewController.chatID];
    [messageReceiverCurrentChatReference setValue:@{@"chatID" : messagesViewController.chatID}];
}

+ (void)observeNewMessagesInViewController:(PMMessagesViewController *)messagesViewController {
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *chatsReference = [rootReference child:@"chats"];
    FIRDatabaseReference *chatToObserveReference = [chatsReference child:messagesViewController.chatID];
    
    [chatToObserveReference observeEventType:FIRDataEventTypeChildAdded
                                   withBlock:^(FIRDataSnapshot *snapshot) {
                                       JSQMessage *message = [JSQMessage messageWithSenderId:snapshot.value[@"sender"]
                                                                                 displayName:@""
                                                                                        text:snapshot.value[@"message body"]];
                                       
                                       [messagesViewController.messages addObject:message];
                                       [messagesViewController finishReceivingMessage];
                                   }];
}

+ (void)getCurrentUserChats:(void (^)(NSDictionary *))completionBlock {
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *usersReference = [rootReference child:@"users"];
    FIRDatabaseReference *currentUserReference = [usersReference child:[FIRAuth auth].currentUser.uid];
    FIRDatabaseReference *currentUserChatsReference = [currentUserReference child:@"chats"];
    
    [currentUserChatsReference observeSingleEventOfType:FIRDataEventTypeValue
                                              withBlock:^(FIRDataSnapshot *snapshot) {
                                                  NSDictionary *chats = snapshot.value;
                                                  if ([snapshot exists]) {
                                                      completionBlock(chats);
                                                  }
                                                  
                                                  else if (![snapshot exists]) {
                                                      completionBlock(nil);
                                                  }
                                              }];
}

#pragma mark - Helper Methods

- (void)getCurrentUserFirstNameWithCompletion:(void (^)(NSDictionary *currentUser))completionBlock {
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *usersReference = [rootReference child:@"users"];
    FIRDatabaseReference *currentUserReference = [usersReference child:[FIRAuth auth].currentUser.uid];
    
    [currentUserReference observeSingleEventOfType:FIRDataEventTypeValue
                                         withBlock:^(FIRDataSnapshot *snapshot) {
                                             NSDictionary *currentUserDictionary = snapshot.value;
                                             completionBlock(currentUserDictionary);
                                         }];
}

- (void)getCurrentUserChatsWithCompletion:(void (^)(NSDictionary *chats))completionBlock {
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *usersReference = [rootReference child:@"users"];
    FIRDatabaseReference *currentUserReference = [usersReference child:[FIRAuth auth].currentUser.uid];
    FIRDatabaseReference *currentUserChatsReference = [currentUserReference child:@"chats"];
    
    [currentUserChatsReference observeSingleEventOfType:FIRDataEventTypeValue
                                              withBlock:^(FIRDataSnapshot *snapshot) {
                                                  NSDictionary *currentUserChatsDictionary = snapshot.value;
                                                  completionBlock(currentUserChatsDictionary);
                                              }];
}

@end
