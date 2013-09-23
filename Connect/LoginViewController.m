//
//  LoginViewController.m
//  Connect
//
//  Created by TopTier labs on 9/21/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RegisterViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize txtMail,txtPassword,btnLogin,table,btnRegister;

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
    
    btnLogin.clipsToBounds = YES;
    btnLogin.layer.cornerRadius = 15.0f;
    table.dataSource=self;
    txtPassword.secureTextEntry = YES;
    txtPassword.delegate=self;
    txtPassword.tag=2;
    txtMail.tag=1;
    txtMail.delegate=self;
    
    [btnLogin setBackgroundColor:[UIColor colorWithRed:16.0/255.0f green:147.0/255.0f blue:220.0/255.0f alpha:1]];
    [btnLogin setEnabled:NO];
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
    return 2;
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

-(IBAction)registration:(id)sender{
    [self performSegueWithIdentifier:@"registerSegue" sender:self];
}

-(IBAction)login:(id)sender{
    [self performSegueWithIdentifier:@"shareSegueFL" sender:self];
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];//Dismiss the keyboard.
        //        
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *theOtherText;
    
    if (textField.tag==1){//mail
        mail=textField.text;
        theOtherText=password;
    }
    else{ //pass
        password=textField.text;
        theOtherText=mail;
    }

    if (theOtherText!=nil && ![theOtherText isEqualToString:@""] && textField!=nil && ![textField.text isEqualToString:@""]){
        [btnLogin setBackgroundColor:[UIColor colorWithRed:15.0/255.0f green:140.0/255.0f blue:209.0/255.0f alpha:1]];
        [btnLogin setEnabled:YES];
    }else{
        [btnLogin setBackgroundColor:[UIColor colorWithRed:16.0/255.0f green:147.0/255.0f blue:220.0/255.0f alpha:1]];
        [btnLogin setEnabled:NO];
    }

}



@end
