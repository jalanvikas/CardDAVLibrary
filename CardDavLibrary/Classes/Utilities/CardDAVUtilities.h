//
//  CardDAVUtilities.h
//  CardDavLibrary
//
//  Created by Vikas Jalan on 1/28/16.
//  Copyright © 2016 Vikas Jalan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardDAVUtilities : NSObject

+ (NSString *)getBodyForFullCardDAVRequest;

+ (NSString *)getSyncTokenCardDAVRequest;

+ (NSString *)getBodyForChangesCardDAVRequest;

+ (NSString *)getVCardInfoForServerRequest;

@end
