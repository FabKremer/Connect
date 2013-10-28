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

@synthesize picker;

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
	
	//[picker stopScanningAndKeepTorchState];
	
//    NSString *symbology = [barcodeResult objectForKey:@"symbology"];
    
    //esto es lo que saco del escanner
	NSString *barcode = [barcodeResult objectForKey:@"barcode"];
    
//    UIAlertView *alert = [[UIAlertView alloc]
//						  initWithTitle:[NSString stringWithFormat:@"Scanned %@", symbology]
//						  message:barcode
//						  delegate:self
//						  cancelButtonTitle:@"OK"
//					      otherButtonTitles:nil];
//	[alert show];
    
    
    if (! [BackendProxy internetConnection]){
        //si no hay conexion con el server
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Failed", nil) message:NSLocalizedString(@"No Internet Connection Connect", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else{
    
        //llamo a la funcion de BackendProxy para hacer amigos
        sr = [BackendProxy addFriends:barcode];
        
        if ([sr getCodigo] == 200){
            //si se hacen amigos, paso de pantalla
            [self performSegueWithIdentifier:@"connectSegue" sender:self];
        }
        else{
            //404, el usuraio no existe, no se pueden hacer amigos
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connect Failed", nil) message:NSLocalizedString(@"User does not exist", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }

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