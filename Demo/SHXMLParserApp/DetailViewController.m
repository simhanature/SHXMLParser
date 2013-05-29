//
//  DetailViewController.m
//  Sample for SHXML Parser
//
//  Created by Narasimharaj on 09/02/13.
//  Copyright (c) 2013 SimHa. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

@synthesize webView, dataItem;

- (void)reset
{
	self.webView	=	nil;
	self.dataItem	=	nil;
}

- (void)dealloc
{
	[self reset];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    self.title = self.dataItem.title;
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.dataItem.link]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
@end
