//
//  SecondViewController.m
//  Connect
//
//  Created by TopTier labs on 9/21/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController ()

@end

@implementation ScanViewController

@synthesize resultTextView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"holaaaa1");
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.view.bounds=self.view.bounds;
    
    reader.readerDelegate = self;
    reader.readerView.torchMode = 0;
    reader.showsCameraControls=NO;
    ZBarImageScanner *scanner = reader.scanner;
    
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25 //ZBAR_QRCODE
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    //reader.readerView.zoom = 1.0;
    
    // present and release the controller
    //[self presentViewController:reader animated:YES completion:nil];
    
    //[reader release];
    
    resultTextView.hidden=NO;
    
    [self.view addSubview:reader.cameraOverlayView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry{
    NSLog(@"the image picker failing to read");
    
}

- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    
    NSLog(@"holaaaa2");
    
    NSLog(@"the image picker is calling successfully %@",info);
    // ADD: get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    NSString *hiddenData;
    for(symbol in results)
        hiddenData=[NSString stringWithString:symbol.data];
    NSLog(@"the symbols  is the following %@",symbol.data);
    // EXAMPLE: just grab the first barcode
    //  break;
    
    // EXAMPLE: do something useful with the barcode data
    //resultText.text = symbol.data;
    resultTextView.text=symbol.data;
    
    
    NSLog(@"BARCODE= %@",symbol.data);
    
    NSUserDefaults *storeData=[NSUserDefaults standardUserDefaults];
    [storeData setObject:hiddenData forKey:@"CONSUMERID"];
    NSLog(@"SYMBOL : %@",hiddenData);
    resultTextView.text=hiddenData;
    
    
    [reader dismissViewControllerAnimated:NO completion:nil];
    //[reader dismissViewControllerAnimated:YES completion:nil];
    
    [self performSegueWithIdentifier:@"shareSegueDone" sender:self];
    
}

@end