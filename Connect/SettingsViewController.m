//
//  SettingsViewController.m
//  Connect
//
//  Created by TopTier labs on 9/22/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
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

-(void)switchFBChanged:(id)sender{
    
}

-(void)switchINChanged:(id)sender{
    
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
            sectionName=NSLocalizedString(@"Basic Information", nil);
            break;
        default:
            sectionName = NSLocalizedString(@"Set What To Share", nil); 
            break;
    }
    return sectionName;
}

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"logoutSegue"]){
        //borro todo lo persistido
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        
        // this button's job is to flip-flop the session from open to closed
        if (appDelegate.session.isOpen) {
            // if a user logs out explicitly, we delete any cached token information, and next
            // time they run the applicaiton they will be presented with log in UX again; most
            // users will simply close the app or switch away, without logging out; this will
            // cause the implicit cached-token login to occur on next launch of the application
            [appDelegate.session closeAndClearTokenInformation];
            
        }
    }

}

@end
