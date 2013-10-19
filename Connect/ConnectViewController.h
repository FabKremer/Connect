//
//  ConnectViewController.h
//  Connect
//
//  Created by TopTier labs on 10/19/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *table;
 
}

@property(nonatomic,retain) UITableView *table;

@end
