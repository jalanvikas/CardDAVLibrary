//
//  CardDAVManager.h
//  CardDAV4iOS
//
//  Created by Vikas Jalan on 1/13/16.
//  Copyright © 2016 Vikas Jalan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface CardDAVManager : NSObject

#pragma mark - Singleton Method

+ (CardDAVManager *)sharedInstance;

#pragma mark - Custom Method

- (void)startSyncingForUserName:(NSString *)userName withPassword:(NSString *)password baseURL:(NSString *)baseURL;

- (void)reset;

@end
