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

@synthesize txtMail,txtPassword,btnLogin,table,btnRegister,btnWrong,wrongView;

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
    [btnLogin setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:175.0/255.0f blue:240.0/255.0f alpha:0.5]];
    [btnLogin setEnabled:NO];
    [wrongView setHidden:YES];
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
    
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                          mail,@"Email",
                          password, @"Password",
                          nil];
    
    // POST
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:@"http://connectwp.azurewebsites.net/api/login/"]];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:info options:0 error:&error];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    //NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // imprimo lo que mando para verificar
    NSLog(@"%@", [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]);
    
    NSHTTPURLResponse* urlResponse = nil;
    error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    // imprimo el resultado del post para verificar
    NSLog(@"Response: %@", result);
    NSLog(@"Response: %ld", (long)urlResponse.statusCode);
    
    //comparo segun lo que me dio el status code para ver como sigo
    if ((long)urlResponse.statusCode == 200)
        [self performSegueWithIdentifier:@"shareSegueFL" sender:self];
    else{
        txtPassword.text=@"";
        password=nil;
        [btnLogin setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:175.0/255.0f blue:240.0/255.0f alpha:0.5]];
        [btnLogin setEnabled:NO];
        [wrongView setHidden:NO];
    }
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
        [btnLogin setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:175.0/255.0f blue:240.0/255.0f alpha:1]];
        [btnLogin setEnabled:YES];
    }else{
        [btnLogin setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:175.0/255.0f blue:240.0/255.0f alpha:0.5]];
        [btnLogin setEnabled:NO];
    }
}



@end
