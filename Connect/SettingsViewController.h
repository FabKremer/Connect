//
//  SettingsViewController.h
//  Connect
//
//  Created by TopTier labs on 9/22/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDataSource,UIActionSheetDelegate>{
    IBOutlet UIButton *btnBack;
    IBOutlet UITableView *table;
    IBOutlet UIBarButtonItem *logout;

}

@property(nonatomic,retain) UIButton *btnBack;
@property(nonatomic,retain) UITableView *table;
@property(nonatomic,retain) UIBarButtonItem *logout;

-(IBAction)back:(id)sender;

@end
