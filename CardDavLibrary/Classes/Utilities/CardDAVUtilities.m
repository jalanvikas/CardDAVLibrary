//
//  CardDAVUtilities.m
//  CardDavLibrary
//
//  Created by Vikas Jalan on 1/28/16.
//  Copyright © 2016 Vikas Jalan. All rights reserved.
//

#import "CardDAVUtilities.h"

@implementation CardDAVUtilities

+ (NSString *)getBodyForFullCardDAVRequest
{
    return @"<d:propfind xmlns:d=\"DAV:\"><d:prop><d:getetag/></d:prop></d:propfind>";
}

+ (NSString *)getSyncTokenCardDAVRequest
{
    return @"<d:propfind xmlns:d=\"DAV:\" xmlns:cs=\"http://calendarserver.org/ns/\"><d:prop><cs:getctag /><d:sync-token /></d:prop></d:propfind>";
}

+ (NSString *)getBodyForChangesCardDAVRequest
{
    return @"<d:sync-collection xmlns:d=\"DAV:\"><d:sync-token>https://www.googleapis.com/carddav/v1/synctoken/0801100118A0A281C9B5D6CA02</d:sync-token><d:sync-level>1</d:sync-level><d:prop><d:getetag/></d:prop></d:sync-collection>";
}

+ (NSString *)getVCardInfoForServerRequest
{
    return @"BEGIN:VCARD\nVERSION:3.0\nFN:Vikas Jalan\nN:Jalan;Vikas;;;\nTEL;TYPE=home,voice:9620160238\nUID:f4e3b633-8fb0-4d4f-af9c-24ac6de98fe9\nEND:VCARD";
}

@end
