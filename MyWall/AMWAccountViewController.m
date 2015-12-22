//
//  AMWAccountViewController.m
//  ParseStarterProject
//
//  Created by Andrew on 11/29/15.
//
//

#import "AMWAccountViewController.h"
#import "AMWPhotoCell.h"
#import "TTTTimeIntervalFormatter.h"
#import "AMWLoadMoreCell.h"
#import "AMWUtility.h"
#import "AMWConstants.h"
#import "AMWCache.h"
#import "AMWPeopleTableViewController.h"

@interface AMWAccountViewController()
@property (nonatomic, strong) UIView *headerView;
@end

@implementation AMWAccountViewController
@synthesize headerView;
@synthesize user;

#pragma mark - Initialization

- (id)initWithUser:(PFUser *)aUser {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.user = aUser;
        
        if (!aUser) {
            [NSException raise:NSInvalidArgumentException format:@"AMWAccountViewController init exception: user cannot be nil"];
        }
        
    }
    return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.user) {
        self.user = [PFUser currentUser];
        [[PFUser currentUser] fetchIfNeeded];
    }
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoNavigationBar.png"]];
    
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.tableView.bounds.size.width, 230.0f)];
    [self.headerView setBackgroundColor:[UIColor clearColor]];
    
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    [texturedBackgroundView setBackgroundColor:[UIColor whiteColor]];
    self.tableView.backgroundView = texturedBackgroundView;
    
    CGRect profileIconRect = CGRectMake( 50.0f, 38.0f, 132.0f, 132.0f);
    
    UIView *profilePictureBackgroundView = [[UIView alloc] initWithFrame:profileIconRect];
    [profilePictureBackgroundView setBackgroundColor:[UIColor darkGrayColor]];
    profilePictureBackgroundView.alpha = 0.0f;
    CALayer *layer = [profilePictureBackgroundView layer];
    layer.cornerRadius = 66.0f;
    layer.masksToBounds = YES;
    profilePictureBackgroundView.center = CGPointMake(self.headerView.center.x, profilePictureBackgroundView.center.y);
    [self.headerView addSubview:profilePictureBackgroundView];
    
    
    PFImageView *profilePictureImageView = [[PFImageView alloc] initWithFrame:profileIconRect];
    profilePictureImageView.center = CGPointMake(self.headerView.center.x, profilePictureImageView.center.y);
    [self.headerView addSubview:profilePictureImageView];
    [profilePictureImageView setContentMode:UIViewContentModeScaleAspectFill];
    layer = [profilePictureImageView layer];
    layer.cornerRadius = 66.0f;
    layer.masksToBounds = YES;
    profilePictureImageView.alpha = 0.0f;
    
    profilePictureImageView.image = [AMWUtility defaultProfilePicture];
    [UIView animateWithDuration:0.2f animations:^{
        profilePictureBackgroundView.alpha = 1.0f;
        profilePictureImageView.alpha = 1.0f;
    }];
    
    //UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[[AMWUtility defaultProfilePicture] applyDarkEffect]];
//    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[AMWUtility defaultProfilePicture]];
//    backgroundImageView.frame = self.tableView.backgroundView.bounds;
//    backgroundImageView.alpha = 0.0f;
//    [self.tableView.backgroundView addSubview:backgroundImageView];
//    
//    [UIView animateWithDuration:0.2f animations:^{
//        backgroundImageView.alpha = 1.0f;
//    }];
//    UIImageView *photoCountIconImageView = [[UIImageView alloc] initWithImage:nil];
//    [photoCountIconImageView setImage:[UIImage imageNamed:@"IconPics.png"]];
//    [photoCountIconImageView setFrame:CGRectMake( 26.0f, 50.0f, 45.0f, 37.0f)];
//    [self.headerView addSubview:photoCountIconImageView];
    
//    UILabel *photoCountLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0.0f, 94.0f, 92.0f, 22.0f)];
//    [photoCountLabel setTextAlignment:NSTextAlignmentCenter];
//    [photoCountLabel setBackgroundColor:[UIColor clearColor]];
//    [photoCountLabel setTextColor:[UIColor whiteColor]];
//    [photoCountLabel setShadowColor:[UIColor colorWithWhite:0.0f alpha:0.300f]];
//    [photoCountLabel setShadowOffset:CGSizeMake( 0.0f, -1.0f)];
//    [photoCountLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
//    [self.headerView addSubview:photoCountLabel];
    
    
    
    UILabel *userDisplayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 176.0f, self.headerView.bounds.size.width, 22.0f)];
    [userDisplayNameLabel setTextAlignment:NSTextAlignmentCenter];
    [userDisplayNameLabel setBackgroundColor:[UIColor clearColor]];
    [userDisplayNameLabel setTextColor:[UIColor blackColor]];
    [userDisplayNameLabel setShadowColor:[UIColor colorWithWhite:0.0f alpha:0.300f]];
    [userDisplayNameLabel setShadowOffset:CGSizeMake( 0.0f, -1.0f)];
    [userDisplayNameLabel setText:[self.user objectForKey:@"displayName"]];
    [userDisplayNameLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    userDisplayNameLabel.center = CGPointMake(self.headerView.center.x, userDisplayNameLabel.center.y);
    [self.headerView addSubview:userDisplayNameLabel];
    
    //[photoCountLabel setText:@"0 photos"];
    
//    PFQuery *queryPhotoCount = [PFQuery queryWithClassName:@"Photo"];
//    [queryPhotoCount whereKey:kAMWPhotoUserKey equalTo:self.user];
//    [queryPhotoCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
//    [queryPhotoCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
//        if (!error) {
//            [photoCountLabel setText:[NSString stringWithFormat:@"%d photo%@", number, number==1?@"":@"s"]];
//            [[AMWCache sharedCache] setPhotoCount:[NSNumber numberWithInt:number] user:self.user];
//        }
//    }];
    
    if (![[self.user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        UIActivityIndicatorView *loadingActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [loadingActivityIndicatorView startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loadingActivityIndicatorView];
        
        // check if the currentUser is following this user
        PFQuery *queryIsFollowing = [PFQuery queryWithClassName:kAMWActivityClassKey];
        [queryIsFollowing whereKey:kAMWActivityTypeKey equalTo:kAMWActivityTypeFollow];
        [queryIsFollowing whereKey:kAMWActivityToUserKey equalTo:self.user];
        [queryIsFollowing whereKey:kAMWActivityFromUserKey equalTo:[PFUser currentUser]];
        [queryIsFollowing setCachePolicy:kPFCachePolicyCacheThenNetwork];
        [queryIsFollowing countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if (error && [error code] != kPFErrorCacheMiss) {
                NSLog(@"Couldn't determine follow relationship: %@", error);
                self.navigationItem.rightBarButtonItem = nil;
            } else {
                if (number == 0) {
                    [self configureFollowButton];
                } else {
                    [self configureUnfollowButton];
                }
            }
        }];
    }
    else {
        UILabel *followingCountLabel = [[UILabel alloc] initWithFrame:CGRectMake( 94.0f, 200.0f, 100.0f, 16.0f)];
        [followingCountLabel setTextAlignment:NSTextAlignmentCenter];
        [followingCountLabel setBackgroundColor:[UIColor clearColor]];
        [followingCountLabel setTextColor:[UIColor blackColor]];
        [followingCountLabel setShadowColor:[UIColor colorWithWhite:0.0f alpha:0.300f]];
        [followingCountLabel setShadowOffset:CGSizeMake( 0.0f, -1.0f)];
        [followingCountLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        followingCountLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followingLblAction:)];
        [followingCountLabel addGestureRecognizer:tapGesture];
        followingCountLabel.center = CGPointMake(self.headerView.center.x, followingCountLabel.center.y);
        [self.headerView addSubview:followingCountLabel];
        
        NSDictionary *followingDictionary = [[PFUser currentUser] objectForKey:@"following"];
        [followingCountLabel setText:@"0 following"];
        if (followingDictionary) {
            [followingCountLabel setText:[NSString stringWithFormat:@"%lu following", (unsigned long)[[followingDictionary allValues] count]]];
        }
        
        PFQuery *queryFollowingCount = [PFQuery queryWithClassName:kAMWActivityClassKey];
        [queryFollowingCount whereKey:kAMWActivityTypeKey equalTo:kAMWActivityTypeFollow];
        [queryFollowingCount whereKey:kAMWActivityFromUserKey equalTo:self.user];
        [queryFollowingCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
        [queryFollowingCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if (!error) {
                [followingCountLabel setText:[NSString stringWithFormat:@"%d following", number]];
            }
        }];
    }
}

- (void) followingLblAction:(id)sender {
    AMWPeopleTableViewController *followingViewController = [[AMWPeopleTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    // Query all of the users that this user is following.
    PFQuery *query = [PFQuery queryWithClassName:kAMWActivityClassKey];
    [query whereKey:kAMWActivityTypeKey equalTo:kAMWActivityTypeFollow];
    [query whereKey:kAMWActivityFromUserKey equalTo:[PFUser currentUser]];
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    query.limit = 1000;
    
    followingViewController.peopleQuery = query;
    [self.navigationController pushViewController:followingViewController animated:YES];
}

- (void)dismissPresentingViewController {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PFQueryTableViewController

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    self.tableView.tableHeaderView = headerView;
}

- (PFQuery *)queryForTable {
    if (!self.user) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query whereKey:kAMWPhotoUserKey equalTo:self.user];
    [query orderByDescending:@"createdAt"];
    [query includeKey:kAMWPhotoUserKey];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
    
    AMWLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
    if (!cell) {
        cell = [[AMWLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.separatorImageTop.image = [UIImage imageNamed:@"SeparatorTimelineDark.png"];
        cell.hideSeparatorBottom = YES;
        cell.mainView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}


#pragma mark - ()

- (void)followButtonAction:(id)sender {
    UIActivityIndicatorView *loadingActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loadingActivityIndicatorView startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loadingActivityIndicatorView];
    
    [self configureUnfollowButton];
    
    [AMWUtility followUserEventually:self.user block:^(BOOL succeeded, NSError *error) {
        if (error) {
            [self configureFollowButton];
        }
    }];
}

- (void)unfollowButtonAction:(id)sender {
    UIActivityIndicatorView *loadingActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loadingActivityIndicatorView startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loadingActivityIndicatorView];
    
    [self configureFollowButton];
    
    [AMWUtility unfollowUserEventually:self.user];
}

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configureFollowButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Follow" style:UIBarButtonItemStylePlain target:self action:@selector(followButtonAction:)];
    [[AMWCache sharedCache] setFollowStatus:NO user:self.user];
}

- (void)configureUnfollowButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Unfollow" style:UIBarButtonItemStylePlain target:self action:@selector(unfollowButtonAction:)];
    [[AMWCache sharedCache] setFollowStatus:YES user:self.user];
}

@end
