//
//  AMWLoginViewController.m
//  MyWall
//
//  Created by Andrew on 12/15/15.
//  Copyright © 2015 AndrewSzot. All rights reserved.
//

#import "AMWLoginViewController.h"
#import <Parse/Parse.h>

@interface AMWLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorMsgLbl;

@end

@implementation AMWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor colorWithRed:74.0f/255.0f green:163.0f/255.0f blue:223.0f/255.0f alpha:1.0f] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    self.userNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)loginBtnAction:(id)sender {
    NSString *username = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (user) {
            [self.delegate performSelector:@selector(logSignActionOccured)];
        }
        else {
            //NSString *errorStr = [error userInfo][@"error"];
            self.errorMsgLbl.text = @"Invalid username/password";
        }
    }];
}

- (IBAction)cancelBtnAction:(id)sender {
    [self.delegate performSelector:@selector(logSignActionOccured)];
}

@end
