//
//  AMWFindFriendsViewController.h
//  ParseStarterProject
//
//  Created by Andrew on 12/4/15.
//
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "AMWFindFriendsCell.h"
#import "ParseUI/ParseUI.h"

@interface AMWFindFriendsViewController : PFQueryTableViewController <AMWFindFriendsCellDelegate, ABPeoplePickerNavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate>

@end
