//
//  FirstViewController.h
//  Connect
//
//  Created by TopTier labs on 9/21/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UIViewController{
    IBOutlet UIButton *btnBack;
    IBOutlet UIButton *btnSettings;
    IBOutlet UIImageView *QRImage;
}

@property(nonatomic,retain) UIButton *btnBack;
@property(nonatomic,retain) UIButton *btnSettings;
@property(nonatomic,retain) UIImageView *QRImage;

-(IBAction)back:(id)sender;
-(IBAction)settings:(id)sender;

@end
