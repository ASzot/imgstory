//
//  AMWWelcomeViewController.m
//  ParseStarterProject
//
//  Created by Andrew on 12/4/15.
//
//

#import "AMWWelcomeViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "AMWUtility.h"

@interface AMWWelcomeViewController () {
    BOOL _presentedLoginViewController;
    
}

@end

@implementation AMWWelcomeViewController


#pragma mark - UIViewController
- (void)loadView {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [backgroundImageView setImage:[UIImage imageNamed:@"Default.png"]];
    self.view = backgroundImageView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![PFUser currentUser]) {
        [self presentLoginViewController:NO];
        return;
    }
    
    // Present Anypic UI
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] presentTabBarController];
    
    // Refresh current user with server side data -- checks if user is still valid and so on
    [[PFUser currentUser] fetchInBackgroundWithTarget:self selector:@selector(refreshCurrentUserCallbackWithResult:error:)];
}


#pragma mark - PAPWelcomeViewController

- (void)presentLoginViewController:(BOOL)animated {
    if (_presentedLoginViewController) {
        return;
    }
    
    _presentedLoginViewController = YES;
    AMWStartViewController *loginViewController = [[AMWStartViewController alloc] init];
    loginViewController.delegate = self;
    [self presentViewController:loginViewController animated:animated completion:nil];
}


#pragma mark - PAPLoginViewControllerDelegate

- (void)logInViewControllerDidLogUserIn:(AMWStartViewController *)logInViewController {
    if (_presentedLoginViewController) {
        _presentedLoginViewController = NO;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - ()

- (void)refreshCurrentUserCallbackWithResult:(PFObject *)refreshedObject error:(NSError *)error {
    // This fetches the most recent data from FB, and syncs up all data with the server including profile pic and friends list from FB.
    
    // A kPFErrorObjectNotFound error on currentUser refresh signals a deleted user
    if (error && error.code == kPFErrorObjectNotFound) {
        NSLog(@"User does not exist.");
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
        return;
    }
    
    PFUser *currentParseUser = [PFUser currentUser];
    if (!currentParseUser) {
        NSLog(@"Current Parse user does not exist, logout");
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
        return;
    }
}


@end
