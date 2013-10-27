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

@interface SocialViewController ()

@end

@implementation SocialViewController

@synthesize loginFb,spinner,btnContinue,loginLI,oAuthLoginView;

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
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                [self.loginFb setEnabled:NO];
            }];
        }
    }

    btnContinue.clipsToBounds = YES;
    btnContinue.layer.cornerRadius = 15.0f;
    [spinner setHidden:YES];

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
        [self.loginFb setEnabled:NO];
    }];

}

- (IBAction)continueClicked:(id)sender {
    if (![loginFb isEnabled]){}
        //no esta habilitado entonces inicio sesion entonces le mando al servidor el id de facebook
        //para eso tambien tengo que empezar a hacer rodar el spinner
    
    //por ahora hagamos que solo te vaya a la pantalla de inicio.
    [self performSegueWithIdentifier:@"shareSegueFR" sender:self];
}

//- (IBAction)liClicked:(id)sender {
//    NSURL *facebookURL = [NSURL URLWithString:@"fb://profile/113810631976867"];
//    if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
//        [[UIApplication sharedApplication] openURL:facebookURL];
//    } else {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://facebook.com/mariarodriguez"]];
//    }
//
//    
//
//}

- (IBAction)button_TouchUp:(UIButton *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    oAuthLoginView = [storyboard instantiateViewControllerWithIdentifier:@"linkedinpage"];
    
    // register to be told when the login is finished
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginViewDidFinish:)
                                                 name:@"loginViewDidFinish"
                                               object:oAuthLoginView];
    
    [self presentViewController:oAuthLoginView animated:YES completion:nil];
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
    
    if ( profile )
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
        
        NSLog(@"id = %@", [kvPairs objectForKey:@"id"]);
    }
    [self.loginLI setEnabled:NO];
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


@end
