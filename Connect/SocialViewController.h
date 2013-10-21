//
//  SocialViewController.h
//  Connect
//
//  Created by TopTier labs on 10/20/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialViewController : UIViewController{
    IBOutlet UIButton *loginFb;
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UIButton *btnContinue;

}

@property(nonatomic,retain) UIButton *loginFb;
@property(nonatomic,retain) UIButton *btnContinue;

@property(nonatomic,retain) UIActivityIndicatorView *spinner;

- (IBAction)fbClicked:(id)sender;
- (IBAction)continueClicked:(id)sender;

@end
