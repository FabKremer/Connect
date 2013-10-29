//
//  SecondViewController.h
//  Connect
//
//  Created by TopTier labs on 9/21/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanditSDKBarcodePicker.h"
#import "ScanditSDKOverlayController.h"
#import "serverResponse.h"

@interface ScanViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,ScanditSDKOverlayControllerDelegate>
{
    ScanditSDKBarcodePicker *picker;
    serverResponse * sr;
    
    IBOutlet UIView *loadingView;
    IBOutlet UIActivityIndicatorView *spinner;

}

@property(nonatomic,retain) ScanditSDKBarcodePicker *picker;
@property(nonatomic,retain) UIView *loadingView;
@property(nonatomic,retain) UIActivityIndicatorView *spinner;

@end