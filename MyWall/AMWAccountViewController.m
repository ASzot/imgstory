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
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+ImageEffects.h"

@interface AMWAccountViewController()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) PFImageView *profileImageView;
@property (nonatomic, strong) UIView *profilePictureBackgroundView;
@property (nonatomic, strong) UIButton *followStatusBtn;
@end

@implementation AMWAccountViewController
@synthesize headerView;
@synthesize user;
@synthesize profileImageView;
@synthesize profilePictureBackgroundView;
@synthesize followStatusBtn;

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
    
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.tableView.bounds.size.width, 260.0f)];
    [self.headerView setBackgroundColor:[UIColor clearColor]];
    
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    [texturedBackgroundView setBackgroundColor:[UIColor whiteColor]];
    self.tableView.backgroundView = texturedBackgroundView;
    
    CGRect profileIconRect = CGRectMake( 50.0f, 38.0f, 132.0f, 132.0f);
    
    profilePictureBackgroundView = [[UIView alloc] initWithFrame:profileIconRect];
    [profilePictureBackgroundView setBackgroundColor:[UIColor darkGrayColor]];
    profilePictureBackgroundView.alpha = 0.0f;
    CALayer *layer = [profilePictureBackgroundView layer];
    layer.cornerRadius = 66.0f;
    layer.masksToBounds = YES;
    profilePictureBackgroundView.center = CGPointMake(self.headerView.center.x, profilePictureBackgroundView.center.y);
    [self.headerView addSubview:profilePictureBackgroundView];
    
    
    profileImageView = [[PFImageView alloc] initWithFrame:profileIconRect];
    profileImageView.center = CGPointMake(self.headerView.center.x, profileImageView.center.y);
    [self.headerView addSubview:profileImageView];
    [profileImageView setContentMode:UIViewContentModeScaleAspectFill];
    layer = [profileImageView layer];
    layer.cornerRadius = 66.0f;
    layer.masksToBounds = YES;
    profileImageView.alpha = 0.0f;
    profileImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileImageAction:)];
    [profileImageView addGestureRecognizer:tapGesture];
    
    [self loadUserProfilePic];
    
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
            }
            else {
                followStatusBtn = [[UIButton alloc] initWithFrame:CGRectMake(100.0f, 200.0f, 80.0f, 30.0f)];
                [followStatusBtn setBackgroundColor:[UIColor greenColor]];
                NSString *titleStr;
                SEL selecta;
                if (number == 0) {
                    [self configureFollowButton];
                    titleStr = @"Follow";
                    selecta = @selector(followButtonAction:);
                } else {
                    [self configureUnfollowButton];
                    titleStr = @"Unfollow";
                    selecta = @selector(unfollowButtonAction:);
                }
                [followStatusBtn setTitle:titleStr forState:UIControlStateNormal];
                [followStatusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                followStatusBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
                followStatusBtn.center = CGPointMake(self.headerView.center.x, followStatusBtn.center.y);
                UITapGestureRecognizer *followBtnTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selecta];
                [followStatusBtn addGestureRecognizer:followBtnTapGesture];
                [self.headerView addSubview:followStatusBtn];
            }
        }];
    }
    else {
        UILabel *followingCountLabel = [[UILabel alloc] initWithFrame:CGRectMake( 100.0f, 200.0f, 100.0f, 25.0f)];
        [followingCountLabel setTextAlignment:NSTextAlignmentCenter];
        [followingCountLabel setBackgroundColor:[UIColor whiteColor]];
        [followingCountLabel setTextColor:[UIColor blackColor]];
        [followingCountLabel setShadowColor:[UIColor colorWithWhite:0.0f alpha:0.300f]];
        [followingCountLabel setShadowOffset:CGSizeMake( 0.0f, -1.0f)];
        [followingCountLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
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
    
    UILabel *photoCountLabel = [[UILabel alloc] initWithFrame:CGRectMake( 100.0f, 228.0f, 92.0f, 22.0f)];
    [photoCountLabel setTextAlignment:NSTextAlignmentCenter];
    [photoCountLabel setBackgroundColor:[UIColor clearColor]];
    [photoCountLabel setTextColor:[UIColor blackColor]];
    [photoCountLabel setShadowColor:[UIColor colorWithWhite:0.0f alpha:0.300f]];
    [photoCountLabel setShadowOffset:CGSizeMake( 0.0f, -1.0f)];
    [photoCountLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    photoCountLabel.center = CGPointMake(self.headerView.center.x, photoCountLabel.center.y);
    [self.headerView addSubview:photoCountLabel];
    
    [photoCountLabel setText:@"0 photos"];
    
    PFQuery *queryPhotoCount = [PFQuery queryWithClassName:@"Photo"];
    [queryPhotoCount whereKey:kAMWPhotoUserKey equalTo:self.user];
    [queryPhotoCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryPhotoCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [photoCountLabel setText:[NSString stringWithFormat:@"%d photo%@", number, number==1?@"":@"s"]];
            [[AMWCache sharedCache] setPhotoCount:[NSNumber numberWithInt:number] user:self.user];
        }
    }];
}

- (void) loadUserProfilePic {
    if ([AMWUtility userHasProfilePictures:self.user]) {
        PFFile *imageFile = [self.user objectForKey:kAMWUserProfilePicMediumKey];
        [profileImageView setFile:imageFile];
        [profileImageView loadInBackground:^(UIImage *image, NSError *error) {
            if (!error) {
                [UIView animateWithDuration:0.2f animations:^{
                    profilePictureBackgroundView.alpha = 1.0f;
                    profileImageView.alpha = 1.0f;
                }];
            }
        }];
    }
    else {
        profileImageView.image = [AMWUtility defaultProfilePicture];
        [UIView animateWithDuration:0.2f animations:^{
            profilePictureBackgroundView.alpha = 1.0f;
            profileImageView.alpha = 1.0f;
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

- (void) profileImageAction:(id)sender {
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Set your profile picture"
                                 message:@"Select you Choice"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* choosePicture = [UIAlertAction
                                     actionWithTitle:@"Choose Picture"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [self shouldStartPhotoLibraryPickerController];
                                         [view dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
    UIAlertAction *takePicture = [UIAlertAction actionWithTitle:@"Take Picture" style:UIAlertActionStyleDefault handler:
                                  ^(UIAlertAction *action) {
                                      [self shouldPresentPhotoCaptureController];
                                      [view dismissViewControllerAnimated:YES completion:nil];
                                  }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    
    [view addAction:choosePicture];
    [view addAction:takePicture];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}



- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    // The user canceled choosing the picture.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // The user chose the picture.
    [self dismissViewControllerAnimated:NO completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSArray *profilePics = [AMWUtility setProfileImage:image];
    UIImage *largeImage = profilePics[0];
    
    [profileImageView setImage:largeImage];
}

- (BOOL)shouldStartPhotoLibraryPickerController {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO
         && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
               && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}

- (BOOL) shouldPresentPhotoCaptureController {
    BOOL presentedPhotoCaptureController = [self shouldStartCameraController];
    
    if (!presentedPhotoCaptureController) {
        presentedPhotoCaptureController = [self shouldStartPhotoLibraryPickerController];
    }
    
    return presentedPhotoCaptureController;
}

- (BOOL)shouldStartCameraController {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:
             UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.showsCameraControls = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
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

- (void)followButtonAction:(id)sender {
    UIActivityIndicatorView *loadingActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loadingActivityIndicatorView startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loadingActivityIndicatorView];
    
    [self configureUnfollowButton];
    [followStatusBtn setTitle:@"Unfollow" forState:UIControlStateNormal];
    
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
    [followStatusBtn setTitle:@"Follow" forState:UIControlStateNormal];
    
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
