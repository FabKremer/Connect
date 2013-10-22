//
//  SecondViewController.m
//  Connect
//
//  Created by TopTier labs on 9/21/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import "ScanViewController.h"
#import "Reachability.h"

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
	
	[picker stopScanningAndKeepTorchState];
	
    NSString *symbology = [barcodeResult objectForKey:@"symbology"];
	NSString *barcode = [barcodeResult objectForKey:@"barcode"];
    UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:[NSString stringWithFormat:@"Scanned %@", symbology]
						  message:barcode
						  delegate:self
						  cancelButtonTitle:@"OK"
					      otherButtonTitles:nil];
	[alert show];
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
	
	[picker stopScanningAndKeepTorchState];
	
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Manual input"]
                                                    message:input
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


@end