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
@synthesize currentDepth;
@synthesize lastRemovedItem;
@synthesize resultObject, currentItem;

+ (NSMutableArray *)convertDictionary:(NSMutableArray *)dictionaryArray toObjectArrayWithClassName:(NSString *)className classVariables:(NSArray *)classVariables
{
	NSMutableArray *objectArray = [NSMutableArray array];

	for (NSDictionary *dict in dictionaryArray) {
		id object = [[NSClassFromString (className)alloc] init];

		for (NSString *variable in classVariables) {
			[object setValue:[dict objectForKey:variable] forKey:variable];
		}

		[objectArray addObject:object];
	}

	return objectArray;
}

- (NSMutableArray *)parseData:(NSData *)XMLData withArrayPath:(NSString *)arrayPath andItemKeys:(NSArray *)itemKeys
{
	self.currentDepth	= [NSMutableArray array];
	self.resultObject	= [NSMutableDictionary dictionary];

	NSArray *pathArray = [arrayPath componentsSeparatedByString:@"."];

	self.rootElement	= [pathArray objectAtIndex:0];
	self.arrayElement	= [pathArray objectAtIndex:[pathArray count] - 2];
	self.itemElement	= [pathArray objectAtIndex:[pathArray count] - 1];
	self.itemVariables	= itemKeys;

	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:XMLData];

	[parser setDelegate:self];

	if ([parser parse] == YES)
		return self.dataItems;
	else
	{}
	return nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if (![[self.currentDepth lastObject] isEqualToString:elementName])
	{
		[self.currentDepth addObject:elementName];

		if ([self.currentDepth count] > 1)
		{
			NSString *arrayPath = [NSString stringWithFormat:@"%@[]", [self.currentDepth componentsJoinedByString:@"."]];

			if ([self.resultObject objectForKey:arrayPath] == nil)
				[self.resultObject setObject:[NSMutableArray array] forKey:arrayPath];
		}
	}

	NSString *objectPath = [self.currentDepth componentsJoinedByString:@"."];
	[self.resultObject setObject:[NSMutableDictionary dictionaryWithDictionary:attributeDict] forKey:objectPath];

	self.currentParsedCharacterData = [NSMutableString string];

	if ([elementName isEqualToString:self.rootElement])
		self.dataItems = [[NSMutableArray alloc] init];

	if ([elementName isEqualToString:self.itemElement])
		self.dataItem = [NSMutableDictionary dictionaryWithDictionary:attributeDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	NSString			*arrayPath		= [NSString stringWithFormat:@"%@[]", [self.currentDepth componentsJoinedByString:@"."]];
	NSMutableArray		*currentArray	= [self.resultObject objectForKey:arrayPath];
	NSMutableDictionary *currentDict	= [self.resultObject objectForKey:[self.currentDepth componentsJoinedByString:@"."]];

	if (currentDict != nil)
		[currentArray addObject:[currentDict copy]];
    
    if (![elementName isEqualToString:self.lastRemovedItem] && self.currentDepth!=nil && self.lastRemovedItem!=nil) {
        NSMutableArray *lastDepth = [NSMutableArray arrayWithArray:self.currentDepth];
        [lastDepth addObject:self.lastRemovedItem];
        
        NSMutableDictionary *oldObject = [self.resultObject objectForKey:[lastDepth componentsJoinedByString:@"."]];
        NSMutableArray *oldObjectArray = [self.resultObject objectForKey:[NSString stringWithFormat:@"%@[]", [lastDepth componentsJoinedByString:@"."]]];
        
        NSString			*objectPath		= [self.currentDepth componentsJoinedByString:@"."];
		NSMutableDictionary *currentDict	= [self.resultObject objectForKey:objectPath];
        
        //link temporary objects on inner node to their parent node
        if (oldObjectArray!=nil && [oldObjectArray count]>1) {
            [currentDict setObject:[oldObjectArray copy] forKey:self.lastRemovedItem];
        }
        else if(oldObject!=nil){
            [currentDict setObject:[oldObject copy] forKey:self.lastRemovedItem];
        }
        
        //removing temporary objects on inner node while ending their parent node
        [self.resultObject removeObjectForKey:[NSString stringWithFormat:@"%@[]", [lastDepth componentsJoinedByString:@"."]]];
        [self.resultObject removeObjectForKey:[NSString stringWithString:[lastDepth componentsJoinedByString:@"."]]];
    }

	if ([[self.currentDepth lastObject] isEqualToString:elementName])
	{
		self.lastRemovedItem = [self.currentDepth lastObject];
		[self.currentDepth removeLastObject];
	}

	if ([elementName isEqualToString:self.itemElement])
		[self.dataItems addObject:self.dataItem];
	else
		for (NSString *key in self.itemVariables) {
			if ([elementName isEqualToString:key])
				[self.dataItem setObject:self.currentParsedCharacterData forKey:key];
		}


	if (![self.currentParsedCharacterData isEqualToString:@""])
	{
		NSString			*objectPath		= [self.currentDepth componentsJoinedByString:@"."];
		NSMutableDictionary *currentDict	= [self.resultObject objectForKey:objectPath];
		[currentDict setObject:[self.currentParsedCharacterData copy] forKey:elementName];
		self.currentParsedCharacterData = [NSMutableString string];
	}
	else
		self.currentParsedCharacterData = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSString			*objectPath		= [self.currentDepth componentsJoinedByString:@"."];
    [self.resultObject removeObjectForKey:objectPath];
    NSString			*arrayPath		= [NSString stringWithFormat:@"%@[]", [self.currentDepth componentsJoinedByString:@"."]];
    [self.resultObject removeObjectForKey:objectPath];
    [self.resultObject removeObjectForKey:arrayPath];
	[self.currentParsedCharacterData appendString:string];
}

- (void)clearIntermediateParserVariables
{}

- (void)dealloc
{}

@end