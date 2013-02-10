//
//  WebServices.h
//  Sample for SHXML Parser
//
//  Created by Narasimharaj on 09/02/13.
//  Copyright (c) 2013 SimHa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServices : NSObject <NSXMLParserDelegate>
{
	NSMutableData *webServicesData;
	NSURLConnection *webServicesConnection;
	SEL successCallBack;
	SEL errorCallBack;
	id callbackObject;
    NSMutableArray *dataItems;
}

@property (nonatomic, retain) NSMutableArray *dataItems;
@property (nonatomic, retain) NSMutableData *webServicesData;
@property (nonatomic, retain) NSURLConnection *webServicesConnection;
@property (nonatomic, assign) SEL successCallBack;
@property (nonatomic, assign) SEL errorCallBack;
@property (nonatomic, retain) id callbackObject;

- (BOOL)sendAsynchCommand:(NSString *)finalCommand caller:(id)caller responseCallback:(SEL)callbackMethod errorCallback:(SEL)errorCallbackMethod;
- (BOOL)getItems:(id)inObjectID responseCallback:(SEL)callbackMethod;

@end
