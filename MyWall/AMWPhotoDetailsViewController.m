//
//  AMWPhotoDetailsViewController.m
//  ParseStarterProject
//
//  Created by Andrew on 11/29/15.
//
//

#import "AMWPhotoDetailsViewController.h"
#import "AMWBaseTextCell.h"
#import "AMWActivityCell.h"
#import "AMWPhotoDetailsFooterView.h"
#import "AMWConstants.h"
#import "AMWAccountViewController.h"
#import "AMWLoadMoreCell.h"
#import "AMWUtility.h"
#import "MBProgressHUD.h"
#import "ParseStarterProjectAppDelegate.h"
#import "AMWCache.h"

enum ActionSheetTags {
    MainActionSheetTag = 0,
    ConfirmDeleteActionSheetTag = 1
};

@interface AMWPhotoDetailsViewController ()
@property (nonatomic, strong) AMWPhotoDetailsHeaderView *headerView;
@end

static const CGFloat kAMWCellInsetWidth = 0.0f;

@implementation AMWPhotoDetailsViewController

@synthesize photo, headerView;

#pragma mark - Initialization

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AMWUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:self.photo];
}

- (id)initWithPhoto:(PFObject *)aPhoto {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // The className to query on
        self.parseClassName = kAMWActivityClassKey;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of comments to show per page
        self.objectsPerPage = 30;
        
        self.photo = aPhoto;
    }
    return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoNavigationBar.png"]];
    
    // Set table view properties
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    texturedBackgroundView.backgroundColor = [UIColor blackColor];
    self.tableView.backgroundView = texturedBackgroundView;
    
    // Set table header
    self.headerView = [[AMWPhotoDetailsHeaderView alloc] initWithFrame:[AMWPhotoDetailsHeaderView rectForView] photo:self.photo];
    self.headerView.delegate = self;
    
    self.tableView.tableHeaderView = self.headerView;
    
    // Set table footer
    AMWPhotoDetailsFooterView *footerView = [[AMWPhotoDetailsFooterView alloc] initWithFrame:[AMWPhotoDetailsFooterView rectForView]];

    self.tableView.tableFooterView = footerView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(activityButtonAction:)];
    
    // Register to be notified when the keyboard will be shown to scroll the view
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLikedOrUnlikedPhoto:) name:AMWUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:self.photo];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) { // A comment row
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        if (object) {
            NSString *commentString = [self.objects[indexPath.row] objectForKey:kAMWActivityContentKey];
            
            PFUser *commentAuthor = (PFUser *)[object objectForKey:kAMWActivityFromUserKey];
            
            NSString *nameString = @"";
            if (commentAuthor) {
                nameString = [commentAuthor objectForKey:kAMWUserDisplayNameKey];
            }
            
            return [AMWActivityCell heightForCellWithName:nameString contentString:commentString cellInsetWidth:kAMWCellInsetWidth];
        }
    }
    
    // The pagination row
    return 44.0f;
}


#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:kAMWActivityPhotoKey equalTo:self.photo];
    [query includeKey:kAMWActivityFromUserKey];
    [query whereKey:kAMWActivityTypeKey equalTo:kAMWActivityTypeComment];
    [query orderByAscending:@"createdAt"];
    
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *cellID = @"CommentCell";
    
    // Try to dequeue a cell and create one if necessary
    AMWBaseTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[AMWBaseTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.cellInsetWidth = kAMWCellInsetWidth;
        cell.delegate = self;
    }
    
    [cell setUser:[object objectForKey:kAMWActivityFromUserKey]];
    [cell setContentText:[object objectForKey:kAMWActivityContentKey]];
    [cell setDate:[object createdAt]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NextPageDetails";
    
    AMWLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[AMWLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.cellInsetWidth = kAMWCellInsetWidth;
        cell.hideSeparatorTop = YES;
    }
    
    return cell;
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == MainActionSheetTag) {
        if ([actionSheet destructiveButtonIndex] == buttonIndex) {
            // prompt to delete
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to delete this photo?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Yes, delete photo", nil) otherButtonTitles:nil];
            actionSheet.tag = ConfirmDeleteActionSheetTag;
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
        } else {
            [self activityButtonAction:actionSheet];
        }
    } else if (actionSheet.tag == ConfirmDeleteActionSheetTag) {
        if ([actionSheet destructiveButtonIndex] == buttonIndex) {
            
            [self shouldDeletePhoto];
        }
    }
}

#pragma mark - AMWBaseTextCellDelegate

- (void)cell:(AMWBaseTextCell *)cellView didTapUserButton:(PFUser *)aUser {
    [self shouldPresentAccountViewForUser:aUser];
}


#pragma mark - AMWPhotoDetailsHeaderViewDelegate

-(void)photoDetailsHeaderView:(AMWPhotoDetailsHeaderView *)headerView didTapUserButton:(UIButton *)button user:(PFUser *)user {
    [self shouldPresentAccountViewForUser:user];
}

- (void)actionButtonAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.delegate = self;
    actionSheet.tag = MainActionSheetTag;
    actionSheet.destructiveButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Delete Photo", nil)];
    if (NSClassFromString(@"UIActivityViewController")) {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Share Photo", nil)];
    }
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)activityButtonAction:(id)sender {
    if ([[self.photo objectForKey:kAMWPhotoPictureKey] isDataAvailable]) {
        [self showShareSheet];
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[self.photo objectForKey:kAMWPhotoPictureKey] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!error) {
                [self showShareSheet];
            }
        }];
    }
}


#pragma mark - ()

- (void)showShareSheet {
    [[self.photo objectForKey:kAMWPhotoPictureKey] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            NSMutableArray *activityItems = [NSMutableArray arrayWithCapacity:3];
            
            // Prefill caption if this is the original poster of the photo, and then only if they added a caption initially.
            if ([[[PFUser currentUser] objectId] isEqualToString:[[self.photo objectForKey:kAMWPhotoUserKey] objectId]] && [self.objects count] > 0) {
                PFObject *firstActivity = self.objects[0];
                if ([[[firstActivity objectForKey:kAMWActivityFromUserKey] objectId] isEqualToString:[[self.photo objectForKey:kAMWPhotoUserKey] objectId]]) {
                    NSString *commentString = [firstActivity objectForKey:kAMWActivityContentKey];
                    [activityItems addObject:commentString];
                }
            }
            
            [activityItems addObject:[UIImage imageWithData:data]];
            [activityItems addObject:[NSURL URLWithString:[NSString stringWithFormat:@"https://anypic.org/#pic/%@", self.photo.objectId]]];
            
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
        }
    }];
}

- (void)handleCommentTimeout:(NSTimer *)aTimer {
    [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"New Comment", nil) message:NSLocalizedString(@"Your comment will be posted next time there is an Internet connection.", nil)  delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Dismiss", nil), nil];
    [alert show];
}

- (void)shouldPresentAccountViewForUser:(PFUser *)user {
    AMWAccountViewController *accountViewController = [[AMWAccountViewController alloc] initWithStyle:UITableViewStylePlain];
    NSLog(@"Presenting account view controller with user: %@", user);
    [accountViewController setUser:user];
    [self.navigationController pushViewController:accountViewController animated:YES];
}

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWillShow:(NSNotification*)note {
    // Scroll the view to the comment text box
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.tableView setContentOffset:CGPointMake(0.0f, self.tableView.contentSize.height-kbSize.height) animated:YES];
}

- (BOOL)currentUserOwnsPhoto {
    return [[[self.photo objectForKey:kAMWPhotoUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]];
}

- (void)shouldDeletePhoto {
    // Delete all activites related to this photo
    PFQuery *query = [PFQuery queryWithClassName:kAMWActivityClassKey];
    [query whereKey:kAMWActivityPhotoKey equalTo:self.photo];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity deleteEventually];
            }
        }
        
        // Delete photo
        [self.photo deleteEventually];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMWPhotoDetailsViewControllerUserDeletedPhotoNotification object:[self.photo objectId]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
