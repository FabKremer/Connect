//
//  RegisterViewController.m
//  Connect
//
//  Created by TopTier labs on 9/21/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import "RegisterViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BackendProxy.h"
#import "SocialViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize txtName,txtMail,txtPassword,txtPassword2,table,btnRegister,btnWrong,wrongView,txtWrong,spinner;

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];

    table.dataSource=self;
    
    txtName.tag=1;
    txtName.delegate=self;
    
    txtMail.tag=2;
    txtMail.delegate=self;
    [txtMail setKeyboardType:UIKeyboardTypeEmailAddress];
    
    txtPassword.secureTextEntry = YES;
    txtPassword.tag=3;
    txtPassword.delegate=self;
    
    txtPassword2.secureTextEntry = YES;
    txtPassword2.tag=4;
    txtPassword2.delegate=self;
    
    btnRegister.clipsToBounds = YES;
    btnRegister.layer.cornerRadius = 15.0f;
    btnRegister.clipsToBounds = YES;

    btnWrong.transform = CGAffineTransformMakeRotation(45.0*M_PI/180.0);

    [wrongView setHidden:YES];
    [spinner setHidden:YES];
}

-(void)dismissKeyboard {
    [txtMail resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtName resignFirstResponder];
    [txtPassword2 resignFirstResponder];
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
    [spinner setHidden:NO];
    [spinner startAnimating];
    [self performSelectorInBackground:@selector(processRegistration) withObject:self];

    
}

-(void)processRegistration{
    password = txtPassword.text;
    password2 = txtPassword2.text;
    if (name!=nil && mail!=nil && password!=nil && password2!=nil && ![name isEqualToString:@""] && ![mail isEqualToString:@""] &&![password isEqualToString:@""] &&![password2 isEqualToString:@""] ){
        if ([password length]>=6){
            NSString *expression = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSError *error = NULL;
            
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
            
            NSTextCheckingResult *match = [regex firstMatchInString:mail options:0 range:NSMakeRange(0, [mail length])];
            
            if (match){
                //Matches
                if ([password isEqualToString:password2]) {
                    
                    if (! [BackendProxy internetConnection]){
                        //si no hay conexion con el server
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Failed", nil) message:NSLocalizedString(@"No Internet Connection Register", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                        [alert show];
                    }
                    else{

                    
                        name = txtName.text;
                        mail = txtMail.text;
                    
                        //llamo a la funcion de la clase BackendProxy para ver si el mail esta ocupado
                        serverResponse * sr = [BackendProxy getUserByMail:mail];
                    
                        //verifico el resultado de la funcion getUserByMail
                        if ([sr getCodigo] == 200){
                            //el usuario ya existe
                            [wrongView setHidden:NO];
                            txtPassword.text=@"";
                            txtPassword2.text=@"";
                            password=nil;
                            password2=nil;
                            txtWrong.text=NSLocalizedString(@"Mail already taken", nil);
                        }
                        else{
                            //404, el usuario no existe
                            //paso de pantalla
                            [self performSelectorOnMainThread:@selector(finishedLoading) withObject:nil waitUntilDone:NO];
                        }
                        
                    }
                    
                }
                else{
                    //las contrasenas no son igules
                    [wrongView setHidden:NO];
                    txtPassword.text=@"";
                    txtPassword2.text=@"";
                    password=nil;
                    password2=nil;
                    txtWrong.text=NSLocalizedString(@"Passwords doesn't match", nil);
                    
                }
            }
            else{
                [wrongView setHidden:NO];
                txtPassword.text=@"";
                txtPassword2.text=@"";
                password=nil;
                password2=nil;
                txtWrong.text=NSLocalizedString(@"Invalid Mail", nil);
            }
        }
        else{
            [wrongView setHidden:NO];
            txtWrong.text=NSLocalizedString(@"Password too short", nil);
            txtPassword.text=@"";
            txtPassword2.text=@"";
            password=nil;
            password2=nil;


        }
    }else{
        [wrongView setHidden:NO];
        txtWrong.text=NSLocalizedString(@"Complete all the fields to register", nil);
        txtPassword.text=@"";
        txtPassword2.text=@"";
        password=nil;
        password2=nil;


    }
    
    [spinner stopAnimating];
    [spinner setHidden:YES];
}

-(void)finishedLoading{
    [self performSegueWithIdentifier:@"socialSegue" sender:self];
}

 - (void)textFieldDidBeginEditing:(UITextField *)textField
 {
     if (textField.tag==3 || textField.tag==4 )//pass1 or pass2 that are hidden if not
         [self animateTextField: textField up: YES];
 }

 - (void) animateTextField: (UITextField*) textField up: (BOOL) up
 {
     const int movementDistance = 80;
     const float movementDuration = 0.3f; // tweak as needed
     
     int movement = (up ? -movementDistance : movementDistance);
     
     [UIView beginAnimations: @"anim" context: nil];
     [UIView setAnimationBeginsFromCurrentState: YES];
     [UIView setAnimationDuration: movementDuration];
     self.view.frame = CGRectOffset(self.view.frame, 0, movement);
     [UIView commitAnimations];
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
    
    if (textField.tag==3 || textField.tag==4 )//pass1 or pass2 that are hidden if not
        [self animateTextField: textField up: NO];
    
    if (textField.tag==1)//name
        name=textField.text;
    else if (textField.tag==2)//mail
        mail=textField.text;
    else if (textField.tag==3)//pass1
        password=textField.text;
    else if (textField.tag==4)//pass2
        password2=textField.text;
    
//    if (name!=nil && mail!=nil && password!=nil && password2!=nil && ![name isEqualToString:@""] && ![mail isEqualToString:@""] &&![password isEqualToString:@""] &&![password2 isEqualToString:@""] ){
//        [btnRegister setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:175.0/255.0f blue:240.0/255.0f alpha:1]];
//        [btnRegister setEnabled:YES];
//    }else{
//        [btnRegister setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:175.0/255.0f blue:240.0/255.0f alpha:0.5]];
//        [btnRegister setEnabled:NO];
//    }
    
}

//paso de valores entre views
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"socialSegue"])
    {
        // referencia de la view
         SocialViewController * vc = [segue destinationViewController];
        
        //seteo de variables
        vc.userName = name;
        vc.userMail = mail;
        vc.userPass = password;
    }
}

@end
