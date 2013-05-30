//
//  WebServices.m
//  test_01
//
//  Created by Narasimharaj on 09/02/13.
//  Copyright (c) 2013 SimHa. All rights reserved.
//

#import "WebServices.h"
#import "SHXMLParser.h"

@implementation WebServices

@synthesize webServicesData;
@synthesize webServicesConnection, successCallBack, errorCallBack;
@synthesize callbackObject;
@synthesize dataItems;

- (id)init
{
	if (self = [super init])
	{}
	return self;
}

- (void)clearIntermediateParserVariables
{
	self.webServicesData		= nil;
	self.webServicesConnection	= nil;
	self.dataItems				= nil;
}

- (BOOL)sendAsynchCommand:(NSString *)finalCommand caller:(id)caller responseCallback:(SEL)successCallbackMethod errorCallback:(SEL)errorCallbackMethod
{
	self.callbackObject		= caller;
	self.successCallBack	= successCallbackMethod;
	self.errorCallBack		= errorCallbackMethod;
	[self clearIntermediateParserVariables];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:finalCommand]];
	self.webServicesConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	NSAssert(self.webServicesConnection != nil, @"failed to connect");

	// Turn on the network indicators
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	self.webServicesData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.webServicesData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

	SHXMLParser		*parser			= [[SHXMLParser alloc] init];
	NSDictionary	*resultObject	= [parser parseData:self.webServicesData];
	NSArray			*dataArray		= [SHXMLParser getDataAtPath:@"rss.channel.item" fromResultObject:resultObject];

	/*
	 *   //Alternatively you can access your item array as you see below since you know your XML structure
	 *   NSDictionary* rssObject = [resultObject objectForKey:@"rss"];
	 *   NSDictionary* channelObject = [rssObject objectForKey:@"channel"];
	 *   NSMutableArray* myDataArray = [channelObject objectForKey:@"item"];
	 */

	NSArray *classVariables = [NSArray arrayWithObjects:@"title", @"link", @"comments", @"description", nil];
	self.dataItems = [SHXMLParser convertDictionaryArray:dataArray toObjectArrayWithClassName:@"DataItem" classVariables:classVariables];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	[self.callbackObject performSelector:self.successCallBack];
#pragma clang diagnostic pop
}

- (BOOL)getItems:(id)inObjectID responseCallback:(SEL)callbackMethod
{
	NSString *urlString = @"https://news.ycombinator.com/rss";

	BOOL retVal = [self sendAsynchCommand:urlString caller:inObjectID responseCallback:callbackMethod errorCallback:nil];

	return retVal;
}

@end