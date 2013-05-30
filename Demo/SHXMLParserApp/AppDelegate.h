//
//  AppDelegate.h
//  Sample for SHXML Parser
//
//  Created by Narasimharaj on 09/02/13.
//  Copyright (c) 2013 SimHa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServices.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
	WebServices *webServices;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (nonatomic, retain) WebServices *webServices;

@end