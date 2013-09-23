//
//  SettingsViewController.m
//  Connect
//
//  Created by TopTier labs on 9/22/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize table,btnBack;

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger i;
    if (section==0)
        i=1;
    else
        i=2;
    
    return i;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init ];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section==0){
        if(indexPath.row==0){
            cell.textLabel.text=@"My Account";
            UITextField *name = [[UITextField alloc] initWithFrame:CGRectZero];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [name addTarget:self action:@selector(caca:) forControlEvents:UIControlEventEditingDidEnd];
        }
        
    }
    else{
        if(indexPath.row==0){
            cell.textLabel.text=@"Facebook";
            [cell.imageView setImage:[UIImage imageNamed:@"fbicon.jpeg"]];
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            [switchView setOn:NO animated:NO];
            [switchView addTarget:self action:@selector(switchFBChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if(indexPath.row==1){
            cell.textLabel.text=@"LinkedIn";
            [cell.imageView setImage:[UIImage imageNamed:@"inicon.jpeg"]];
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            [switchView setOn:NO animated:NO];
            [switchView addTarget:self action:@selector(switchINChanged:) forControlEvents:UIControlEventValueChanged];
        }
    }
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName=@"Basic Information";
            break;
        default:
            sectionName = @"Set What To Share";
            break;
    }
    return sectionName;
}

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}


@end
