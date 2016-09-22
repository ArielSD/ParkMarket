//
//  PMPayPalClient.h
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 9/22/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <CardIO.h>

@interface PMPayPalClient : NSObject

+ (void)storeCreditCard:(CardIOCreditCardInfo *)card;
+ (void)saveCard:(CardIOCreditCardInfo *)card WithAccessToken:(NSString *)accessToken;

@end
