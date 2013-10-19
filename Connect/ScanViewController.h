//
//  SecondViewController.h
//  Connect
//
//  Created by TopTier labs on 9/21/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ZBarSDK.h"

@interface ScanViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    IBOutlet UITextView *resultTextView;
}
@property (nonatomic, retain) IBOutlet UITextView *resultTextView;

@end