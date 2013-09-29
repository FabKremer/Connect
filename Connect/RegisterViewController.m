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

@synthesize txtName,txtMail,txtPassword,txtPassword2,table,btnRegister,btnWrong,wrongView,txtWrong;

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
    txtName.delegate=self;
    
    txtMail.tag=2;
    txtMail.delegate=self;
    
    txtPassword.secureTextEntry = YES;
    txtPassword.tag=3;
    txtPassword.delegate=self;
    
    txtPassword2.secureTextEntry = YES;
    txtPassword2.tag=4;
    txtPassword2.delegate=self;
    
    btnRegister.clipsToBounds = YES;
    btnRegister.layer.cornerRadius = 15.0f;
    btnRegister.clipsToBounds = YES;
    [btnRegister setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:175.0/255.0f blue:240.0/255.0f alpha:0.5]];
    [btnRegister setEnabled:NO];
    btnWrong.transform = CGAffineTransformMakeRotation(45.0*M_PI/180.0);

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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0 || section== 1)
        return 1;
    else
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName=NSLocalizedString(@"Full Name", nil);
            break;
        case 1:
            sectionName=@"Mail";
            break;
        default:
            sectionName = NSLocalizedString(@"Password", nil);
            break;
    }
    return sectionName;
}

-(IBAction)cancel:(id)sender{
    UINavigationController * navigationController = self.navigationController;
    [navigationController popToRootViewControllerAnimated:YES];

}

-(IBAction)registration:(id)sender{
    
    password = txtPassword.text;
    password2 = txtPassword2.text;
    
    NSString *expression = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *match = [regex firstMatchInString:mail options:0 range:NSMakeRange(0, [mail length])];

    if (match){
        //Matches

        if ([password isEqualToString:password2]) {
        
            name = txtName.text;
            mail = txtMail.text;
            NSString * f = @"";
            NSString * l = @"";
        
            NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                                  name,@"Name",
                                  mail,@"Email",
                                  f,@"FacebookId",
                                  l,@"LinkedInId",
                                  password, @"Password",
                                  nil];
            
            // POST
            NSMutableURLRequest *request = [NSMutableURLRequest
                                            requestWithURL:[NSURL URLWithString:@"http://connectwp.azurewebsites.net/api/signup/"]];
            
            NSError *error;
            NSData *postData = [NSJSONSerialization dataWithJSONObject:info options:0 error:&error];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:postData];
            
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
            if ((long)urlResponse.statusCode == 200){
                // paso de pantalla
                [self performSegueWithIdentifier:@"shareSegueFR" sender:self];
            }
            else{
                //error 410
                //el usuario ya existe
                [wrongView setHidden:NO];
                txtPassword.text=@"";
                txtPassword2.text=@"";
                password=nil;
                password2=nil;
                [btnRegister setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:175.0/255.0f blue:240.0/255.0f alpha:0.5]];
                [btnRegister setEnabled:NO];
                txtWrong.text=NSLocalizedString(@"Mail already taken", nil);
            }
            
        }
        else{
            //las contrasenas no son igules
            [wrongView setHidden:NO];
            txtPassword.text=@"";
            txtPassword2.text=@"";
            password=nil;
            password2=nil;
            [btnRegister setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:175.0/255.0f blue:240.0/255.0f alpha:0.5]];
            [btnRegister setEnabled:NO];
            txtWrong.text=NSLocalizedString(@"Passwords doesn't match", nil);

        }
    }
    else{
        [wrongView setHidden:NO];
        txtPassword.text=@"";
        txtPassword2.text=@"";
        password=nil;
        password2=nil;
        [btnRegister setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:175.0/255.0f blue:240.0/255.0f alpha:0.5]];
        [btnRegister setEnabled:NO];
        txtWrong.text=NSLocalizedString(@"Invalid Mail", nil);
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
    
    if (textField.tag==1)//name
        name=textField.text;
    else if (textField.tag==2)//mail
        mail=textField.text;
    else if (textField.tag==3)//pass1
        password=textField.text;
    else if (textField.tag==4)//pass2
        password2=textField.text;
    
    if (name!=nil && mail!=nil && password!=nil && password2!=nil && ![name isEqualToString:@""] && ![mail isEqualToString:@""] &&![password isEqualToString:@""] &&![password2 isEqualToString:@""] ){
        [btnRegister setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:175.0/255.0f blue:240.0/255.0f alpha:1]];
        [btnRegister setEnabled:YES];
    }else{
        [btnRegister setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:175.0/255.0f blue:240.0/255.0f alpha:0.5]];
        [btnRegister setEnabled:NO];
    }
    
}



@end
