//
//  ConnectViewController.h
//  Connect
//
//  Created by TopTier labs on 10/19/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "serverResponse.h"

@interface ConnectViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *table;
    serverResponse * scanUser;
}

@property(nonatomic,retain) UITableView *table;
@property(nonatomic,retain) serverResponse * scanUser;

@end
