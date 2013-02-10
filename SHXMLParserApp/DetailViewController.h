//
//  DetailViewController.h
//  SHXMLParserApp
//
//  Created by Narasimharaj on 10/02/13.
//  Copyright (c) 2013 SimHa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
