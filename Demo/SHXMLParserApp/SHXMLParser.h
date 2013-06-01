//
//  SHXMLParser.h
//  SHXMLParser
//
//  Created by Narasimharaj on 09/02/13.
//  Copyright (c) 2013 SimHa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHXMLParser : NSObject <NSXMLParserDelegate>

+ (NSArray *)convertDictionaryArray:(NSArray *)dictionaryArray toObjectArrayWithClassName:(NSString *)className classVariables:(NSArray *)classVariables;
+ (id)getDataAtPath:(NSString *)path fromResultObject:(NSDictionary *)resultObject;

- (NSDictionary *)parseData:(NSData *)XMLData;

@end