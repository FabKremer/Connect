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
#import "BackendProxy.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize txtMail,txtPassword,btnLogin,table,btnRegister,btnWrong,wrongView,spinner,txtWrong;

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
    btnWrong.transform = CGAffineTransformMakeRotation(45.0*M_PI/180.0);
    [wrongView setHidden:YES];
    [spinner setHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [wrongView setHidden:YES];
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
    [txtPassword resignFirstResponder];
    [spinner setHidden:NO];
    [spinner startAnimating];
    [self performSelectorInBackground:@selector(processLogin) withObject:self];

}

-(void)processLogin{
    //llamo a la funcion de la clase BackendProxy
    if (mail!=nil && password!= nil && ![mail isEqualToString:@""] && ![password isEqualToString:@""]){//no hay cosas vacias
        
        if (! [BackendProxy internetConnection]){
            //si no hay conexion con el server
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Failed", nil) message:NSLocalizedString(@"No Internet Connection Login", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        else{
            
            serverResponse * sr = [BackendProxy login :txtMail.text :txtPassword.text];
            
            //comparo segun lo que me dio la funcion enterUser para ver como sigo
            if ([sr getCodigo] == 200){
                [self performSelectorOnMainThread:@selector(finishedLoading) withObject:nil waitUntilDone:NO];
            }
            else{
                txtPassword.text=@"";
                password=nil;
                txtWrong.text=NSLocalizedString(@"Invalid Mail and/or Password", nil);
                [wrongView setHidden:NO];
            }
        }
    }
    else{
        txtWrong.text=NSLocalizedString(@"Complete all the fields to login", nil);
        [wrongView setHidden:NO];

    }
    
    [spinner stopAnimating];
    [spinner setHidden:YES];
}

-(void)finishedLoading{
    [self performSegueWithIdentifier:@"shareSegueFL" sender:self];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag==1)//mail
        mail=textField.text;
    else//pass
        password= textField.text;
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [wrongView setHidden:YES];
    
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];//Dismiss the keyboard.
        //        
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [wrongView setHidden:YES];
//    NSString *theOtherText;
//    
    if (textField.tag==1){//mail
        mail=textField.text;
    }
    else{ //pass
        password=textField.text;
    }
//
////    if (theOtherText!=nil && ![theOtherText isEqualToString:@""] && textField!=nil && ![textField.text isEqualToString:@""]){
////        [btnLogin setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:175.0/255.0f blue:240.0/255.0f alpha:1]];
////        [btnLogin setEnabled:YES];
////    }else{
////        [btnLogin setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:175.0/255.0f blue:240.0/255.0f alpha:0.5]];
////        [btnLogin setEnabled:NO];
////    }
}



@end
