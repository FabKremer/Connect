//
//  SettingsViewController.h
//  Connect
//
//  Created by TopTier labs on 9/22/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDataSource>{
    IBOutlet UIButton *btnBack;
    IBOutlet UITableView *table;

}

@property(nonatomic,retain) UIButton *btnBack;
@property(nonatomic,retain) UITableView *table;

-(IBAction)back:(id)sender;

@end
