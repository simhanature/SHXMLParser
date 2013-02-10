//
//  SHXMLParser.h
//  Sample for SHXML Parser
//
//  Created by Narasimharaj on 09/02/13.
//  Copyright (c) 2013 SimHa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHXMLParser : NSObject <NSXMLParserDelegate>
{
    
    NSMutableArray *dataItems;
    NSMutableDictionary* dataItem;
    NSMutableString *currentParsedCharacterData;
    NSString* rootElement;
    NSString* itemElement;
    NSString* arrayElement;
    NSArray* itemVariables;
}

@property (nonatomic, retain) NSMutableArray *dataItems;
@property (nonatomic, retain) NSMutableDictionary *dataItem;
@property (nonatomic, retain) NSMutableString *currentParsedCharacterData;
@property (nonatomic, retain) NSString *rootElement;
@property (nonatomic, retain) NSString *arrayElement;
@property (nonatomic, retain) NSString *itemElement;
@property (nonatomic, retain) NSArray *itemVariables;

+ (NSMutableArray *) convertDictionary:(NSMutableArray *) dictionaryArray toObjectArrayWithClassName:(NSString *)className classVariables:(NSArray *)classVariables;

-(NSMutableArray *) parseData:(NSData *)XMLData withArrayPath:(NSString *)arrayPath andItemKeys:(NSArray *)itemKeys;
- (void)clearIntermediateParserVariables;





@end
