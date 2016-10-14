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

@class PMMessagesViewController;

@protocol PMMessagesViewControllerDelegate <NSObject>

@required

- (void)willDismissPMMessagesViewController:(PMMessagesViewController *)messagesViewController;

@end

@interface PMMessagesViewController : JSQMessagesViewController

@property (weak, nonatomic) id <PMMessagesViewControllerDelegate> delegate;

@end
