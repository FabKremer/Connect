//
//  SocialViewController.m
//  Connect
//
//  Created by TopTier labs on 10/20/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import "SocialViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <Foundation/NSNotificationQueue.h>
#import "BackendProxy.h"

@interface SocialViewController ()

@end

@implementation SocialViewController

@synthesize loginFb,spinner,btnContinue,loginLI,oAuthLoginView, userMail, userName, userPass,facebookID,linkedinID,btncancel,litick,fbtick;

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
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [FBSession openActiveSessionWithPermissions:nil allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState status,
                                                          NSError *error) {
                                          if (session.isOpen) {
                                              appDelegate.session=session;
                                              FBRequest *me = [FBRequest requestForMe];
                                              [me startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                                                NSDictionary<FBGraphUser> *my,
                                                                                NSError *error) {
                                                  [self.loginFb setEnabled:NO];
                                                  
                                                  NSLog(@"id %@", my.id);
                                                  self.facebookID = my.id;
                                                  
                                              }];
                                          }
                                      }];
        }
    }

    btnContinue.clipsToBounds = YES;
    btnContinue.layer.cornerRadius = 15.0f;
    [spinner setHidden:YES];
    [litick setHidden:YES];
    [fbtick setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// FBSample logic
// handler for button click, logs sessions in or out
- (IBAction)fbClicked:(id)sender {
    // get the app delegate so that we can access the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    if (appDelegate.session.state != FBSessionStateCreated) {
        // Create a new, logged out session.
        appDelegate.session = [[FBSession alloc] init];
    }
    

    
    // if the session isn't open, let's open it now and present the login UX to the user
    [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                     FBSessionState status,
                                                     NSError *error) {
        // and here we make sure to update our UX according to the new session state
        if(session.isOpen){
            [FBSession openActiveSessionWithPermissions:nil allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState status,
                                                          NSError *error) {
                                          if (session.isOpen) {
                                              FBRequest *me = [FBRequest requestForMe];
                                              [me startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                                                NSDictionary<FBGraphUser> *my,
                                                                                NSError *error) {
                                                  [self.loginFb setEnabled:NO];
                                                  [fbtick setHidden:NO];
                                                  NSLog(@"id %@", my.id);
                                                  self.facebookID = my.id;
                                                  
                                              }];
                                          }
                                      }];
            

        }
        
    }];
    

}

- (IBAction)continueClicked:(id)sender {
    if (![loginFb isEnabled]){}

    [spinner setHidden:NO];
    [spinner startAnimating];
    [self performSelectorInBackground:@selector(processContinue) withObject:self];
}

-(void)processContinue{

    if (! [BackendProxy internetConnection]){
        //si no hay conexion con el server
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Failed", nil) message:NSLocalizedString(@"No Internet Connection Register", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else{
        //agarro facebook y linkedin
        if (!self.facebookID)
            self.facebookID=@"";
        if (!self.linkedinID)
            self.linkedinID=@"";
        
        NSString * facebook = self.facebookID;
        NSString * linkedin = self.linkedinID;
        
        //llamo a la funcion de la clase BackendProxy
        serverResponse * sr = [BackendProxy enterUser :userName :userMail :facebook :linkedin :userPass];
    
        //comparo segun lo que me dio la funcion enterUser para ver como sigo
        if ([sr getCodigo] == 200){
            //paso de pantalla
            //paso de pantalla
            [self performSelectorOnMainThread:@selector(finishedLoading) withObject:nil waitUntilDone:NO];
        }
        else{
            //nunca deberia entrar aca!!
            
            //410, el usuraio ya existe, el mail acaba de ser tomado
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Registration Failed", nil) message:NSLocalizedString(@"Mail just taken", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
            [self performSegueWithIdentifier:@"registerSegueFS" sender:self];
        }
    
    
    
    }
    
    [spinner stopAnimating];
    [spinner setHidden:YES];
}

-(void)finishedLoading{
    [self performSegueWithIdentifier:@"shareSegueFR" sender:self];

}

- (IBAction)button_TouchUp:(UIButton *)sender
{
    if ([BackendProxy internetConnection]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        oAuthLoginView = [storyboard instantiateViewControllerWithIdentifier:@"linkedinpage"];
        
        // register to be told when the login is finished
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loginViewDidFinish:)
                                                     name:@"loginViewDidFinish"
                                                   object:oAuthLoginView];
        
        [self presentViewController:oAuthLoginView animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Failed", nil) message:NSLocalizedString(@"No Internet Connection Linkedin", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];

    }
}

-(void) loginViewDidFinish:(NSNotification*)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // We're going to do these calls serially just for easy code reading.
    // They can be done asynchronously
    // Get the profile, then the network updates
    [self profileApiCall];
	
}

- (void)profileApiCall
{
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~"];
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:oAuthLoginView.consumer
                                       token:oAuthLoginView.accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(profileApiCallResult:didFinish:)
                  didFailSelector:@selector(profileApiCallResult:didFail:)];
    
}

- (void)profileApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    NSDictionary *profile = [responseBody objectFromJSONString];
    
    if ( [[profile valueForKey:@"status"] integerValue]!= 404 )
    {
        NSDictionary *a =[profile objectForKey:@"siteStandardProfileRequest"];
        NSString *url = [a objectForKey:@"url"];
        NSString * q = [[[NSURL alloc] initWithString:url] query];
        NSArray * pairs = [q componentsSeparatedByString:@"&"];
        NSMutableDictionary * kvPairs = [NSMutableDictionary dictionary];
        for (NSString * pair in pairs) {
            NSArray * bits = [pair componentsSeparatedByString:@"="];
            NSString * key = [[bits objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSString * value = [[bits objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            [kvPairs setObject:value forKey:key];
        }
        self.linkedinID=url;//[kvPairs objectForKey:@"id"]
        NSLog(@"id = %@", [kvPairs objectForKey:@"id"]);
        [self.loginLI setEnabled:NO];
        [litick setHidden:NO];
    }
    
    // The next thing we want to do is call the network updates
    //[self networkApiCall];
    
}

- (void)profileApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
}

- (void)networkApiCall
{
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~/network/updates?scope=self&count=1&type=STAT"];
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:oAuthLoginView.consumer
                                       token:oAuthLoginView.accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(networkApiCallResult:didFinish:)
                  didFailSelector:@selector(networkApiCallResult:didFail:)];
    
}

- (void)networkApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    NSDictionary *person = [[[[[responseBody objectFromJSONString]
                               objectForKey:@"values"]
                              objectAtIndex:0]
                             objectForKey:@"updateContent"]
                            objectForKey:@"person"];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)networkApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
}

-(IBAction)cancel:(id)sender{
    UINavigationController * navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
    
}


@end
