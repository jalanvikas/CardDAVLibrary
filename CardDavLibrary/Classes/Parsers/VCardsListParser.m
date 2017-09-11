//
//  VCardsListParser.m
//  CardDavLibrary
//
//  Created by Vikas Jalan on 2/2/16.
//  Copyright © 2016 Vikas Jalan. All rights reserved.
//

#import "VCardsListParser.h"
#import "ParserElements.h"
#import "CardDAVContactInfo.h"


@interface VCardsListParser () <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray *allContacts;
@property (nonatomic, strong) CardDAVContactInfo *contactInfo;
@property (nonatomic, strong) NSMutableString *workingElementString;
@property (nonatomic, strong) NSArray *elementsToParse;
@property (nonatomic, readwrite) BOOL storeCharacterData;
@property (nonatomic, strong) NSError *parserError;

@end

@implementation VCardsListParser

#pragma mark - Designated Initializer Methods

- (void)parseXMLData:(NSData  * _Nonnull )xmldata
                      completionHandler:( nullable void (^)(NSMutableArray * __nullable array, NSError * __nullable error))completionHandler
{
    _elementsToParse = @[kHrefElement, kStatusElement, kETagElement]; // set elements to parse
    _allContacts = [NSMutableArray array];
    _workingElementString = [NSMutableString string];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmldata];
    [parser setDelegate:self];
    [parser parse];
    
    completionHandler(_allContacts, _parserError);
}

#pragma mark - XML Parsing Delegates

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:kResponseElement])
    {
        self.contactInfo = [[CardDAVContactInfo alloc] init];
    }
    self.storeCharacterData = [self.elementsToParse containsObject:elementName];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (self.contactInfo != nil)
    {
        if (self.storeCharacterData)
        {
            NSString *trimmedString = [self.workingElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            [self.workingElementString setString:@""];  // clear the string for next time
            
            if ([elementName isEqualToString:kHrefElement])
            {
                self.contactInfo.vcardHRef = trimmedString;
            }
            else if ([elementName isEqualToString:kStatusElement])
            {
                self.contactInfo.status = trimmedString;
            }
            else if ([elementName isEqualToString:kETagElement])
            {
                self.contactInfo.eTag = trimmedString;
            }
        }
        if ([elementName isEqualToString:kResponseElement] && [self.contactInfo.eTag length])
        {
            [self.allContacts addObject:self.contactInfo];
            self.contactInfo = nil;
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.storeCharacterData)
    {
        [self.workingElementString appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    self.parserError = parseError;
}

@end
