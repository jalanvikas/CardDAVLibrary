//
//  VCardsListParser.h
//  CardDavLibrary
//
//  Created by Vikas Jalan on 2/2/16.
//  Copyright © 2016 Vikas Jalan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCardsListParser : NSObject

#pragma mark - Designated Initializer Methods

- (void)parseXMLData:(NSData  * _Nonnull )xmldata
                      completionHandler:( nullable void (^)(NSMutableArray * __nullable array, NSError * __nullable error))completionHandler;

@end
