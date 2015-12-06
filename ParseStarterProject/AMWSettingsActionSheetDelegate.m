//
//  AMWSettingsActionSheetDelegate.m
//  ParseStarterProject
//
//  Created by Andrew on 12/5/15.
//
//

#import "AMWSettingsActionSheetDelegate.h"
#import "AMWFindFriendsViewController.h"
#import "AMWAccountViewController.h"
#import "ParseStarterProjectAppDelegate.h"

// ActionSheet button indexes
typedef enum {
    kPAPSettingsProfile = 0,
    kPAPSettingsFindFriends,
    kPAPSettingsLogout,
    kPAPSettingsNumberOfButtons
} kPAPSettingsActionSheetButtons;

@implementation AMWSettingsActionSheetDelegate

@synthesize navController;

#pragma mark - Initialization

- (id)initWithNavigationController:(UINavigationController *)navigationController {
    self = [super init];
    if (self) {
        navController = navigationController;
    }
    return self;
}

- (id)init {
    return [self initWithNavigationController:nil];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!self.navController) {
        [NSException raise:NSInvalidArgumentException format:@"navController cannot be nil"];
        return;
    }
    
    switch ((kPAPSettingsActionSheetButtons)buttonIndex) {
        case kPAPSettingsProfile:
        {
            AMWAccountViewController *accountViewController = [[AMWAccountViewController alloc] initWithUser:[PFUser currentUser]];
            [navController pushViewController:accountViewController animated:YES];
            break;
        }
        case kPAPSettingsFindFriends:
        {
            AMWFindFriendsViewController *findFriendsVC = [[AMWFindFriendsViewController alloc] init];
            [navController pushViewController:findFriendsVC animated:YES];
            break;
        }
        case kPAPSettingsLogout:
            // Log out user and present the login view controller
            [(ParseStarterProjectAppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
            break;
        default:
            break;
    }
}

@end
