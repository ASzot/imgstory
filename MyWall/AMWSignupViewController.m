//
//  SignupViewController.m
//  MyWall
//
//  Created by Andrew on 12/19/15.
//  Copyright © 2015 AndrewSzot. All rights reserved.
//

#import "AMWSignupViewController.h"
#import <Parse/Parse.h>

@interface AMWSignupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtField;
@property (weak, nonatomic) IBOutlet UITextField *displayNameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *checkPassTxtField;
@property (weak, nonatomic) IBOutlet UILabel *errorMsgLbl;

@end

@implementation AMWSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLogin.png"]];
    
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
