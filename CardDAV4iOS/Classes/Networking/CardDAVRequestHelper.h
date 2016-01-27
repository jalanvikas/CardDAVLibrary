//
//  CardDAVRequestHelper.h
//  CardDAV4iOS
//
//  Created by Vikas Jalan on 1/25/16.
//  Copyright © 2016 Vikas Jalan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardDAVRequestHelper : NSObject

#pragma mark - Initializer Methods

+ (id)requestHelperForFullCardDAVInfoForUserName:(NSString *)userName
                                        password:(NSString *)password
                                             url:(NSString *)url
                                      completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completion;

+ (id)requestHelperForVCardInfoForUserName:(NSString *)userName
                                  password:(NSString *)password
                                       url:(NSString *)url
                                completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completion;

+ (id)requestHelperForAddVCardInfoForUserName:(NSString *)userName
                                     password:(NSString *)password
                                          url:(NSString *)url
                                    vCardInfo:(CardDAVContactInfo *)contactInfo
                                   completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completion;

+ (id)requestHelperForUpdateVCardInfoForUserName:(NSString *)userName
                                        password:(NSString *)password
                                             url:(NSString *)url
                                       vCardInfo:(CardDAVContactInfo *)contactInfo
                                      completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completion;

+ (id)requestHelperForDeleteVCardInfoForUserName:(NSString *)userName
                                        password:(NSString *)password
                                             url:(NSString *)url
                                       vCardInfo:(CardDAVContactInfo *)contactInfo
                                      completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completion;

#pragma mark - Custom Methods

- (void)startRequest;

@end
