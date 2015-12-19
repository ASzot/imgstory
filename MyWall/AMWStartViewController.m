
//
//  AMWLoginViewController.m
//  ParseStarterProject
//
//  Created by Andrew on 12/4/15.
//
//

#import "AMWStartViewController.h"
#import "ParseStarterProjectAppDelegate.h"
#import "AMWLoginViewController.h"
#import "AMWSignupViewController.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>

@interface AMWStartViewController () {
    // Put facebook login objects here if you want.
}

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation AMWStartViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLogin.png"]];
    
    // Position of the buttons.
    CGFloat yPosition = 360.0f;
    
    const float loginBtnWidth = 244.0f;
    const float signUpBtnWidth = 244.0f;
    const float btnHeight = 44.0f;
    
    float xCenter = (self.view.frame.size.width - loginBtnWidth) / 2.0f;
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitle:@"Login" forState:UIControlStateNormal];
    loginBtn.frame = CGRectMake(xCenter, yPosition, loginBtnWidth, btnHeight);
    [self.view addSubview:loginBtn];
    
    xCenter = (self.view.frame.size.width - signUpBtnWidth) / 2.0f;
    yPosition += 60.0f;
    
    UIButton *signUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [signUpBtn addTarget:self action:@selector(signUpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [signUpBtn setTitle:@"Sign Up" forState:UIControlStateNormal];
    signUpBtn.frame = CGRectMake(xCenter, yPosition, signUpBtnWidth, btnHeight);
    [self.view addSubview:signUpBtn];
}

- (void)loginBtnAction:(id)sender {
    // Present the login view controller.
    AMWLoginViewController *loginViewController = [[AMWLoginViewController alloc] init];
    loginViewController.delegate = self;
    [self presentViewController:loginViewController animated:YES completion:nil];
}

- (void)signUpBtnAction:(id)sender {
    // Present the sign up view controller.
    AMWSignupViewController *signUpViewController = [[AMWSignupViewController alloc] init];
    signUpViewController.delegate = self;
    [self presentViewController:signUpViewController animated:YES completion:nil];
}

-(void)logSignActionOccured {
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([PFUser currentUser]) {
        [self.delegate performSelector:@selector(logInViewControllerDidLogUserIn:) withObject:[PFUser currentUser]];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - ()

- (void)cancelLogIn:(NSError *)error {
    
    if (error) {
        [self handleLogInError:error];
    }
    
    [self.hud removeFromSuperview];
    [PFUser logOut];
    [(ParseStarterProjectAppDelegate *)[[UIApplication sharedApplication] delegate] presentLoginViewController:NO];
}

- (void)handleLogInError:(NSError *)error {
    if (error) {
        NSLog(@"Error: %@", [[error userInfo] objectForKey:@"com.facebook.sdk:ErrorLoginFailedReason"]);
        NSString *title = NSLocalizedString(@"Login Error", @"Login error title in AMWLogInViewController");
        NSString *message = NSLocalizedString(@"Something went wrong. Please try again.", @"Login error message in AMWLogInViewController");
        NSString *okStr = NSLocalizedString(@"OK", @"OK");
        
        if ([[[error userInfo] objectForKey:@"com.facebook.sdk:ErrorLoginFailedReason"] isEqualToString:@"com.facebook.sdk:UserLoginCancelled"]) {
            return;
        }
        
        if (error.code == kPFErrorFacebookInvalidSession) {
            NSLog(@"Invalid session, logging out.");
            return;
        }
        
        if (error.code == kPFErrorConnectionFailed) {
            title = NSLocalizedString(@"Offline Error", @"Offline Error");
            message = NSLocalizedString(@"Something went wrong. Please try again.", @"Offline message");
        }
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message: message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:okStr style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


@end
