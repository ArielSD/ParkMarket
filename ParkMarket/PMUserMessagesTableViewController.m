//
//  PMUserMessagesTableViewController.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 10/19/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMUserMessagesTableViewController.h"
#import "PMMessagesViewController.h"
#import "PMChat.h"

@interface PMUserMessagesTableViewController ()

@property (strong, nonatomic) NSArray <PMChat *> *chats;

@property (strong, nonatomic) UIBarButtonItem *doneButton;

@end

@implementation PMUserMessagesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"userMessageTableViewCell"];
    
    self.chats = [NSMutableArray new];
    [self getCurrentUserChats];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Init Method Override

- (instancetype)init {
    self = [super init];
    if (self) {
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

#pragma mark - Tableview Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chats.count;
}

#pragma mark - Tableview Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userMessageTableViewCell" forIndexPath:indexPath];
    PMChat *chat = self.chats[indexPath.row];
    cell.textLabel.text = chat.id;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PMMessagesViewController *messagesViewController = [[PMMessagesViewController alloc] initWithChat:self.chats[indexPath.row]];
    [self.navigationController pushViewController:messagesViewController animated:YES];
}

#pragma mark - Network Call

- (void)getCurrentUserChats {
    [PMFirebaseClient getCurrentUserChats:^(NSArray *chats) {
        self.chats = chats;
        [self.tableView reloadData];
    }
                                  failure:^(NSError *error) {
                                      NSLog(@"Error: %@", error);
                                  }];
}

#pragma mark - Responder Methods

- (void)doneButtonTapped {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - Helper Methods

- (void)noCurrentUserChats {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hmmm..."
                                                                             message:@"You don't have any chats!"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [self dismissViewControllerAnimated:YES
                                                                                completion:nil];
                                                   }];
    
    [alertController addAction:action];
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

@end
