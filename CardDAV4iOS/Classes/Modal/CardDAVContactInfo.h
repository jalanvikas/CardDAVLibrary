//
//  CardDAVContactInfo.h
//  CardDAV4iOS
//
//  Created by Vikas Jalan on 1/14/16.
//  Copyright © 2016 Vikas Jalan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardDAVContactInfo : NSObject

@property (nonatomic, copy) NSString *vcardVersion;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *additionalName;
@property (nonatomic, copy) NSString *namePrefix;
@property (nonatomic, copy) NSString *nameSuffix;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *note;

@end
