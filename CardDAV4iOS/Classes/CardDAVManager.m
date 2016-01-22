//
//  CardDAVManager.m
//  CardDAV4iOS
//
//  Created by Vikas Jalan on 1/13/16.
//  Copyright © 2016 Vikas Jalan. All rights reserved.
//

#import "CardDAVManager.h"
#import "AFURLRequestSerialization.h"
#import "AFURLSessionManager.h"

@interface CardDAVManager ()

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *baseURL;

#pragma mark - Private Methods

- (void)startSyncing;

@end



@implementation CardDAVManager

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    
    return self;
}

#pragma mark - Singleton Method

+ (CardDAVManager *)sharedInstance
{
    static CardDAVManager *_manager = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        _manager = [[CardDAVManager alloc] init];
    });
    
    return _manager;
}

#pragma mark - Private Methods

- (void)startSyncing
{
    NSURL *url = [NSURL URLWithString:self.baseURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"1" forHTTPHeaderField:@"Depth"];
    [request setHTTPMethod:@"PROPFIND"];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", self.userName, self.password];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    [dataTask resume];
    
}

#pragma mark - Custom Method

- (void)startSyncingForUserName:(NSString *)userName withPassword:(NSString *)password baseURL:(NSString *)baseURL
{
    self.userName = userName;
    self.password = password;
    self.baseURL = baseURL;
    
    [self startSyncing];
}

- (void)reset
{
    self.userName = nil;
    self.password = nil;
    self.baseURL = nil;
}

@end
