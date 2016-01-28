//
//  SignupViewController.m
//  MyWall
//
//  Created by Andrew on 12/19/15.
//  Copyright © 2015 AndrewSzot. All rights reserved.
//

#import "AMWSignupViewController.h"
#import "AMWUtility.h"
#import <Parse/Parse.h>

@interface AMWSignupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtField;
@property (weak, nonatomic) IBOutlet UITextField *displayNameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *checkPassTxtField;
@property (weak, nonatomic) IBOutlet UILabel *errorMsgLbl;
@property (weak, nonatomic) IBOutlet UISwitch *ageReqCheck;

@end

@implementation AMWSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor colorWithRed:74.0f/255.0f green:163.0f/255.0f blue:223.0f/255.0f alpha:1.0f] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    self.usernameTxtField.delegate = self;
    self.passwordTxtField.delegate = self;
    self.displayNameTxtField.delegate = self;
    self.checkPassTxtField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)signUpBtnAction:(id)sender {
    // Ensure that the entered passwords are matching.
    
    if (![self.passwordTxtField.text isEqualToString:self.checkPassTxtField.text]) {
        self.errorMsgLbl.text = @"Passwords do not match.";
        return;
    }
    
    
    NSString *password = self.passwordTxtField.text;
    NSString *username = self.usernameTxtField.text;
    NSString *displayName = self.displayNameTxtField.text;
    
    NSString *errorText = nil;
    if (username.length > 25)
        errorText = @"Usernames must be less than 25 characters.";
    else if (displayName.length > 25)
        errorText = @"Display name must be less than 25 characters.";
    else if (![self.ageReqCheck isOn])
        errorText = @"Must be over 13 years old";
    else {
        errorText = [AMWUtility checkPassword:password];
    }
    
    if (errorText != nil) {
        self.errorMsgLbl.text = errorText;
        return;
    }
    
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    
    user[@"displayName"] = displayName;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The user is now signed up.
            [self.delegate performSelector:@selector(logSignActionOccured)];
        }
        else {
            NSString *errorStr = [error userInfo][@"error"];
            self.errorMsgLbl.text = errorStr;
        }
    }];
}
- (IBAction)cancelBtnAction:(id)sender {
    [self.delegate performSelector:@selector(logSignActionOccured)];
}

@end
