//
//  PeopleTableView.m
//  MyWall
//
//  Created by Andrew on 12/21/15.
//  Copyright © 2015 AndrewSzot. All rights reserved.
//

#import "AMWPeopleTableViewController.h"
#import "AMWCache.h"
#import "AMWConstants.h"
#import "AMWLoadMoreCell.h"
#import "AMWAccountViewController.h"
#import "AMWUtility.h"

@implementation AMWPeopleTableViewController

- (PFQuery *)queryForTable {
    return self.peopleQuery;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *FriendCellIdentifier = @"FriendCell";
    
    AMWFindFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendCellIdentifier];
    if (cell == nil) {
        cell = [[AMWFindFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FriendCellIdentifier];
        [cell setDelegate:self];
    }
    
    // The PFObject is the Activity class.
    PFUser *toUser = object[@"toUser"];
    NSString *userId = [toUser objectId];
    toUser = [PFQuery getUserObjectWithId:userId];
    
    [cell setUser:toUser];
    
    [cell.photoLabel setText:@"0 photos"];
    
    NSDictionary *attributes = [[AMWCache sharedCache] attributesForUser:toUser];
    
    if (attributes) {
        // set them now
        NSNumber *number = [[AMWCache sharedCache] photoCountForUser:toUser];
        [cell.photoLabel setText:[NSString stringWithFormat:@"%@ photo%@", number, [number intValue] == 1 ? @"": @"s"]];
    }
    else {
        @synchronized(self) {
            PFQuery *photoNumQuery = [PFQuery queryWithClassName:kAMWPhotoClassKey];
            [photoNumQuery whereKey:kAMWPhotoUserKey equalTo:toUser];
            [photoNumQuery setCachePolicy:kPFCachePolicyCacheThenNetwork];
            [photoNumQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                @synchronized(self) {
                    [[AMWCache sharedCache] setPhotoCount:[NSNumber numberWithInt:number] user:toUser];
                }
                AMWFindFriendsCell *actualCell = (AMWFindFriendsCell*)[tableView cellForRowAtIndexPath:indexPath];
                [actualCell.photoLabel setText:[NSString stringWithFormat:@"%d photo%@", number, number == 1 ? @"" : @"s"]];
            }];
        }
    }
    
    cell.followButton.selected = NO;
    cell.tag = indexPath.row;
    
    if (attributes) {
        [cell.followButton setSelected:[[AMWCache sharedCache] followStatusForUser:toUser]];
    }
    else {
        @synchronized(self) {
            PFQuery *isFollowingQuery = [PFQuery queryWithClassName:kAMWActivityClassKey];
            [isFollowingQuery whereKey:kAMWActivityFromUserKey equalTo:[PFUser currentUser]];
            [isFollowingQuery whereKey:kAMWActivityTypeKey equalTo:kAMWActivityTypeFollow];
            [isFollowingQuery whereKey:kAMWActivityToUserKey equalTo:toUser];
            [isFollowingQuery setCachePolicy:kPFCachePolicyCacheThenNetwork];
            
            [isFollowingQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                @synchronized(self) {
                    [[AMWCache sharedCache] setFollowStatus:(!error && number > 0) user:toUser];
                }
                if (cell.tag == indexPath.row) {
                    [cell.followButton setSelected:(!error && number > 0)];
                }
            }];
        }
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *NextPageCellIdentifier = @"NextPageCell";
    
    AMWLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:NextPageCellIdentifier];
    
    if (cell == nil) {
        cell = [[AMWLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NextPageCellIdentifier];
        [cell.mainView setBackgroundColor:[UIColor whiteColor]];
        cell.hideSeparatorBottom = YES;
        cell.hideSeparatorTop = YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)cell:(AMWFindFriendsCell *)cellView didTapUserButton:(PFUser *)aUser {
    // Push account view controller
    AMWAccountViewController *accountViewController = [[AMWAccountViewController alloc] initWithStyle:UITableViewStylePlain];
    NSLog(@"Presenting account view controller with user: %@", aUser);
    [accountViewController setUser:aUser];
    [self.navigationController pushViewController:accountViewController animated:YES];
}

- (void)cell:(AMWFindFriendsCell *)cellView didTapFollowButton:(PFUser *)aUser {
    [self shouldToggleFollowFriendForCell:cellView];
}

- (void)shouldToggleFollowFriendForCell:(AMWFindFriendsCell*)cell {
    PFUser *cellUser = cell.user;
    if ([cell.followButton isSelected]) {
        // Unfollow
        cell.followButton.selected = NO;
        [AMWUtility unfollowUserEventually:cellUser];
        [[NSNotificationCenter defaultCenter] postNotificationName:AMWUtilityUserFollowingChangedNotification object:nil];
    } else {
        // Follow
        cell.followButton.selected = YES;
        [AMWUtility followUserEventually:cellUser block:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:AMWUtilityUserFollowingChangedNotification object:nil];
            } else {
                cell.followButton.selected = NO;
            }
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        return [AMWFindFriendsCell heightForCell];
    } else {
        return 44.0f;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.separatorColor = [UIColor colorWithRed:30.0f / 255.0f green:30.0f / 255.0f blue:30.0f / 255.0f alpha:1.0f];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TitleFindFriends.png"]];
    
    if (self.navigationController.viewControllers[0] == self) {
        UIBarButtonItem *dismissLeftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                                     style:UIBarButtonItemStylePlain
                                                                                    target:self
                                                                                    action:@selector(dismissPresentingViewController)];
        
        self.navigationItem.leftBarButtonItem = dismissLeftBarButtonItem;
    }
    else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)dismissPresentingViewController {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 15;
    }
    return self;
}

@end
