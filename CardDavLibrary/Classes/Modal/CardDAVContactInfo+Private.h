//
//  CardDAVContactInfo+Private.h
//  CardDavLibrary
//
//  Created by Vikas Jalan on 1/27/16.
//  Copyright © 2016 Vikas Jalan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardDAVContactInfo.h"

@interface CardDAVContactInfo (Private)

#pragma mark - Private Methods

- (NSString *)getVCardInfoForServerRequest;

- (void)updateVCardInfoWithServerResponse:(NSString *)serverResponse;

@end
