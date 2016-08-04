//
//  PMFirebaseClient.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 8/2/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMFirebaseClient.h"

@implementation PMFirebaseClient

+ (void)createUserWithEmail:(NSString *)email password:(NSString *)password {
    [[FIRAuth auth] createUserWithEmail:email
                               password:password
                             completion:^(FIRUser *user, NSError *error) {
                                 NSLog(@"User's ID: %@", user.uid);
                                 
                                 NSDictionary *userInformation = @{@"email" : email};
                                 
                                 FIRDatabaseReference *rootReference = [[FIRDatabase database] reference];
                                 FIRDatabaseReference *usersReference = [rootReference child:@"users"];
                                 FIRDatabaseReference *newUserReference = [usersReference child:user.uid];
                                 [newUserReference setValue:userInformation];
                             }];
}

@end
