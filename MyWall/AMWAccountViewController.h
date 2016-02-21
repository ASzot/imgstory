//
//  AMWAccountViewController.h
//  ParseStarterProject
//
//  Created by Andrew on 11/29/15.
//
//

#import "AMWPhotoTimelineViewController.h"
#import "AMWChangePassViewController.h"

@interface AMWAccountViewController : AMWPhotoTimelineViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, AMWChangePassViewControllerDelegate>

@property (nonatomic, strong) PFUser *user;

- (id) initWithUser: (PFUser *)aUser;

@end
