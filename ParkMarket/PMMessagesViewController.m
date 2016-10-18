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
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageView;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageView;

@property BOOL isObservingMessages;

@end

@implementation PMMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self generateChatID];
    
    [PMFirebaseClient observeNewMessagesInViewController:self];
    
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    [self configureMessageBubbles];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Did receive memory warning");
}

#pragma mark - Init Method

- (instancetype)init {
    self = [super init];
    if (self) {
        _messages = [NSMutableArray new];
        [self configureNavigationItems];
    }
    return self;
}

#pragma mark - UI Layout

- (void)configureNavigationItems {
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneButtonTapped)];
    
    self.navigationItem.rightBarButtonItem = self.doneButton;

}

- (void)configureMessageBubbles {
    JSQMessagesBubbleImageFactory *factory = [JSQMessagesBubbleImageFactory new];
    self.incomingBubbleImageView = [factory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.outgoingBubbleImageView = [factory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
}

#pragma mark - Protocol Methods

- (void)doneButtonTapped {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"doneButtonTappedInMessagesViewController"
                                                        object:self];
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

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date {
    [PMFirebaseClient addMessageFromMessagesViewController:self
                                               messageBody:text];
    
    [self finishSendingMessage];
}

#pragma mark - Helper Methods

- (void)generateChatID {
    NSString *senderID = [FIRAuth auth].currentUser.uid;
    NSString *receiverID = self.recipient;
    
    NSArray *userIDArray = @[senderID, receiverID];
    NSSortDescriptor *uidSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil
                                                                        ascending:YES];
    
    NSArray *sortedUIDs = [userIDArray sortedArrayUsingDescriptors:@[uidSortDescriptor]];
    NSString *alphabeticalChatID = [NSString stringWithFormat:@"%@%@%@", sortedUIDs.firstObject, sortedUIDs.lastObject, self.parkingSpot.identifier];
    self.chatID = alphabeticalChatID;
}

@end
