//
//  AMWHomeViewController.m
//  ParseStarterProject
//
//  Created by Andrew on 12/4/15.
//
//

#import "AMWHomeViewController.h"
#import "AMWSettingsButtonItem.h"
#import "AMWAccountViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "AMWSearchButtonItem.h"
#import "AMWUserSearchViewController.h"
#import "AMWConstants.h"

@interface AMWHomeViewController () <UIActionSheetDelegate>
@property (nonatomic, strong) UINavigationController *presentingAccountNavController;
@property (nonatomic, strong) UINavigationController *presentingFriendNavController;
@property (nonatomic, strong) UIView *blankTimelineView;
@end


@implementation AMWHomeViewController

@synthesize firstLaunch;
@synthesize blankTimelineView;


#pragma mark - UIViewController

- (UINavigationController *)presentingAccountNavController {
    if (!_presentingAccountNavController) {
        
        AMWAccountViewController *accountViewController = [[AMWAccountViewController alloc] initWithUser:[PFUser currentUser]];
        _presentingAccountNavController = [[UINavigationController alloc] initWithRootViewController:accountViewController];
    }
    return _presentingAccountNavController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoNavigationBar.png"]];
    
    self.navigationItem.rightBarButtonItem = [[AMWSearchButtonItem alloc] initWithTarget:self action:@selector(searchButtonAction:)];
    self.navigationItem.leftBarButtonItem = [[AMWSettingsButtonItem alloc] initWithTarget:self action:@selector(settingsButtonAction:)];
    
    self.blankTimelineView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake( 33.0f, 96.0f, 253.0f, 173.0f);
    [button setBackgroundImage:[UIImage imageNamed:@"HomeTimelineBlank.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(inviteFriendsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.center = self.blankTimelineView.center;
    [self.blankTimelineView addSubview:button];
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
}


#pragma mark - PFQueryTableViewController

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    if (self.objects.count == 0) {
        self.tableView.scrollEnabled = NO;
        self.tableView.tableHeaderView = self.blankTimelineView;
    } else {
        self.tableView.tableHeaderView = nil;
        self.tableView.scrollEnabled = YES;
    }
}


#pragma mark - ()

- (void)searchButtonAction:(id)sender {
    AMWUserSearchViewController *searchViewController = [[AMWUserSearchViewController alloc] init];
    
    [self.navigationController pushViewController:searchViewController animated:NO];
}

- (void)settingsButtonAction:(id)sender {
    
    UIAlertController * view = [UIAlertController alertControllerWithTitle:@"Settings" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* logout = [UIAlertAction actionWithTitle:@"Logout" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
        [view dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction* following = [UIAlertAction actionWithTitle:@"Following" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [view dismissViewControllerAnimated:YES completion:nil];
        AMWPeopleTableViewController *followingViewController = [[AMWPeopleTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        // Query all of the users that this user is following.
        PFQuery *query = [PFQuery queryWithClassName:kAMWActivityClassKey];
        [query whereKey:kAMWActivityTypeKey equalTo:kAMWActivityTypeFollow];
        [query whereKey:kAMWActivityFromUserKey equalTo:[PFUser currentUser]];
        query.cachePolicy = kPFCachePolicyNetworkOnly;
        query.limit = 1000;
        
        followingViewController.peopleQuery = query;
        followingViewController.recalculateUser = YES;
        [self.navigationController pushViewController:followingViewController animated:YES];
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)
    {
        [view dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
    [view addAction:logout];
    [view addAction:following];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

@end
