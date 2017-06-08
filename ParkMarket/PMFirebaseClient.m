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

+ (void)createUserWithFirstName:(NSString *)firstName
                          email:(NSString *)email
                       password:(NSString *)password
                confirmPassword:(NSString *)confirmPassword
                        failure:(void (^)(NSDictionary *error))failure {
    [[FIRAuth auth] createUserWithEmail:email
                               password:password
                             completion:^(FIRUser *user, NSError *error) {
                                 if ([firstName isEqualToString:@""]) {
                                     NSDictionary *errorDictionary = @{@"error name" : @"EMPTY_FIRST_NAME",
                                                                       @"message" : @""};
                                     failure(errorDictionary);
                                 }
                                 
                                 else if (![password isEqualToString:confirmPassword]) {
                                     NSDictionary *errorDictionary = @{@"error name" : @"PASSWORDS_DO_NOT_MATCH",
                                                                       @"message" : @""};
                                     failure(errorDictionary);
                                 }
                                 
                                 else if (error) {
                                     NSError *underlyingError = error.userInfo[@"NSUnderlyingError"];
                                     NSDictionary *FIRAuthErrorUserInfoDeserializedResponseKey = underlyingError.userInfo[@"FIRAuthErrorUserInfoDeserializedResponseKey"];
                                     NSString *errorName =  error.userInfo[@"error_name"];
                                     NSString *message = FIRAuthErrorUserInfoDeserializedResponseKey ? FIRAuthErrorUserInfoDeserializedResponseKey[@"message"] : @"";
                                     NSDictionary *errorDictionary = @{@"error name" : errorName,
                                                                       @"message" : message};
                                     failure(errorDictionary);
                                 }
                                 
                                 else {
                                     NSDictionary *userInformation = @{@"first name" : firstName,
                                                                       @"email" : email};
                                     
                                     FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
                                     FIRDatabaseReference *usersReference = [rootReference child:@"users"];
                                     FIRDatabaseReference *newUserReference = [usersReference child:user.uid];
                                     [newUserReference setValue:userInformation];
                                     failure(nil);
                                 }
                             }];
}

+ (void)loginUserWithEmail:(NSString *)email
                  password:(NSString *)password
                   failure:(void (^)(NSDictionary *error))failure {
    [[FIRAuth auth] signInWithEmail:email
                           password:password
                         completion:^(FIRUser *user, NSError *error) {
                             if (error) {
                                 NSError *underlyingError = error.userInfo[@"NSUnderlyingError"];
                                 NSDictionary *FIRAuthErrorUserInfoDeserializedResponseKey = underlyingError.userInfo[@"FIRAuthErrorUserInfoDeserializedResponseKey"];
                                 NSString *errorName =  error.userInfo[@"error_name"];
                                 NSString *message = FIRAuthErrorUserInfoDeserializedResponseKey ? FIRAuthErrorUserInfoDeserializedResponseKey[@"message"] : @"";
                                 NSDictionary *errorDictionary = @{@"error name" : errorName,
                                                                   @"message" : message};
                                 failure(errorDictionary);
                             }
                         }];
}

#pragma mark - Posting Spots

#warning Refactor this to two separate methods
+ (void)postParkingSpotWithLatitude:(NSString *)latitude longitute:(NSString *)longitude carModel:(NSString *)carModel {
    
    // Posting a spot to the 'parkingSpots' node
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    NSString *currentUserUID = currentUser.uid;
    
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *parkingSpotsReference = [rootReference child:@"parkingSpots"];
    FIRDatabaseReference *newParkingSpotReference = [parkingSpotsReference childByAutoId];
    
    [PMFirebaseClient getCurrentUserFirstNameWithCompletion:^(NSDictionary *currentUser) {
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
                                    receiver:(NSString *)receiver
                                 messageBody:(NSString *)messageBody {
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *usersReference = [rootReference child:@"users"];
    
    // Add chat to the sender's (current user) node
    [PMFirebaseClient getUserFirstNameFromID:messagesViewController.receiverID
                                     success:^(NSString *firstName) {
                                         FIRDatabaseReference *currentUserReference = [usersReference child:[FIRAuth auth].currentUser.uid];
                                         FIRDatabaseReference *currentUserAllChatsReference = [currentUserReference child:@"chats"];
                                         FIRDatabaseReference *currentUserCurrentChatReference = [currentUserAllChatsReference child:messagesViewController.chatID];
                                         
                                         FIRDatabaseReference *currentUserCurrentChatReceiverReference = [currentUserCurrentChatReference child:@"receiver"];
                                         [currentUserCurrentChatReceiverReference setValue:messagesViewController.receiverID];
                                         
                                         FIRDatabaseReference *currentChatParkingSpotReference = [currentUserCurrentChatReference child:@"parking spot"];
                                         [currentChatParkingSpotReference setValue:messagesViewController.parkingSpot.identifier];
                                         
                                         FIRDatabaseReference *messagesReference = [currentUserCurrentChatReference child:@"messages"];
                                         FIRDatabaseReference *newMessageReference = [messagesReference childByAutoId];
                                         NSDictionary *messageInformation = @{@"sender" : [FIRAuth auth].currentUser.uid,
                                                                              @"receiver" : receiver,
                                                                              @"message body" : messageBody};
                                         
                                         [newMessageReference setValue:messageInformation];
                                     }
                                     failure:^(NSError *error) {
                                         NSLog(@"Error: %@", error);
                                     }];
    
    // Add chat to the receiver's node
    [PMFirebaseClient getUserFirstNameFromID:[FIRAuth auth].currentUser.uid
                                     success:^(NSString *firstName) {
                                         FIRDatabaseReference *messageReceiverReference = [usersReference child:messagesViewController.receiverID];
                                         FIRDatabaseReference *messageReceiverAllChatsReference = [messageReceiverReference child:@"chats"];
                                         FIRDatabaseReference *messageReceiverCurrentChatReference = [messageReceiverAllChatsReference child:messagesViewController.chatID];
                                         
                                         FIRDatabaseReference *messageReceiverCurrentChatCorrespondentReference = [messageReceiverCurrentChatReference child:@"receiver"];
                                         [messageReceiverCurrentChatCorrespondentReference setValue:messagesViewController.senderId];
                                         
                                         FIRDatabaseReference *currentChatParkingSpotReference = [messageReceiverCurrentChatReference child:@"parking spot"];
                                         [currentChatParkingSpotReference setValue:messagesViewController.parkingSpot.identifier];
                                         
                                         FIRDatabaseReference *messagesReference = [messageReceiverCurrentChatReference child:@"messages"];
                                         FIRDatabaseReference *newMessageReference = [messagesReference childByAutoId];
                                         NSDictionary *messageInformation = @{@"sender" : [FIRAuth auth].currentUser.uid,
                                                                              @"receiver" : receiver,
                                                                              @"message body" : messageBody};
                                         
                                         [newMessageReference setValue:messageInformation];
                                     }
                                     failure:^(NSError *error) {
                                         NSLog(@"Error: %@", error);
                                     }];
}

+ (void)observeNewMessagesInViewController:(PMMessagesViewController *)messagesViewController {
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *usersReference = [rootReference child:@"users"];
    FIRDatabaseReference *senderReference = [usersReference child:messagesViewController.senderId];
    FIRDatabaseReference *senderChatsReference = [senderReference child:@"chats"];
    FIRDatabaseReference *senderCurrentChatReference = [senderChatsReference child:messagesViewController.chatID];
    FIRDatabaseReference *senderCurrentChatMessagesReference = [senderCurrentChatReference child:@"messages"];
    
    [senderCurrentChatMessagesReference observeEventType:FIRDataEventTypeChildAdded
                                               withBlock:^(FIRDataSnapshot *snapshot) {
                                                   JSQMessage *message = [JSQMessage messageWithSenderId:snapshot.value[@"sender"]
                                                                                             displayName:@"displayName"
                                                                                                    text:snapshot.value[@"message body"]];
                                  
                                  [messagesViewController.messages addObject:message];
                                  [messagesViewController.collectionView reloadData];
                                  [messagesViewController finishReceivingMessage];
                              }];
}

+ (void)getCurrentUserChats:(void (^)(NSArray *chats))success
                    failure:(void (^)(NSError *error))failure {
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *usersReference = [rootReference child:@"users"];
    FIRDatabaseReference *currentUserReference = [usersReference child:[FIRAuth auth].currentUser.uid];
    FIRDatabaseReference *currentUserChatsReference = [currentUserReference child:@"chats"];
    
    [currentUserChatsReference observeSingleEventOfType:FIRDataEventTypeValue
                                              withBlock:^(FIRDataSnapshot *snapshot) {
                                                  if ([snapshot exists]) {
                                                      NSMutableArray *chatsArray = [NSMutableArray new];
                                                      NSDictionary *chats = snapshot.value;
                                                      for (NSString *key in chats) {
                                                          PMChat *chat = [PMChat chatFromDictionary:chats[key] id:key];
                                                          [chatsArray addObject:chat];
                                                      }
                                                      success(chatsArray);
                                                  }
                                              }
                                        withCancelBlock:^(NSError *error) {
                                            failure(error);
                                        }];
}

+ (void)getChatWithKey:(NSString *)key
               success:(void (^)(NSDictionary *))success
               failure:(void (^)(NSError *))failure{
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *chatsReference = [rootReference child:@"chats"];
    FIRDatabaseReference *chatToRetrieveReference = [chatsReference child:key];
    
    [chatToRetrieveReference observeSingleEventOfType:FIRDataEventTypeValue
                                            withBlock:^(FIRDataSnapshot *snapshot) {
                                                if ([snapshot exists]) {
                                                    NSDictionary *chat = snapshot.value;
                                                    success([NSDictionary dictionaryWithObject:chat
                                                                                        forKey:key]);
                                                }
                                            }
                                      withCancelBlock:^(NSError *error) {
                                          failure(error);
                                      }];
}

+ (void)getParkingSpotFromChat:(PMChat *)chat
                       success:(void (^)(PMParkingSpot *parkingSpot))success
                       failure:(void (^)(NSError *error))failure {
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *chatsReference = [rootReference child:@"chats"];
    FIRDatabaseReference *currentChatReference = [chatsReference child:chat.id];
    
    [currentChatReference observeSingleEventOfType:FIRDataEventTypeValue
                                         withBlock:^(FIRDataSnapshot *snapshot) {
                                             if ([snapshot exists]) {
                                                 NSDictionary *chat = snapshot.value;
                                                 NSString *parkingSpotID = chat[@"parking spot"];
                                                 
                                                 FIRDatabaseReference *parkingSpotsReference = [rootReference child:@"parkingSpots"];
                                                 
                                                 [parkingSpotsReference observeSingleEventOfType:FIRDataEventTypeValue
                                                                                       withBlock:^(FIRDataSnapshot *snapshot) {
                                                                                           if ([snapshot exists]) {
                                                                                               NSDictionary *parkingSpots = snapshot.value;
                                                                                               NSDictionary *parkingSpotDictionary = parkingSpots[parkingSpotID];
                                                                                               success([PMParkingSpot parkingSpotFromDictionary:parkingSpotDictionary]);
                                                                                           }
                                                                                       }
                                                                                 withCancelBlock:^(NSError *error) {
                                                                                     failure(error);
                                                                                 }];
                                                 
                                                 success(chat[@"parking spot"]);
                                             }
                                         }
                                   withCancelBlock:^(NSError *error) {
                                       failure(error);
                                   }];
}

//+ (void)getMessagesInChat:(PMChat *)chat
//                  success:(void (^)(NSArray *))success
//                  failure:(void (^)(NSError *))failure {
//    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
//    FIRDatabaseReference *chatsReference = [rootReference child:@"chats"];
//    FIRDatabaseReference *chatReference = [chatsReference child:chat.id];
//    
//    [chatReference observeSingleEventOfType:FIRDataEventTypeValue
//                                  withBlock:^(FIRDataSnapshot *snapshot) {
//                                      if ([snapshot exists]) {
//                                          NSDictionary *snapshotDictionary = snapshot.value;
//                                          NSMutableArray *messages = [NSMutableArray new];
//                                          
//                                          for (NSString *messageKey in snapshotDictionary.allKeys) {
//                                              NSDictionary *messageDictionary = snapshotDictionary[messageKey];
//                                              JSQMessage *message = [JSQMessage messageWithSenderId:messageDictionary[@"sender"]
//                                                                                        displayName:@"displayName"
//                                                                                               text:messageDictionary[@"message body"]];
//                                              
//                                              [messages addObject:message];
//                                              success(messages);
//                                          }
//                                      }
//                                  }
//                            withCancelBlock:^(NSError *error) {
//                                failure(error);
//                            }];
//}

#pragma mark - Helper Methods

+ (void)getCurrentUserFirstNameWithCompletion:(void (^)(NSDictionary *currentUser))completionBlock {
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *usersReference = [rootReference child:@"users"];
    FIRDatabaseReference *currentUserReference = [usersReference child:[FIRAuth auth].currentUser.uid];
    
    [currentUserReference observeSingleEventOfType:FIRDataEventTypeValue
                                         withBlock:^(FIRDataSnapshot *snapshot) {
                                             NSDictionary *currentUserDictionary = snapshot.value;
                                             completionBlock(currentUserDictionary);
                                         }];
}

+ (void)getUserFirstNameFromID:(NSString *)userID
                       success:(void (^)(NSString *firstName))success
                       failure:(void (^)(NSError *error))failure {
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *usersReference = [rootReference child:@"users"];
    FIRDatabaseReference *userReference = [usersReference child:userID];
    
    [userReference observeSingleEventOfType:FIRDataEventTypeValue
                                  withBlock:^(FIRDataSnapshot *snapshot) {
                                      if ([snapshot exists]) {
                                          NSDictionary *user = snapshot.value;
                                          success(user[@"first name"]);
                                      }
                                  }
                            withCancelBlock:^(NSError *error) {
                                failure(error);
                            }];
}

@end
