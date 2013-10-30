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

@synthesize scanUser, table,name;

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
    [self.table setAllowsSelection:YES];
    self.name.text= [scanUser getName];
    
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
    int i=0;
    if (![[scanUser getFacebook] isEqualToString:@""])//tiene facebook
        i++;
    if (![[scanUser getLinkedin] isEqualToString:@""])//tiene linkedin
        i++;
    
    if (i==1){
        CGRect tFrame = CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width, 80.0f);
        table.frame=tFrame;
    }
    return i;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.table cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init ];
        
    }
    
    if ([[scanUser getFacebook] isEqualToString:@""] && [[scanUser getLinkedin] isEqualToString:@""]){
        //tiene solo mail
//        if (indexPath.row==0){//seteo lo del mail.
//            cell.textLabel.text=@"Connect via Mail";
//        }

    }
    else if ([[scanUser getFacebook] isEqualToString:@""] && ![[scanUser getLinkedin] isEqualToString:@""]){
        //no tiene facebook
        /*if (indexPath.row==0){//seteo lo del mail.
            cell.textLabel.text=@"Connect via Mail";
        }else*/ if (indexPath.row==0){//seteo lo de linkedin
            cell.textLabel.text=NSLocalizedString(@"Connect via Linkedin", nil);
        }

    }
    else if (![[scanUser getFacebook] isEqualToString:@""] && [[scanUser getLinkedin] isEqualToString:@""]){
        //no tiene linkedin
        /*if (indexPath.row==0){//seteo lo del mail.
            cell.textLabel.text=@"Connect via Mail";
        }else */if(indexPath.row==0){//seteo lo de facebook
            cell.textLabel.text=NSLocalizedString(@"Connect via Facebook", nil);
        }
    }
    else{
        //tiene todo
        /*if (indexPath.row==0){//seteo lo del mail.
            cell.textLabel.text=@"Connect via Mail";
        }else */if(indexPath.row==0){//seteo lo de facebook
            cell.textLabel.text=NSLocalizedString(@"Connect via Facebook", nil);
        }else if (indexPath.row==1){//seteo lo de linkedin
            cell.textLabel.text=NSLocalizedString(@"Connect via Linkedin", nil);
        }

    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[scanUser getFacebook] isEqualToString:@""] && [[scanUser getLinkedin] isEqualToString:@""]){
        //tiene solo mail
//        if (indexPath.row==0){//mail.
//            
//        }
        
    }
    else if ([[scanUser getFacebook] isEqualToString:@""] && ![[scanUser getLinkedin] isEqualToString:@""]){
        //no tiene facebook
        if (indexPath.row==48984){//mail.
            
        }else if (indexPath.row==0){//linkedin
            NSString *path= [NSString stringWithFormat:@"http://www.linkedin.com/profile/view?id=%@&authType=name&authToken=b86X&goback=%2Enmp_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1&trk=nmp_rec_act_profile_photo",[scanUser getLinkedin]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
        }
        
    }
    else if (![[scanUser getFacebook] isEqualToString:@""] && [[scanUser getLinkedin] isEqualToString:@""]){
        //no tiene linkedin
        if (indexPath.row==5454){//mail.
            
        }else if(indexPath.row==0){//facebook
            NSString *path= [NSString stringWithFormat:@"http://facebook.com/%@",[scanUser getFacebook]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
        }
    }
    else{
        //tiene todo
        if (indexPath.row==3240){//mail.
            //cell.textLabel.text=@"Connect via Mail";
        }else if(indexPath.row==0){//facebook
            NSString *path= [NSString stringWithFormat:@"http://facebook.com/%@",[scanUser getFacebook]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];

        }else if (indexPath.row==1){//linkedin
            NSString *path= [NSString stringWithFormat:@"http://www.linkedin.com/profile/view?id=%@&authType=name&authToken=b86X&goback=%2Enmp_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1&trk=nmp_rec_act_profile_photo",[scanUser getLinkedin]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];

        }
        
    }
    
}

@end
