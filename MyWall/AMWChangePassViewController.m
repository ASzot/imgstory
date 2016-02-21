//
//  AMWChangePassViewController.m
//  imgStory
//
//  Created by Andrew Szot on 1/27/16.
//  Copyright © 2016 AndrewSzot. All rights reserved.
//

#import "AMWChangePassViewController.h"
#import "AMWUtility.h"

@interface AMWChangePassViewController () {
    PFUser *user;
}

@property (weak, nonatomic) IBOutlet UITextField *currentPassTxtField;
@property (weak, nonatomic) IBOutlet UITextField *enterNewPassTxtField;
@property (weak, nonatomic) IBOutlet UITextField *confirmNewPassTxtField;
@property (weak, nonatomic) IBOutlet UILabel *errorLbl;

@end

@implementation AMWChangePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the background gradient.
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor colorWithRed:74.0f/255.0f green:163.0f/255.0f blue:223.0f/255.0f alpha:1.0f] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    self.currentPassTxtField.delegate = self;
    self.enterNewPassTxtField.delegate = self;
    self.confirmNewPassTxtField.delegate = self;
    
    user = [PFUser currentUser];
    if (user == nil) {
        [self cancelBtnAction:nil];
    }
}
- (IBAction)applyBtnAction:(id)sender {
    NSString *currentPassStr = self.currentPassTxtField.text;
    NSString *passStr = self.currentPassTxtField.text;
    NSString *confirmPassStr = self.confirmNewPassTxtField.text;
    
    NSString *errorTxt = nil;
    NSString *checkPass = user.password;
    if (user.password == nil)
        errorTxt = @"No data connection to get password";
    else if ([checkPass isEqualToString:@""])
        errorTxt = @"Enter your current password";
    else if (![checkPass isEqualToString:currentPassStr])
        errorTxt = @"Invalid current password";
    else if (![passStr isEqualToString:confirmPassStr])
        errorTxt = @"Passwords do not match";
    else
        errorTxt = [AMWUtility checkPassword:passStr];
    
    if (errorTxt != nil) {
        self.errorLbl.text = errorTxt;
    }
    else {
        user.password = passStr;
        [user saveInBackground];
        [self.delegate onDismissChangePassViewController];
    }
}
- (IBAction)cancelBtnAction:(id)sender {
    [self.delegate onDismissChangePassViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}



@end
