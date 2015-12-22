//
//  AMWActivityFeedViewController.m
//  ParseStarterProject
//
//  Created by Andrew on 11/29/15.
//
//

#import "AMWActivityFeedViewController.h"
#import "AMWSettingsActionSheetDelegate.h"
#import "AMWActivityCell.h"
#import "AMWAccountViewController.h"
#import "AMWPhotoDetailsViewController.h"
#import "AMWBaseTextCell.h"
#import "AMWLoadMoreCell.h"
#import "AMWSettingsButtonItem.h"
#import "MBProgressHUD.h"
#import "ParseStarterProjectAppDelegate.h"
#import "AMWConstants.h"

@interface AMWActivityFeedViewController () <UIActionSheetDelegate>
@property (nonatomic, strong) AMWSettingsActionSheetDelegate *settingsActionSheetDelegate;
@property (nonatomic, strong) UINavigationController *presentingAccountNavController;
@property (nonatomic, strong) UINavigationController *presentingFriendNavController;
@property (nonatomic, strong) NSDate *lastRefresh;
@property (nonatomic, strong) UIView *blankTimelineView;
@end


@implementation AMWActivityFeedViewController

@synthesize settingsActionSheetDelegate;
@synthesize lastRefresh;
@synthesize blankTimelineView;

#pragma mark - Initialization

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name: AMWAppDelegationApplicationDidReceiveRemoteNotification object:nil];
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // The className to query on
        self.parseClassName = kAMWActivityClassKey;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 15;
        
        // The Loading text clashes with the dark Anypic design
        self.loadingViewEnabled = NO;
    }
    return self;
}


#pragma mark - UIViewController

- (UINavigationController *)presentingAccountNavController {
    if (!_presentingAccountNavController) {
        
        AMWAccountViewController *accountViewController = [[AMWAccountViewController alloc] initWithUser:[PFUser currentUser]];
        _presentingAccountNavController = [[UINavigationController alloc] initWithRootViewController:accountViewController];
    }
    return _presentingAccountNavController;
}

- (void)viewDidLoad {
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    [super viewDidLoad];
    
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    [texturedBackgroundView setBackgroundColor:[UIColor blackColor]];
    self.tableView.backgroundView = texturedBackgroundView;
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoNavigationBar.png"]];
    
    // Add Settings button
    self.navigationItem.rightBarButtonItem = [[AMWSettingsButtonItem alloc] initWithTarget:self action:@selector(settingsButtonAction:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveRemoteNotification:) name:AMWAppDelegationApplicationDidReceiveRemoteNotification object:nil];
    
    self.blankTimelineView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"ActivityFeedBlank.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(24.0f, 113.0f, 271.0f, 140.0f)];
//    [button addTarget:self action:@selector(inviteFriendsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.blankTimelineView addSubview:button];
    
    lastRefresh = [[NSUserDefaults standardUserDefaults] objectForKey:kAMWUserDefaultsActivityFeedViewControllerLastRefreshKey];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.separatorColor = [UIColor colorWithRed:30.0f/255.0f green:30.0f/255.0f blue:30.0f/255.0f alpha:1.0f];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        NSString *activityString = [AMWActivityFeedViewController stringForActivityType:(NSString*)[object objectForKey:kAMWActivityTypeKey]];
        
        PFUser *user = (PFUser*)[object objectForKey:kAMWActivityFromUserKey];
        NSString *nameString = NSLocalizedString(@"Someone", nil);
        if (user && [user objectForKey:kAMWUserDisplayNameKey] && [[user objectForKey:kAMWUserDisplayNameKey] length] > 0) {
            nameString = [user objectForKey:kAMWUserDisplayNameKey];
        }
        
        return [AMWActivityCell heightForCellWithName:nameString contentString:activityString];
    } else {
        return 44.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.objects.count) {
        PFObject *activity = [self.objects objectAtIndex:indexPath.row];
        if ([activity objectForKey:kAMWActivityPhotoKey]) {
            AMWPhotoDetailsViewController *detailViewController = [[AMWPhotoDetailsViewController alloc] initWithPhoto:[activity objectForKey:kAMWActivityPhotoKey]];
            [self.navigationController pushViewController:detailViewController animated:YES];
        } else if ([activity objectForKey:kAMWActivityFromUserKey]) {
            AMWAccountViewController *detailViewController = [[AMWAccountViewController alloc] initWithStyle:UITableViewStylePlain];
            NSLog(@"Presenting account view controller with user: %@", [activity objectForKey:kAMWActivityFromUserKey]);
            [detailViewController setUser:[activity objectForKey:kAMWActivityFromUserKey]];
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
    } else if (self.paginationEnabled) {
        // load more
        [self loadNextPage];
    }
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    
    if (![PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:kAMWActivityToUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kAMWActivityFromUserKey notEqualTo:[PFUser currentUser]];
    [query whereKeyExists:kAMWActivityFromUserKey];
    [query includeKey:kAMWActivityFromUserKey];
    [query includeKey:kAMWActivityPhotoKey];
    [query orderByDescending:@"createdAt"];
    
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    //
    // If there is no network connection, we will hit the cache first.
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }
    
    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    lastRefresh = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:lastRefresh forKey:kAMWUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (self.objects.count == 0 && ![[self queryForTable] hasCachedResult]) {
        self.tableView.scrollEnabled = NO;
        self.navigationController.tabBarItem.badgeValue = nil;
        
        if (!self.blankTimelineView.superview) {
            self.blankTimelineView.alpha = 0.0f;
            self.tableView.tableHeaderView = self.blankTimelineView;
            
            [UIView animateWithDuration:0.200f animations:^{
                self.blankTimelineView.alpha = 1.0f;
            }];
        }
    } else {
        self.tableView.tableHeaderView = nil;
        self.tableView.scrollEnabled = YES;
        
        NSUInteger unreadCount = 0;
        for (PFObject *activity in self.objects) {
            if ([lastRefresh compare:[activity createdAt]] == NSOrderedAscending && ![[activity objectForKey:kAMWActivityTypeKey] isEqualToString:kAMWActivityTypeJoined]) {
                unreadCount++;
            }
        }
        
        if (unreadCount > 0) {
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)unreadCount];
        } else {
            self.navigationController.tabBarItem.badgeValue = nil;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"ActivityCell";
    
    AMWActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AMWActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setDelegate:self];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell setActivity:object];;
    
    if ([lastRefresh compare:[object createdAt]] == NSOrderedAscending) {
        [cell setIsNew:YES];
    } else {
        [cell setIsNew:NO];
    }
    
    [cell hideSeparator:(indexPath.row == self.objects.count - 1)];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
    
    AMWLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
    if (!cell) {
        cell = [[AMWLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.hideSeparatorBottom = YES;
        cell.mainView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}


#pragma mark - AMWActivityCellDelegate Methods

- (void)cell:(AMWActivityCell *)cellView didTapActivityButton:(PFObject *)activity {
    // Get image associated with the activity
    PFObject *photo = [activity objectForKey:kAMWActivityPhotoKey];
    
    // Push single photo view controller
    AMWPhotoDetailsViewController *photoViewController = [[AMWPhotoDetailsViewController alloc] initWithPhoto:photo];
    [self.navigationController pushViewController:photoViewController animated:YES];
}

- (void)cell:(AMWBaseTextCell *)cellView didTapUserButton:(PFUser *)user {
    // Push account view controller
    AMWAccountViewController *accountViewController = [[AMWAccountViewController alloc] initWithStyle:UITableViewStylePlain];
    NSLog(@"Presenting account view controller with user: %@", user);
    [accountViewController setUser:user];
    [self.navigationController pushViewController:accountViewController animated:YES];
}


#pragma mark - AMWActivityFeedViewController

+ (NSString *)stringForActivityType:(NSString *)activityType {
    if ([activityType isEqualToString:kAMWActivityTypeLike]) {
        return NSLocalizedString(@"liked your photo", nil);
    } else if ([activityType isEqualToString:kAMWActivityTypeFollow]) {
        return NSLocalizedString(@"started following you", nil);
    } else if ([activityType isEqualToString:kAMWActivityTypeComment]) {
        return NSLocalizedString(@"commented on your photo", nil);
    } else if ([activityType isEqualToString:kAMWActivityTypeJoined]) {
        return NSLocalizedString(@"joined Anypic", nil);
    } else {
        return nil;
    }
}


#pragma mark - ()

- (void)searchButtonAction:(id)sender {
    
}

- (void)settingsButtonAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"My Profile",@"Find Friends",@"Log Out", nil];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)applicationDidReceiveRemoteNotification:(NSNotification *)note {
    [self loadObjects];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0: {
            [self presentViewController:self.presentingAccountNavController animated:YES completion:nil];
            
            break;
        }
            
        case 1: {
            [self presentViewController:self.presentingFriendNavController animated:YES completion:nil];
            break;
        }
            
        case 2: {
            // Log out user and present the login view controller
            [(ParseStarterProjectAppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
        }
            
        default:
            break;
    }
}

@end
