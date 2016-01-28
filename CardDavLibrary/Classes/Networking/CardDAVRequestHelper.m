//
//  CardDAVRequestHelper.m
//  CardDavLibrary
//
//  Created by Vikas Jalan on 1/25/16.
//  Copyright © 2016 Vikas Jalan. All rights reserved.
//

#import "CardDAVRequestHelper.h"
#import "AFURLRequestSerialization.h"
#import "AFURLSessionManager.h"
#import "CardDAVContactInfo+Private.h"

typedef enum
{
    eFullCardDAVRequest = 0,
    eGetVCardInfoRequest,
    eAddVCardInfoRequest,
    eUpdateVCardInfoRequest,
    eDeleteVCardInfoRequest,
}RequestMethodType;

#define REQUEST_METHOD_TYPE     [NSArray arrayWithObjects:@"PROPFIND", @"GET", @"PUT", @"PUT", @"DELETE", nil]

@interface CardDAVRequestHelper ()

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) RequestMethodType requestType;
@property (nonatomic, strong) CardDAVContactInfo *contactInfo;

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
    
    requestHelper.requestType = eFullCardDAVRequest;
    
    return requestHelper;
}

+ (id)requestHelperForVCardInfoForUserName:(NSString *)userName
                                  password:(NSString *)password
                                       url:(NSString *)url
                                completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completion
{
    CardDAVRequestHelper *requestHelper = [[CardDAVRequestHelper alloc] initWithUserName:userName
                                                                                password:password
                                                                                     url:url
                                                                              completion:completion];
    
    requestHelper.requestType = eGetVCardInfoRequest;
    
    return requestHelper;
}

+ (id)requestHelperForAddVCardInfoForUserName:(NSString *)userName
                                     password:(NSString *)password
                                          url:(NSString *)url
                                    vCardInfo:(CardDAVContactInfo *)contactInfo
                                   completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completion
{
    CardDAVRequestHelper *requestHelper = [[CardDAVRequestHelper alloc] initWithUserName:userName
                                                                                password:password
                                                                                     url:url
                                                                              completion:completion];
    
    requestHelper.requestType = eAddVCardInfoRequest;
    requestHelper.contactInfo = contactInfo;
    
    return requestHelper;
}

+ (id)requestHelperForUpdateVCardInfoForUserName:(NSString *)userName
                                        password:(NSString *)password
                                             url:(NSString *)url
                                       vCardInfo:(CardDAVContactInfo *)contactInfo
                                      completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completion
{
    CardDAVRequestHelper *requestHelper = [[CardDAVRequestHelper alloc] initWithUserName:userName
                                                                                password:password
                                                                                     url:url
                                                                              completion:completion];
    
    requestHelper.requestType = eUpdateVCardInfoRequest;
    requestHelper.contactInfo = contactInfo;
    
    return requestHelper;
}

+ (id)requestHelperForDeleteVCardInfoForUserName:(NSString *)userName
                                        password:(NSString *)password
                                             url:(NSString *)url
                                       vCardInfo:(CardDAVContactInfo *)contactInfo
                                      completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completion
{
    CardDAVRequestHelper *requestHelper = [[CardDAVRequestHelper alloc] initWithUserName:userName
                                                                                password:password
                                                                                     url:url
                                                                              completion:completion];
    
    requestHelper.requestType = eDeleteVCardInfoRequest;
    requestHelper.contactInfo = contactInfo;
    
    return requestHelper;
}

#pragma mark - Custom Methods

- (void)startRequest
{
    NSURL *url = [NSURL URLWithString:self.url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    if (eFullCardDAVRequest == self.requestType)
        [request setValue:@"1" forHTTPHeaderField:@"Depth"];
    
    if (eAddVCardInfoRequest == self.requestType)
        [request setValue:[self.contactInfo UID] forHTTPHeaderField:@"If-None-Match"];
    
    if ((eUpdateVCardInfoRequest == self.requestType) || (eDeleteVCardInfoRequest == self.requestType))
        [request setValue:[self.contactInfo eTag] forHTTPHeaderField:@"If-Match"];
    
    [request setHTTPMethod:[REQUEST_METHOD_TYPE objectAtIndex:self.requestType]];
    
    if ((eAddVCardInfoRequest == self.requestType) || (eUpdateVCardInfoRequest == self.requestType))
        [request setHTTPBody:[[self.contactInfo getVCardInfoForServerRequest] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Adding Authorization
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
