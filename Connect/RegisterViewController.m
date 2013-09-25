//
//  RegisterViewController.m
//  Connect
//
//  Created by TopTier labs on 9/21/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import "RegisterViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize txtName,txtSurname,txtMail,txtPassword,txtPassword2,table,btnRegister;

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
    
    table.dataSource=self;
    
    txtName.tag=1;
    txtMail.delegate=self;
    
    txtSurname.tag=2;
    txtMail.delegate=self;
    
    txtMail.tag=3;
    txtMail.delegate=self;
    
    txtPassword.secureTextEntry = YES;
    txtPassword.tag=4;
    txtPassword.delegate=self;
    
    txtPassword2.secureTextEntry = YES;
    txtPassword2.tag=5;
    txtPassword2.delegate=self;
    
    btnRegister.clipsToBounds = YES;
    btnRegister.layer.cornerRadius = 15.0f;
    btnRegister.clipsToBounds = YES;
    [btnRegister setBackgroundColor:[UIColor colorWithRed:16.0/255.0f green:147.0/255.0f blue:220.0/255.0f alpha:1]];
    [btnRegister setEnabled:NO];
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
    if (section == 0)
        return 2;
    else
        return 3;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.table cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init ];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    
    
    return cell;
}



@end
