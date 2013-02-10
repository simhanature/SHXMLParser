//
//  SHXMLParser.m
//  Sample for SHXML Parser
//
//  Created by Narasimharaj on 09/02/13.
//  Copyright (c) 2013 SimHa. All rights reserved.
//

#import "SHXMLParser.h"

@implementation SHXMLParser

@synthesize dataItems, dataItem, currentParsedCharacterData;
@synthesize rootElement, arrayElement, itemElement, itemVariables;

+ (NSMutableArray *) convertDictionary:(NSMutableArray *) dictionaryArray toObjectArrayWithClassName:(NSString *)className classVariables:(NSArray *)classVariables
{
    NSMutableArray* objectArray = [NSMutableArray array];
    for (NSDictionary *dict in dictionaryArray) {
        id object = [[[NSClassFromString(className) alloc] init] autorelease];
        for (NSString* variable in classVariables) {
            [object setValue:[dict objectForKey:variable] forKey:variable];
        }
        [objectArray addObject:object];
    }
    return objectArray;
}

-(NSMutableArray *) parseData:(NSData *)XMLData withArrayPath:(NSString *)arrayPath andItemKeys:(NSArray *)itemKeys {
    
    NSArray* pathArray = [arrayPath componentsSeparatedByString:@"."];
    self.rootElement = [pathArray objectAtIndex:0];
    self.arrayElement = [pathArray objectAtIndex:[pathArray count]-2];
    self.itemElement = [pathArray objectAtIndex:[pathArray count]-1];
    self.itemVariables = itemKeys;
    
    NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:XMLData] autorelease];
    
	[parser setDelegate:self];
    
	if ([parser parse] == YES)
	{
        return self.dataItems;
    }
    else    {
        
    }
    return nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentParsedCharacterData = [NSMutableString string];

    if([elementName isEqualToString:self.rootElement])
	{
        self.dataItems = [[[NSMutableArray alloc] init] autorelease] ;
    }
    if([elementName isEqualToString:self.itemElement])
	{
        self.dataItem = [NSMutableDictionary dictionaryWithDictionary:attributeDict];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:self.itemElement])
	{
		[self.dataItems addObject:self.dataItem];
	}
    else {
        for (NSString* key in self.itemVariables) {
            if([elementName isEqualToString:key])
            {
                [self.dataItem setObject:self.currentParsedCharacterData forKey:key];
            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	[self.currentParsedCharacterData appendString:string];
}

- (void)clearIntermediateParserVariables
{
    self.dataItems = nil;
}


@end
