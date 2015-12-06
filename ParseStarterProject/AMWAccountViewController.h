//
//  AMWAccountViewController.h
//  ParseStarterProject
//
//  Created by Andrew on 11/29/15.
//
//

#import "AMWPhotoTimelineViewController.h"

@interface AMWAccountViewController : AMWPhotoTimelineViewController

@property (nonatomic, strong) PFUser *user;

- (id) initWithUser: (PFUser *)aUser;

@end
