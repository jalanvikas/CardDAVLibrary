//
//  CardDAVManager.m
//  CardDAV4iOS
//
//  Created by Vikas Jalan on 1/13/16.
//  Copyright © 2016 Vikas Jalan. All rights reserved.
//

#import "CardDAVManager.h"
#import "CardDAVRequestHelper.h"

@interface CardDAVManager ()

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *baseURL;

@property (nonatomic, copy) NSString *response;
@property (nonatomic, copy) NSString *errorInfo;

#pragma mark - Private Methods

- (NSString *)getURLForFullCardDAVSync;

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

- (NSString *)getURLForFullCardDAVSync
{
    return [NSString stringWithFormat:@"%@/dav/%@/Contacts/", self.baseURL, self.userName];
}

- (void)startSyncing
{
    self.errorInfo = nil;
    self.response = nil;
    
    CardDAVRequestHelper *requestHelper = [CardDAVRequestHelper requestHelperForFullCardDAVInfoForUserName:self.userName password:self.password url:[self getURLForFullCardDAVSync] completion:^(NSURLResponse *response, id responseObject, NSError *error)
    {
        if (error)
        {
            self.errorInfo = [NSString stringWithFormat:@"Error: %@", error];
            [[NSNotificationCenter defaultCenter] postNotificationName:CARD_DAV_SYNC_FAILED_NOTIFICATION object:nil];
        }
        else if ((nil != response) && ([response isKindOfClass:[NSHTTPURLResponse class]]) && (401 == [(NSHTTPURLResponse *)response statusCode]))
        {
            self.errorInfo = @"Invalid Username/Password";
            [[NSNotificationCenter defaultCenter] postNotificationName:CARD_DAV_SYNC_FAILED_NOTIFICATION object:nil];
        }
        else if ([responseObject isKindOfClass:[NSData class]])
        {
            self.response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            [[NSNotificationCenter defaultCenter] postNotificationName:CARD_DAV_SYNC_COMPLETED_NOTIFICATION object:nil];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CARD_DAV_SYNC_STARTED_NOTIFICATION object:nil];
    [requestHelper startRequest];
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

- (NSString *)getResponse
{
    return self.response;
}

- (NSString *)getErrorInfo
{
    return self.errorInfo;
}

@end
