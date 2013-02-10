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

-(id) init
{
    if(self = [super init])    {
        
    }
    return self;
}

- (void)clearIntermediateParserVariables
{
	self.webServicesData = nil;
	self.webServicesConnection = nil;
    self.dataItems = nil;
}

- (BOOL)sendAsynchCommand:(NSString *)finalCommand caller:(id)caller responseCallback:(SEL)successCallbackMethod errorCallback:(SEL)errorCallbackMethod
{
	self.callbackObject = caller;
	self.successCallBack = successCallbackMethod;
	self.errorCallBack = errorCallbackMethod;
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

    NSArray *classVariables = [[NSArray arrayWithObjects:@"title", @"link", @"comments", @"description", nil] autorelease];
    SHXMLParser *parser = [[SHXMLParser alloc] init];
    NSMutableArray* myDataArray = [parser parseData:self.webServicesData withArrayPath:@"channel.item" andItemKeys:classVariables];
    self.dataItems = [SHXMLParser convertDictionary:myDataArray toObjectArrayWithClassName:@"DataItem" classVariables:classVariables];
    [myDataArray release];
    [parser release];
    [self.callbackObject performSelector:self.successCallBack];
}

- (BOOL)getItems:(id)inObjectID responseCallback:(SEL)callbackMethod
{
	NSString *urlString = @"http://news.ycombinator.com/rss";
    
	BOOL retVal = [self sendAsynchCommand:urlString caller:inObjectID responseCallback:callbackMethod errorCallback:nil];
    
	return retVal;
}

- (void)dealloc
{
    [super dealloc];
    self.webServicesConnection = nil;
    self.webServicesData = nil;
    self.dataItems = nil;
}

@end
