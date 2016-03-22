//
//  AMWChangePassViewController.m
//  imgStory
//
//  Created by Andrew Szot on 1/27/16.
//  Copyright © 2016 AndrewSzot. All rights reserved.
//

#import "AMWChangePassViewController.h"
#import "AMWUtility.h"
#import "AppDelegate.h"

@interface AMWChangePassViewController () {
    PFUser *user;
}

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
    
    self.enterNewPassTxtField.delegate = self;
    self.confirmNewPassTxtField.delegate = self;
    
    user = [PFUser currentUser];
    if (user == nil) {
        [self cancelBtnAction:nil];
    }
}
- (IBAction)applyBtnAction:(id)sender {
    NSString *passStr = self.enterNewPassTxtField.text;
    NSString *confirmPassStr = self.confirmNewPassTxtField.text;
    
    NSString *errorTxt = nil;
    if (![passStr isEqualToString:confirmPassStr])
        errorTxt = @"Passwords do not match";
    else
        errorTxt = [AMWUtility checkPassword:passStr];
    
    if (errorTxt != nil) {
        self.errorLbl.text = errorTxt;
    }
    else {
        user.password = passStr;
        [user saveInBackground];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Password Changed" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
            //[self.delegate onDismissChangePassViewController];
            // Just log the user out.
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
        }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
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
