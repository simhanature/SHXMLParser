//
//  DataItem.h
//  Sample for SHXML Parser
//
//  Created by Narasimharaj on 09/02/13.
//  Copyright (c) 2013 SimHa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataItem : NSObject
{
    NSString* title;
    NSString* description;
    NSString* link;
    NSString* comments;
}

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) NSString* link;
@property (nonatomic, retain) NSString* comments;


@end
