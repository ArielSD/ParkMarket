//
//  PMPayPalClient.m
//  ParkMarket
//
//  Created by Ariel Scott-Dicker on 9/22/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "PMPayPalClient.h"

@implementation PMPayPalClient

+ (void)storeCreditCard:(CardIOCreditCardInfo *)card {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer new];
    
    NSString *payPalURLString = @"https://api.sandbox.paypal.com/v1/oauth2/token";
    NSString *clientID = @"Aa6s3b1XPLRsiGFwtN_OGDcsQLFVy1OwbrtQZrhK9JB9nKYkSwcfBHCegLK6tYPDEi2WQd-nC0xk7s1M";
    NSString *secret = @"EK9j96pAmT6LoBSLLYgtbsqOVTMT-oveF-uwoxHBvUPruI5vFgrgrwzFNSDWNtWNC58A5qapcepR1Ii_";
    
    NSDictionary *payloadDictionary = @{@"grant_type" : @"client_credentials"};
    
    [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [sessionManager.requestSerializer setValue:@"en_US" forHTTPHeaderField:@"Accept-Language"];
    [sessionManager.requestSerializer setAuthorizationHeaderFieldWithUsername:clientID
                                                                     password:secret];
    
    [sessionManager POST:payPalURLString
              parameters:payloadDictionary
                progress:nil
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     NSDictionary *accessTokenDictionary = responseObject;
                     NSString *accessToken = accessTokenDictionary[@"access_token"];
                     
                     [PMPayPalClient saveCard:card WithAccessToken:accessToken];
                 }
                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                     NSLog(@"Error: %@", error);
                 }];
}

+ (void)saveCard:(CardIOCreditCardInfo *)card WithAccessToken:(NSString *)accessToken {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer new];
    
    NSString *payPalURLString = @"https://api.sandbox.paypal.com/v1/vault/credit-cards";
    
    NSString *cardType = [CardIOCreditCardInfo displayStringForCardType:card.cardType usingLanguageOrLocale:nil];
    NSString *expiryMonth = [NSString stringWithFormat:@"%lu", card.expiryMonth];
    NSString *expiryYear = [NSString stringWithFormat:@"%lu", card.expiryYear];
    
    NSDictionary *payloadDictionary = @{@"number" : card.cardNumber,
                                        @"type" : cardType,
                                        @"expire_month" : expiryMonth,
                                        @"expire_year" : expiryYear
                                        };
    
    [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", accessToken] forHTTPHeaderField:@"Authorization"];
    
    [sessionManager POST:payPalURLString
              parameters:payloadDictionary
                progress:nil
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     NSLog(@"Success! %@", responseObject);
                 }
                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                     NSLog(@"Card Not Saved: %@", error);
                 }];
}

@end
