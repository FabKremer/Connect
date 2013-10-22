//
//  SecondViewController.h
//  Connect
//
//  Created by TopTier labs on 9/21/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ZBarSDK.h"
#import "ScanditSDKBarcodePicker.h"
#import "ScanditSDKOverlayController.h"

@interface ScanViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,ScanditSDKOverlayControllerDelegate>
{
    ScanditSDKBarcodePicker *picker;
}

@property(nonatomic,retain) ScanditSDKBarcodePicker *picker;

@end