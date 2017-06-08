//
//  PMMessagesViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 9/27/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMMessagesViewController.h"

@interface PMMessagesViewController ()

@property (strong, nonatomic) UIBarButtonItem *doneButton;
@property (strong, nonatomic) UIBarButtonItem *parkButton;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageView;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageView;

@end

@implementation PMMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [PMFirebaseClient observeNewMessagesInViewController:self];
    
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    [self configureMessageBubbles];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Init Method Override

- (instancetype)initWithParkingSpot:(PMParkingSpot *)parkingSpot {
    self = [super init];
    if (self) {
        _messages = [NSMutableArray new];
        
        self.senderId = [FIRAuth auth].currentUser.uid;
        self.senderDisplayName = @"senderDisplayName";
        self.title = parkingSpot.ownerFirstName;
        _parkingSpot = parkingSpot;
        _receiverID = parkingSpot.ownerUID;
        _chatID = [self generateChatID];
        
        [self configureNavigationItems];
    }
    return self;
}

- (instancetype)initWithChat:(PMChat *)chat {
    self = [super init];
    if (self) {
        
        _messages = chat.messages;
        _chatID = chat.id;
//        _receiverID = 
        self.senderId = [FIRAuth auth].currentUser.uid;
        self.senderDisplayName = @"senderDisplayName";
        self.title = @"Title";

//        [PMFirebaseClient getMessagesInChat:chat
//                                    success:^(NSArray *messages) {
//                                        _messages = messages.copy;
//                                    }
//                                    failure:^(NSError *error) {
//                                        NSLog(@"Error: %@", error);
//                                    }];
        
        [self configureNavigationItems];
    }
    return self;
}

#pragma mark - UI Layout

- (void)configureNavigationItems {
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneButtonTapped)];
    
    self.parkButton = [[UIBarButtonItem alloc] initWithTitle:@"Park"
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(parkButtonTapped)];
    
    self.navigationItem.rightBarButtonItem = self.doneButton;
    self.navigationItem.leftBarButtonItem = self.parkButton;
}

- (void)configureMessageBubbles {
    JSQMessagesBubbleImageFactory *factory = [JSQMessagesBubbleImageFactory new];
    self.incomingBubbleImageView = [factory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.outgoingBubbleImageView = [factory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
}

#pragma mark - UICollectionViewDataSource Protocol Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.messages.count;
}

#pragma mark - UICollectionView Delegate Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesCollectionViewCell *cell = [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    JSQMessage *message = self.messages[indexPath.item];
    
    if ([message.senderId isEqualToString:[FIRAuth auth].currentUser.uid]) {
        cell.textView.textColor = [UIColor whiteColor];
    }
    
    else {
        cell.textView.textColor = [UIColor blackColor];
    }
    
    return cell;
}

#pragma mark - JSQMessagesCollectionViewDataSource Protocol Methods

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.messages[indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = self.messages[indexPath.item];
    
    if ([message.senderId isEqualToString:[FIRAuth auth].currentUser.uid]) {
        return  self.outgoingBubbleImageView;
    }
    
    else {
        return self.incomingBubbleImageView;
    }
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - Responder Methods

- (void)doneButtonTapped {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)parkButtonTapped {
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"parkTappedInMessagesViewController"
                                                                                     object:self
                                                                                   userInfo:@{@"parkingSpotInMessagesViewController" : self.parkingSpot.identifier}];
                             }];
}

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date {
    [PMFirebaseClient addMessageFromMessagesViewController:self
                                                  receiver:self.receiverID
                                               messageBody:text];
    
    [self finishSendingMessage];
}

#pragma mark - Helper Methods

- (NSString *)generateChatID {
    NSString *senderID = [FIRAuth auth].currentUser.uid;
    NSString *receiverID = self.receiverID;
    
    NSArray *userIDArray = @[senderID, receiverID];
    NSSortDescriptor *uidSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil
                                                                        ascending:YES];
    
    NSArray *sortedUIDs = [userIDArray sortedArrayUsingDescriptors:@[uidSortDescriptor]];
    NSString *alphabeticalChatID = [NSString stringWithFormat:@"%@%@%@", sortedUIDs.firstObject, sortedUIDs.lastObject, self.parkingSpot.identifier];
    return alphabeticalChatID;
}

@end
