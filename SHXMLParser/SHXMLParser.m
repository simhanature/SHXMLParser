//
//  SHXMLParser.m
//  SHXMLParser
//
//  Created by Narasimharaj on 09/02/13.
//  Copyright (c) 2013 SimHa. All rights reserved.
//

#import "SHXMLParser.h"

@interface SHXMLParser ()

@property (nonatomic, strong) NSMutableString		*currentParsedCharacterData;
@property (nonatomic, strong) NSMutableArray		*currentDepth;
@property (nonatomic, strong) NSString				*lastRemovedItem;
@property (nonatomic, strong) NSMutableDictionary	*resultObject;

// Below boolean variables are used to acertain while parsing that we are in the leaf node, but not formatted spaces or newlines between node tags
@property (nonatomic, assign) BOOL	foundCharacters;
@property (nonatomic, assign) BOOL	elementStarted;

@end

@implementation SHXMLParser

+ (NSArray *)convertDictionaryArray:(NSArray *)dictionaryArray toObjectArrayWithClassName:(NSString *)className classVariables:(NSArray *)classVariables
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

+ (id)getDataAtPath:(NSString *)path fromResultObject:(NSDictionary *)resultObject
{
	id		dataObject	= resultObject;
	NSArray *pathArray	= [path componentsSeparatedByString:@"."];

	for (NSString *step in pathArray) {
		if ([dataObject isKindOfClass:[NSDictionary class]])
			dataObject = [dataObject objectForKey:step];
		else
			return nil;
	}

	return dataObject;
}

- (NSDictionary *)parseData:(NSData *)XMLData
{
	self.currentDepth	= [NSMutableArray array];
	self.resultObject	= [NSMutableDictionary dictionary];

	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:XMLData];

	[parser setDelegate:self];

	if ([parser parse] == YES)
		return self.resultObject;

	return nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	[self.currentDepth addObject:elementName];

	if ([self.currentDepth count] > 1)
	{
		NSString *arrayPath = [NSString stringWithFormat:@"%@[]", [self.currentDepth componentsJoinedByString:@"."]];

		if ([self.resultObject objectForKey:arrayPath] == nil)
			[self.resultObject setObject:[NSMutableArray array] forKey:arrayPath];
	}

	NSString *objectPath = [self.currentDepth componentsJoinedByString:@"."];
	[self.resultObject setObject:[NSMutableDictionary dictionaryWithDictionary:attributeDict] forKey:objectPath];

	self.currentParsedCharacterData = [NSMutableString string];
	//
	self.elementStarted		= TRUE;
	self.foundCharacters	= FALSE;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if (self.foundCharacters && self.elementStarted)
	{
		NSString *objectPath = [self.currentDepth componentsJoinedByString:@"."];

		[self.resultObject removeObjectForKey:objectPath];

		NSString *arrayPath = [NSString stringWithFormat:@"%@[]", [self.currentDepth componentsJoinedByString:@"."]];
		[self.resultObject removeObjectForKey:arrayPath];
	}

	NSString			*arrayPath		= [NSString stringWithFormat:@"%@[]", [self.currentDepth componentsJoinedByString:@"."]];
	NSMutableArray		*currentArray	= [self.resultObject objectForKey:arrayPath];
	NSMutableDictionary *currentDict	= [self.resultObject objectForKey:[self.currentDepth componentsJoinedByString:@"."]];

	if (currentDict != nil)
		[currentArray addObject:[currentDict copy]];

	if ((self.currentDepth != nil) && (self.lastRemovedItem != nil))
	{
		NSMutableArray *lastDepth = [NSMutableArray arrayWithArray:self.currentDepth];
		[lastDepth addObject:self.lastRemovedItem];

		NSMutableDictionary *lastObject			= [self.resultObject objectForKey:[lastDepth componentsJoinedByString:@"."]];
		NSMutableArray		*lastObjectArray	= [self.resultObject objectForKey:[NSString stringWithFormat:@"%@[]", [lastDepth componentsJoinedByString:@"."]]];

		NSString			*objectPath		= [self.currentDepth componentsJoinedByString:@"."];
		NSMutableDictionary *currentDict	= [self.resultObject objectForKey:objectPath];

		NSString			*objectArrayPath	= [NSString stringWithFormat:@"%@[]", [self.currentDepth componentsJoinedByString:@"."]];
		NSMutableArray		*currentArray		= [self.resultObject objectForKey:objectArrayPath];
		NSMutableDictionary *currentArrayDict	= [[currentArray lastObject] mutableCopy];

		// link temporary objects on inner node to their parent node
		if ((lastObjectArray != nil) && ([lastObjectArray count] > 1))
		{
			[currentDict setObject:[lastObjectArray copy] forKey:self.lastRemovedItem];
			[currentArrayDict setObject:[lastObjectArray copy] forKey:self.lastRemovedItem];

			// Add inner nodes to items in a array
			[currentArray removeLastObject];
			[currentArray addObject:currentArrayDict];
		}
		else if (lastObject != nil)
		{
			[currentDict setObject:[lastObject copy] forKey:self.lastRemovedItem];
			[currentArrayDict setObject:[lastObject copy] forKey:self.lastRemovedItem];

			// Add inner nodes to items in a array
			[currentArray removeLastObject];
			[currentArray addObject:currentArrayDict];
		}

		// removing temporary objects on inner node while ending their parent node
		[self.resultObject removeObjectForKey:[NSString stringWithFormat:@"%@[]", [lastDepth componentsJoinedByString:@"."]]];
		[self.resultObject removeObjectForKey:[NSString stringWithString:[lastDepth componentsJoinedByString:@"."]]];
	}

	self.lastRemovedItem = [self.currentDepth lastObject];
	[self.currentDepth removeLastObject];

	NSString			*objectPath			= [self.currentDepth componentsJoinedByString:@"."];
	NSMutableDictionary *currentDictObject	= [self.resultObject objectForKey:objectPath];
	[currentDictObject setObject:[self.currentParsedCharacterData copy] forKey:elementName];
	self.currentParsedCharacterData = [NSMutableString string];
	//
	self.elementStarted = FALSE;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	self.foundCharacters = TRUE;
	[self.currentParsedCharacterData appendString:string];
}

@end