//
//  CardDAVRequestHelper.m
//  CardDAV4iOS
//
//  Created by Vikas Jalan on 1/25/16.
//  Copyright © 2016 Vikas Jalan. All rights reserved.
//

#import "CardDAVRequestHelper.h"
#import "AFURLRequestSerialization.h"
#import "AFURLSessionManager.h"

@interface CardDAVRequestHelper ()

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL isFullCardDAVRequest;

@property (nonatomic, copy) void (^CardDAVRequestCompletionHandler)(NSURLResponse *response, id responseObject, NSError *error);

#pragma mark - Private Methods

- (id)initWithUserName:(NSString *)userName
              password:(NSString *)password
                   url:(NSString *)url
            completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completion;

@end

@implementation CardDAVRequestHelper

#pragma mark - Private Methods

- (id)initWithUserName:(NSString *)userName
              password:(NSString *)password
                   url:(NSString *)url
            completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completion
{
    self = [super init];
    if (self)
    {
        self.userName = userName;
        self.password = password;
        self.url = url;
        self.CardDAVRequestCompletionHandler = completion;
    }
    
    return self;
}

#pragma mark - Initializer Methods

+ (id)requestHelperForFullCardDAVInfoForUserName:(NSString *)userName
                                        password:(NSString *)password
                                             url:(NSString *)url
                                      completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completion
{
    CardDAVRequestHelper *requestHelper = [[CardDAVRequestHelper alloc] initWithUserName:userName
                                                                                password:password
                                                                                     url:url
                                                                              completion:completion];
    
    requestHelper.isFullCardDAVRequest = YES;
    
    return requestHelper;
}

+ (id)requestHelperForVCardInfoForUserName:(NSString *)userName
                                  password:(NSString *)password
                                       url:(NSString *)url
                                completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completion
{
    return [[CardDAVRequestHelper alloc] initWithUserName:userName
                                                 password:password
                                                      url:url
                                               completion:completion];
}

#pragma mark - Custom Methods

- (void)startRequest
{
    NSURL *url = [NSURL URLWithString:self.url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    if (self.isFullCardDAVRequest)
        [request setValue:@"1" forHTTPHeaderField:@"Depth"];
    
    [request setHTTPMethod:((self.isFullCardDAVRequest)?@"PROPFIND":@"GET")];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", self.userName, self.password];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    [manager setIgnoreSerializerForResponse:YES];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (self.CardDAVRequestCompletionHandler != NULL)
        {
            self.CardDAVRequestCompletionHandler(response, responseObject, error);
        }
    }];
    
    [dataTask resume];
}

@end
