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

@synthesize table,btnBack,logout;

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
    [logout setTarget:self];
    [logout setAction:@selector(logoutClicked:)];
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
    return 1;//poner 2 si quiero facebook y eso
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger i;
    if (section==0)
        i=2;
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    
    if (indexPath.section==0){
        if(indexPath.row==0){
            cell.textLabel.text=@"Name:";
            cell.textLabel.font= [UIFont fontWithName:@"System Bold" size:14.0];
            CGRect lFrame = CGRectMake(cell.frame.size.width - 240, 0, 200, cell.frame.size.height);
            UILabel *lbl1 = [[UILabel alloc]initWithFrame:lFrame];
            [lbl1 setFont:[UIFont fontWithName:@"FontName" size:12.0]];
            [lbl1 setTextColor:[UIColor grayColor]];
            lbl1.text = [defaults objectForKey:@"name"];
            [cell addSubview:lbl1];
            
        }
        else if(indexPath.row==1){
            cell.textLabel.text=@"Mail:";
            cell.textLabel.font= [UIFont fontWithName:@"System Bold" size:14.0];
            CGRect lFrame = CGRectMake(cell.frame.size.width - 250, 0, 200, cell.frame.size.height);
            UILabel *lbl1 = [[UILabel alloc]initWithFrame:lFrame];
            [lbl1 setFont:[UIFont fontWithName:@"FontName" size:12.0]];
            [lbl1 setTextColor:[UIColor grayColor]];
            lbl1.text = [defaults objectForKey:@"mail"];
            [cell addSubview:lbl1];
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

-(void)logoutClicked:(id)sender{
    // Create the action sheet
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                         destructiveButtonTitle:NSLocalizedString(@"Logout", nil)
                                              otherButtonTitles:nil];
    [sheet showInView:self.view];

}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [self performSegueWithIdentifier:@"logoutSegue" sender:self];
    }
}

@end
