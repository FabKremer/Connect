//
//  ConnectViewController.m
//  Connect
//
//  Created by TopTier labs on 10/19/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import "ConnectViewController.h"

@interface ConnectViewController ()

@end

@implementation ConnectViewController

@synthesize scanUser, table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.table.delegate=self;
    self.table.dataSource=self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.table cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init ];
        
    }
    
    if (indexPath.row==0){//seteo lo del mail.
        cell.textLabel.text=@"Send him a Mail";
    }else if(indexPath.row==1){//seteo lo de facebook
        cell.textLabel.text=@"Go to his Facebook Profile";
    }else if (indexPath.row==2){//seteo lo de linkedin
        cell.textLabel.text=@"Go to his Linkedin Profile";
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    return cell;
}



@end
