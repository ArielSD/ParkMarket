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

+ (void)loginUserWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(NSError *))completionBlock {
    [[FIRAuth auth] signInWithEmail:email
                           password:password
                         completion:^(FIRUser *user, NSError *error) {
                             
                             if (error) {
                                 completionBlock(error);
                             }
                             
                             else {
                                 completionBlock(nil);
                             }
                         }];
}

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

+ (void)addMessageWithSenderID:(NSString *)senderID
                   messageBody:(NSString *)messageBody {
    
    // Add message to the "messages" node
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *messagesReference = [rootReference child:@"messages"];
    FIRDatabaseReference *newMessageReference = [messagesReference childByAutoId];
    
    NSDictionary *messageInformation = @{@"senderID" : senderID,
                                         @"message body" : messageBody};
    
    [newMessageReference setValue:messageInformation];
    
    // Add message to a user's "messages" node
}

//    PMFirebaseClient *firebaseClient = [PMFirebaseClient new];
////    __block NSString *REFACTORTHIS = [NSString new];
//    NSDictionary *messageData = @{@"sender" : senderID,
//                                  @"receiver" : recipientUID,
//                                  @"text" : messageBody};
//    
//    // Adding the message to the 'chats' node
//    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
//    FIRDatabaseReference *allChatsReference = [rootReference child:@"chats"];
//        
//        [firebaseClient getCurrentUserChatsWithCompletion:^(NSDictionary *chats) {
//            
//            NSLog(@"chats: %@", chats);
//            NSLog(@"Datasource in get chats block: %@", messagesViewController.messages);
//            
//            if ([chats isKindOfClass:[NSNull class]]) {
//                
//                FIRDatabaseReference *currentChatReference = [allChatsReference child:messagesViewController.chatID];
//                FIRDatabaseReference *messagesReference = [currentChatReference child:@"messages"];
//                FIRDatabaseReference *newMessageReference = [messagesReference childByAutoId];
//                [newMessageReference setValue:messageData];
//                
////                REFACTORTHIS = currentChatReference.key;
////                messagesViewController.chatID = currentChatReference.key;
//                
////                [PMFirebaseClient observeNewMessagesInChatReference:currentChatReference
////                                             messagesViewController:messagesViewController];
//                
//                NSLog(@"Chat ID in the block: %@", messagesViewController.chatID);
//                
//                // Adding the message to the sender's node
//                FIRDatabaseReference *usersReference = [rootReference child:@"users"];
//                FIRDatabaseReference *currentUserReference = [usersReference child:senderID];
//                FIRDatabaseReference *currentUserChats = [currentUserReference child:@"chats"];
//                FIRDatabaseReference *currentSenderChatReference = [currentUserChats child:messagesViewController.chatID];
//                FIRDatabaseReference *userOppositeSender = [currentSenderChatReference child:@"other user"];
//                FIRDatabaseReference *currentUserMessagesReference = [currentSenderChatReference child:@"messages"];
//                FIRDatabaseReference *senderNewMessageReference = [currentUserMessagesReference childByAutoId];
//                
//                // Adding the message to the receiver's node
//                FIRDatabaseReference *receiverReference = [usersReference child:recipientUID];
//                FIRDatabaseReference *receiverChatsReference = [receiverReference child:@"chats"];
//                FIRDatabaseReference *currentReceiverChatReference = [receiverChatsReference child:messagesViewController.chatID];
//                FIRDatabaseReference *userOppositeReceiver = [currentReceiverChatReference child:@"other user"];
//                FIRDatabaseReference *receiverMessagesReference = [currentReceiverChatReference child:@"messages"];
//                FIRDatabaseReference *receiverNewMessageReference = [receiverMessagesReference childByAutoId];
//                
//                [userOppositeSender setValue:recipientUID];
//                [userOppositeReceiver setValue:senderID];
//                [senderNewMessageReference setValue:messageData];
//                [receiverNewMessageReference setValue:messageData];
//            }
//            
//            else {
//                
//                NSLog(@"Chats is not null");
//                
//                for (NSString *chatKey in chats) {
////                    NSDictionary *chat = chats[chatKey];
//                    if ([chatKey isEqualToString:messagesViewController.chatID] || [chatKey isEqualToString:[NSString stringWithFormat:@"%@%@", recipientUID, senderID]]) {
//                        
//                        NSLog(@"These two people already have a chat!");
//                        
//                        FIRDatabaseReference *currentChatReference = [allChatsReference child:messagesViewController.chatID];
//                        FIRDatabaseReference *messagesReference = [currentChatReference child:@"messages"];
//                        FIRDatabaseReference *newMessageReference = [messagesReference childByAutoId];
//                        [newMessageReference setValue:messageData];
//                        
////                        REFACTORTHIS = messagesViewController.chatID;
//                    }
//                    
//                    else {
//                        FIRDatabaseReference *currentChatReference = [allChatsReference childByAutoId];
//                        FIRDatabaseReference *messagesReference = [currentChatReference child:@"messages"];
//                        FIRDatabaseReference *newMessageReference = [messagesReference childByAutoId];
//                        [newMessageReference setValue:messageData];
//                        
////                        REFACTORTHIS = currentChatReference.key;
//                        messagesViewController.chatID = currentChatReference.key;
//                    }
//                    
//                    // Adding the message to the sender's node
//                    FIRDatabaseReference *usersReference = [rootReference child:@"users"];
//                    FIRDatabaseReference *currentUserReference = [usersReference child:senderID];
//                    FIRDatabaseReference *currentUserChats = [currentUserReference child:@"chats"];
//                    FIRDatabaseReference *currentSenderChatReference = [currentUserChats child:messagesViewController.chatID];
//                    FIRDatabaseReference *userOppositeSender = [currentSenderChatReference child:@"other user"];
//                    FIRDatabaseReference *currentUserMessagesReference = [currentSenderChatReference child:@"messages"];
//                    FIRDatabaseReference *senderNewMessageReference = [currentUserMessagesReference childByAutoId];
//                    
//                    // Adding the message to the receiver's node
//                    FIRDatabaseReference *receiverReference = [usersReference child:recipientUID];
//                    FIRDatabaseReference *receiverChatsReference = [receiverReference child:@"chats"];
//                    FIRDatabaseReference *currentReceiverChatReference = [receiverChatsReference child:messagesViewController.chatID];
//                    FIRDatabaseReference *userOppositeReceiver = [currentReceiverChatReference child:@"other user"];
//                    FIRDatabaseReference *receiverMessagesReference = [currentReceiverChatReference child:@"messages"];
//                    FIRDatabaseReference *receiverNewMessageReference = [receiverMessagesReference childByAutoId];
//                    
//                    [userOppositeSender setValue:recipientUID];
//                    [userOppositeReceiver setValue:senderID];
//                    [senderNewMessageReference setValue:messageData];
//                    [receiverNewMessageReference setValue:messageData];
//                }
//            }
//        }];
    // this was the else
//        FIRDatabaseReference *currentChatReference = [allChatsReference child:messagesViewController.chatID];
//        FIRDatabaseReference *messagesReference = [currentChatReference child:@"messages"];
//        FIRDatabaseReference *newMessageReference = [messagesReference childByAutoId];
//        [newMessageReference setValue:messageData];
//        
////        REFACTORTHIS = messagesViewController.chatID;
//    
//        // Adding the message to the sender's node
//        
//        NSLog(@"Adding to sender's node");
//        
//        FIRDatabaseReference *usersReference = [rootReference child:@"users"];
//        FIRDatabaseReference *currentUserReference = [usersReference child:senderID];
//        FIRDatabaseReference *currentUserChats = [currentUserReference child:@"chats"];
//        FIRDatabaseReference *currentSenderChatReference = [currentUserChats child:messagesViewController.chatID];
//        FIRDatabaseReference *userOppositeSender = [currentSenderChatReference child:@"other user"];
//        FIRDatabaseReference *currentUserMessagesReference = [currentSenderChatReference child:@"messages"];
//        FIRDatabaseReference *senderNewMessageReference = [currentUserMessagesReference childByAutoId];
//        
//        // Adding the message to the receiver's node
//        
//        NSLog(@"Adding to receiver's node");
//        
//        FIRDatabaseReference *receiverReference = [usersReference child:recipientUID];
//        FIRDatabaseReference *receiverChatsReference = [receiverReference child:@"chats"];
//        FIRDatabaseReference *currentReceiverChatReference = [receiverChatsReference child:messagesViewController.chatID];
//        FIRDatabaseReference *userOppositeReceiver = [currentReceiverChatReference child:@"other user"];
//        FIRDatabaseReference *receiverMessagesReference = [currentReceiverChatReference child:@"messages"];
//        FIRDatabaseReference *receiverNewMessageReference = [receiverMessagesReference childByAutoId];
//        
//        [userOppositeSender setValue:recipientUID];
//        [userOppositeReceiver setValue:senderID];
//        [senderNewMessageReference setValue:messageData];
//        [receiverNewMessageReference setValue:messageData];

+ (void)observeNewMessagesInViewController:(PMMessagesViewController *)messagesViewController
                           addToDataSource:(NSMutableArray *)dataSource {
    FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
    FIRDatabaseReference *messagesReference = [rootReference child:@"messages"];
    
    [messagesReference observeEventType:FIRDataEventTypeChildAdded
                              withBlock:^(FIRDataSnapshot *snapshot) {
                                  NSString *senderID = snapshot.value[@"senderID"];
                                  NSString *messageBody = snapshot.value[@"message body"];
                                  
                                  JSQMessage *message = [JSQMessage messageWithSenderId:senderID
                                                                            displayName:@""
                                                                                   text:messageBody];
                                  
                                  [dataSource addObject:message];
                                  [messagesViewController finishReceivingMessage];
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
