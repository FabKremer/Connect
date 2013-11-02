//
//  SocialViewController.h
//  Connect
//
//  Created by TopTier labs on 10/20/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthLoginView.h"
#import "JSONKit.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"

@interface SocialViewController : UIViewController{
    IBOutlet UIButton *loginFb;
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UIButton *btnContinue;
    IBOutlet UIButton *loginLI;
    IBOutlet UIButton *btncancel;
    IBOutlet UIImageView *fbtick;
    IBOutlet UIImageView *litick;
    NSString * userName;
    NSString * userMail;
    NSString * userPass;
    NSString * linkedinID;
    NSString * facebookID;

    
}

@property(nonatomic,retain) UIButton *loginFb;
@property(nonatomic,retain) UIButton *loginLI;
@property(nonatomic,retain) UIButton *btnContinue;
@property(nonatomic,retain) UIButton *btncancel;

@property(nonatomic,retain) UIImageView *fbtick;
@property(nonatomic,retain) UIImageView *litick;

@property(nonatomic,retain) UIActivityIndicatorView *spinner;
@property(nonatomic, retain) OAuthLoginView *oAuthLoginView;

@property(nonatomic, retain) NSString * userName;
@property(nonatomic, retain) NSString * userMail;
@property(nonatomic, retain) NSString * userPass;

@property(nonatomic, retain) NSString * linkedinID;
@property(nonatomic, retain) NSString * facebookID;

- (IBAction)fbClicked:(id)sender;

- (IBAction)continueClicked:(id)sender;
- (IBAction)button_TouchUp:(UIButton *)sender;

- (IBAction)cancel:(UIButton *)sender;
- (void)profileApiCall;
- (void)networkApiCall;

@end
