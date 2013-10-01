//
//  RegisterViewController.h
//  Connect
//
//  Created by TopTier labs on 9/21/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UIView *wrongView;
    IBOutlet UIButton *btnWrong;
    IBOutlet UILabel *txtWrong;
    
    IBOutlet UIActivityIndicatorView *spinner;

    IBOutlet UIButton *btnRegister;
    IBOutlet UIButton *btncancel;

    IBOutlet UITextField *txtName;
    IBOutlet UITextField *txtMail;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtPassword2;
    IBOutlet UITableView *table;
    
    NSString *name;
    NSString *mail;
    NSString *password;
    NSString *password2;
    
}
@property(nonatomic,retain) UIView *wrongView;
@property(nonatomic,retain) UILabel *txtWrong;

@property(nonatomic,retain) UIActivityIndicatorView *spinner;

@property(nonatomic,retain) UIButton *btnRegister;
@property(nonatomic,retain) UIButton *btnWrong;

@property(nonatomic,retain) UITextField *txtName;
@property(nonatomic,retain) UITextField *txtMail;
@property(nonatomic,retain) UITextField *txtPassword;
@property(nonatomic,retain) UITextField *txtPassword2;

@property(nonatomic,retain) UITableView *table;

-(IBAction)registration:(id)sender;
-(IBAction)cancel:(id)sender;

@end
