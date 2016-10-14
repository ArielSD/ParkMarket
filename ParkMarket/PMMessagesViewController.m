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

@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageView;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageView;

@end

@implementation PMMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messages = [NSMutableArray new];
    
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    NSLog(@"View Did Load");
    
    [self configureNavigationItems];
    
    [self setUpBubbles];
    
    [self addMessageWithID:@"foo"
                      text:@"Hey Person!"];
    [self finishReceivingMessage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Did receive memory warning");
}

#pragma mark - UI Layout

- (void)configureNavigationItems {
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneButtonTapped)];
    
    self.navigationItem.rightBarButtonItem = self.doneButton;

}

#pragma mark - Protocol Methods

- (void)doneButtonTapped {
    [self.delegate willDismissPMMessagesViewController:self];
}

#pragma mark - UICollectionViewDataSource Protocol Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSLog(@"Self.messages.count: %lu", self.messages.count);
    
    return self.messages.count;
}

#pragma mark - JSQMessagesCollectionViewDataSource Protocol Methods

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.messages[indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = self.messages[indexPath.item];
    
    if ([message.senderId isEqualToString:@"Sender ID"]) {
        return  self.outgoingBubbleImageView;
    }
    else {
        return self.incomingBubbleImageView;
    }
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - Testing

- (void)addMessageWithID:(NSString *)id text:(NSString *)text {
    
    NSLog(@"Add message called");
    
    JSQMessage *message = [JSQMessage messageWithSenderId:id
                                              displayName:@""
                                                     text:text];
    
    [self.messages addObject:message];
    
    NSLog(@"Self.messages.count in addMessage: %lu", self.messages.count);
}

- (void)setUpBubbles {
    JSQMessagesBubbleImageFactory *factory = [JSQMessagesBubbleImageFactory new];
    self.incomingBubbleImageView = [factory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.outgoingBubbleImageView = [factory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
}

@end
