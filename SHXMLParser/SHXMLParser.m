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
	_currentDepth	= [NSMutableArray array];
	_resultObject	= [NSMutableDictionary dictionary];

	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:XMLData];

	[parser setDelegate:self];

	if ([parser parse] == YES)
		return _resultObject;

	return nil;
}

+ (NSArray *)getAsArray:(id)object
{
    NSMutableArray *myArray = [NSMutableArray array];
    if([object isKindOfClass:[NSDictionary class]])    {
        [myArray addObject:object];
        return myArray;
    }
    else if([object isKindOfClass:[NSArray class]]){
        return (NSArray*)object;
    }
    return myArray;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	[_currentDepth addObject:elementName];

	if ([_currentDepth count] > 1)
	{
		NSString *arrayPath = [NSString stringWithFormat:@"%@[]", [_currentDepth componentsJoinedByString:@"."]];

		if ([_resultObject objectForKey:arrayPath] == nil)
			[_resultObject setObject:[NSMutableArray array] forKey:arrayPath];
	}

	NSString *objectPath = [_currentDepth componentsJoinedByString:@"."];
	[_resultObject setObject:[NSMutableDictionary dictionaryWithDictionary:attributeDict] forKey:objectPath];

	_currentParsedCharacterData = [NSMutableString string];
	//
	_elementStarted		= TRUE;
	_foundCharacters	= FALSE;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if (_foundCharacters && _elementStarted)
	{
        NSString *objectPath = [_currentDepth componentsJoinedByString:@"."];

		if([[_resultObject objectForKey:objectPath] isKindOfClass:[NSDictionary class]] && [(NSDictionary*)[_resultObject objectForKey:objectPath] count]>0)
        {
            NSMutableDictionary *tempDict = [[_resultObject objectForKey:objectPath] mutableCopy];
            [tempDict setObject:[_currentParsedCharacterData copy] forKey:@"leafContent"];
            [_resultObject setObject:tempDict forKey:objectPath];
        }
        else if ([[_resultObject objectForKey:objectPath] isKindOfClass:[NSDictionary class]] && [(NSDictionary*)[_resultObject objectForKey:objectPath] count]==0)
        {
            [_resultObject removeObjectForKey:objectPath];
            [_resultObject setObject:[_currentParsedCharacterData copy] forKey:objectPath];
        }
        else{
            //[_resultObject removeObjectForKey:objectPath];
            //[_resultObject removeObjectForKey:arrayPath];
        }
	}

	NSString			*arrayPath		= [NSString stringWithFormat:@"%@[]", [_currentDepth componentsJoinedByString:@"."]];
	NSMutableArray		*currentArray	= [_resultObject objectForKey:arrayPath];
	NSMutableDictionary *currentDict	= [_resultObject objectForKey:[_currentDepth componentsJoinedByString:@"."]];

	if (currentDict != nil)
		[currentArray addObject:[currentDict copy]];

    //adding the ended nodes to current node starts here
	if (_currentDepth != nil)
	{
		NSMutableArray *endedNodes = [NSMutableArray array];

		for (NSString *key in _resultObject) {
			NSString *trimmedPath = [key stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]];

			if ([_currentDepth count] < [[trimmedPath componentsSeparatedByString:@"."] count])
			{
				NSMutableArray *keyArray = [[trimmedPath componentsSeparatedByString:@"."] mutableCopy];

				if (![endedNodes containsObject:[keyArray lastObject]])
					[endedNodes addObject:[keyArray lastObject]];
			}
		}

		for (NSString *endedNode in endedNodes) {
			NSMutableArray *endedDepth = [NSMutableArray arrayWithArray:_currentDepth];
			[endedDepth addObject:endedNode];

			NSMutableDictionary *endedObject			= [_resultObject objectForKey:[endedDepth componentsJoinedByString:@"."]];
			NSMutableArray		*endedObjectArray	= [_resultObject objectForKey:[NSString stringWithFormat:@"%@[]", [endedDepth componentsJoinedByString:@"."]]];

			NSString			*objectPath		= [_currentDepth componentsJoinedByString:@"."];
			NSMutableDictionary *currentDict	= [_resultObject objectForKey:objectPath];

			NSString			*objectArrayPath	= [NSString stringWithFormat:@"%@[]", [_currentDepth componentsJoinedByString:@"."]];
			NSMutableArray		*currentArray		= [_resultObject objectForKey:objectArrayPath];
			NSMutableDictionary *currentArrayDict	= [[currentArray lastObject] mutableCopy];

			// link temporary objects on inner node to their parent node
			if ((endedObjectArray != nil) && ([endedObjectArray count] > 1))
			{
				[currentDict setObject:[endedObjectArray copy] forKey:endedNode];
				[currentArrayDict setObject:[endedObjectArray copy] forKey:endedNode];
			}
			else if (endedObject != nil)
			{
				[currentDict setObject:[endedObject copy] forKey:endedNode];
				[currentArrayDict setObject:[endedObject copy] forKey:endedNode];
			}
			// Add inner nodes to items in a array
			[currentArray removeLastObject];
			[currentArray addObject:currentArrayDict];

			// removing temporary objects on inner node while ending their parent node
			[_resultObject removeObjectForKey:[NSString stringWithFormat:@"%@[]", [endedDepth componentsJoinedByString:@"."]]];
			[_resultObject removeObjectForKey:[NSString stringWithString:[endedDepth componentsJoinedByString:@"."]]];
		}
	}
    //adding the ended nodes to current node ends here

	[_currentDepth removeLastObject];

    //Writing current element values below
    
    //We are checking for repeated elements with string values so that they can be converted to array
	NSString			*objectPath			= [_currentDepth componentsJoinedByString:@"."];
	NSMutableDictionary *currentDictObject	= [_resultObject objectForKey:objectPath];
    if([currentDictObject objectForKey:elementName] == nil)    {
        [currentDictObject setObject:[_currentParsedCharacterData copy] forKey:elementName];
    }
    else if([[currentDictObject objectForKey:elementName] isKindOfClass:[NSArray class]] || [[currentDictObject objectForKey:elementName] isKindOfClass:[NSMutableArray class]])   {
        NSMutableArray *tempArray = [[currentDictObject objectForKey:elementName] mutableCopy];
        [tempArray addObject:[_currentParsedCharacterData copy]];
        [currentDictObject setObject:tempArray forKey:elementName];
    }
    else if ([[currentDictObject objectForKey:elementName] isKindOfClass:[NSString class]])
    {
        NSMutableArray *tempArray = [NSMutableArray array];
        [tempArray addObject:[currentDictObject objectForKey:elementName]];
        [tempArray addObject:[_currentParsedCharacterData copy]];
        [currentDictObject setObject:tempArray forKey:elementName];
    }
	_currentParsedCharacterData = [NSMutableString string];
	//
	_elementStarted = FALSE;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	_foundCharacters = TRUE;
	[_currentParsedCharacterData appendString:string];
}

@end