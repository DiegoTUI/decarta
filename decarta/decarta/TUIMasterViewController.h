//
//  TUIMasterViewController.h
//  decarta
//
//  Created by Diego Lafuente on 22/08/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TUIDetailViewController;

@interface TUIMasterViewController : UITableViewController

@property (strong, nonatomic) TUIDetailViewController *detailViewController;

@end
