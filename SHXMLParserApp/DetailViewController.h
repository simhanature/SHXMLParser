//
//  DetailViewController.h
//  Sample for SHXML Parser
//
//  Created by Narasimharaj on 09/02/13.
//  Copyright (c) 2013 SimHa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataItem.h"

@interface DetailViewController : UIViewController
{
    IBOutlet		UIWebView	*webView;
	DataItem				*dataItem;
}

@property (nonatomic, retain) IBOutlet		UIWebView	*webView;
@property (nonatomic, retain) DataItem	*dataItem;

@end
