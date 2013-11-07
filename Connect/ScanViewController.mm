//
//  SecondViewController.m
//  Connect
//
//  Created by TopTier labs on 9/21/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import "ScanViewController.h"
#import "serverResponse.h"
#import "BackendProxy.h"
#import "ConnectViewController.h"

#define kScanditSDKAppKey    @"/Q44QDqYEeOfkoRnTkZF0Ie2RHLA2J2t8Cg92zgYL0I"

@interface ScanViewController ()

@end

@implementation ScanViewController

@synthesize picker,spinner,loadingView;

- (void)viewDidLoad
{
    [super viewDidLoad];
     picker = [[ScanditSDKBarcodePicker alloc] initWithAppKey:kScanditSDKAppKey];
	
	[picker.overlayController showSearchBar:NO];
	[picker.overlayController setCameraSwitchVisibility:CAMERA_SWITCH_ON_TABLET];
    
	// Set the delegate to receive callbacks.
	picker.overlayController.delegate = self;
	
	[picker startScanning];
    
    [self.view addSubview:picker.view];
    [self.loadingView setHidden:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self.picker startScanning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * This delegate method of the ScanditSDKOverlayController protocol needs to be implemented by
 * every app that uses the ScanditSDK and this is where the custom application logic goes.
 * In the example below, we are just showing an alert view with the result.
 */
- (void)scanditSDKOverlayController:(ScanditSDKOverlayController *)scanditSDKOverlayController1
                     didScanBarcode:(NSDictionary *)barcodeResult {
	
    //empiezo a correr el spinner
    [self.loadingView setHidden:NO];
    [self.view bringSubviewToFront:self.loadingView];
    [self.spinner setHidden:NO];
    [self.spinner startAnimating];
    [self.picker stopScanning];
    NSString *barcode = [barcodeResult objectForKey:@"barcode"];
    @try {
        // Try something
        
        //trato de parsear el barcode y me quedo con el id del usuario
        NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
        NSArray *urlComponents = [barcode componentsSeparatedByString:@"?"];
        if ([[urlComponents objectAtIndex:0] isEqualToString:@"pis2013.azurewebsites.net/"]){
            NSArray *pairComponents = [[urlComponents objectAtIndex:1] componentsSeparatedByString:@"="];
            NSString *key = [pairComponents objectAtIndex:0];
            NSString *value = [pairComponents objectAtIndex:1];
            
            [queryStringDictionary setObject:value forKey:key];
            
            
            [self performSelectorInBackground:@selector(processConnection:) withObject:[queryStringDictionary objectForKey:@"id"]];

        }else{
            [self performSelectorInBackground:@selector(processConnection:) withObject:@"error"];
        }

    }
    @catch (NSException * e) {
        //lei algo que no fuera de la forma pis2013.azurewebsites.net/?id=XXXXX
        [self performSelectorInBackground:@selector(processConnection:) withObject:@"error"];
    }


}

-(void)processConnection:(NSString*)barcode{
    //esto es lo que saco del escanner
    if (! [BackendProxy internetConnection]){
        //si no hay conexion con el server
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Failed", nil) message:NSLocalizedString(@"No Internet Connection Connect", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString * user = [defaults stringForKey:@"id"];
        if ([barcode isEqualToString:user]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connect Failed", nil) message:NSLocalizedString(@"User does not exist", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [self performSelectorOnMainThread:@selector(failedScan) withObject:nil waitUntilDone:NO];

        }else{
            //llamo a la funcion de BackendProxy para hacer amigos
            sr = [BackendProxy addFriends:barcode];
            

            if ([sr getCodigo] == 200){
                //si se hacen amigos, paso de pantalla
                [self performSelectorOnMainThread:@selector(finishScan) withObject:nil waitUntilDone:NO];
            }
            else if ([sr getCodigo] == 404){
                //404, el usuraio no existe, no se pueden hacer amigos
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connect Failed", nil) message:NSLocalizedString(@"User does not exist", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                [self performSelectorOnMainThread:@selector(failedScan) withObject:nil waitUntilDone:NO];


     
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connect Failed", nil) message:NSLocalizedString(@"The QR may not be a Connect User", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                [self performSelectorOnMainThread:@selector(failedScan) withObject:nil waitUntilDone:NO];

            }
        }
    }
    
    [self.loadingView setHidden:YES];
    [self.spinner stopAnimating];


}

-(void)finishScan{
    [self performSegueWithIdentifier:@"connectSegue" sender:self];

}

-(void)failedScan{
    [NSThread sleepForTimeInterval:2.0f];
    [self.picker startScanning];
}

/**
 * This delegate method of the ScanditSDKOverlayController protocol needs to be implemented by
 * every app that uses the ScanditSDK and this is where the custom application logic goes.
 * In the example below, we are not doing anything because the app only consists of the scan screen.
 */
- (void)scanditSDKOverlayController:(ScanditSDKOverlayController *)scanditSDKOverlayController1
                didCancelWithStatus:(NSDictionary *)status {
}

/**
 * This delegate method of the ScanditSDKOverlayController protocol needs to be implemented by
 * every app that uses the ScanditSDK and this is where the custom application logic goes.
 * In the example below, we are just showing an alert view with the result.
 */
- (void)scanditSDKOverlayController:(ScanditSDKOverlayController *)scanditSDKOverlayController
                    didManualSearch:(NSString *)input {
	
	//[picker stopScanningAndKeepTorchState];
	
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Manual input"]
                                                    message:input
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

//paso de valores entre views
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"connectSegue"])
    {
        // referencia de la view
        ConnectViewController * vc = [segue destinationViewController];
        
        //seteo de variables
        vc.scanUser = sr;
    }
}


@end