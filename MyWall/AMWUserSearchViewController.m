//
//  AMWUserSearchViewController.m
//  MyWall
//
//  Created by Andrew on 12/21/15.
//  Copyright © 2015 AndrewSzot. All rights reserved.
//

#import "AMWUserSearchViewController.h"

@interface AMWUserSearchViewController ()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *blankTimelineView;
@end

@implementation AMWUserSearchViewController
@synthesize headerView;
@synthesize blankTimelineView;

- (void)viewDidLoad {
    self.peopleQuery = [[PFQuery alloc] init];
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoNavigationBar.png"]];
    
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    [texturedBackgroundView setBackgroundColor:[UIColor whiteColor]];
    self.tableView.backgroundView = texturedBackgroundView;
    
    UISearchBar *mainSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 40)];
    mainSearchBar.delegate = self;
    headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.tableView.bounds.size.width, 40)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    [headerView addSubview:mainSearchBar];
    
    UISearchBar *noResultsSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 40)];
    noResultsSearchBar.delegate = self;
    self.blankTimelineView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    [blankTimelineView addSubview:mainSearchBar];
    [blankTimelineView setBackgroundColor:[UIColor whiteColor]];
    UILabel *dispMsg = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 30.0f)];
    dispMsg.text = @"No results";
    dispMsg.center = blankTimelineView.center;
    [blankTimelineView addSubview:dispMsg];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchStr = searchBar.text;
    
    if (searchStr == nil || searchStr.length == 0)
        return;
    
    PFQuery *searchQuery = [PFQuery queryWithClassName:@"_User"];
    [searchQuery whereKey:@"displayName" containsString:searchStr];
    // Make sure the user cannot get themselves.
    [searchQuery whereKey:@"objectId" notEqualTo:[PFUser currentUser].objectId];
    
    self.peopleQuery = searchQuery;
    
    [self loadObjects];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    if (self.objects.count == 0 && ![[self queryForTable] hasCachedResult]) {
        self.tableView.scrollEnabled = NO;
        self.tableView.tableHeaderView = self.blankTimelineView;
    }
    else {
        self.tableView.tableHeaderView = headerView;
        self.tableView.scrollEnabled = YES;
    }
}

@end
