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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtnAction:(id)sender {
    NSString *username = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (user) {
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
