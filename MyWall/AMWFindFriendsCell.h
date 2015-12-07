//
//  AMWFindFriendsCell.h
//  ParseStarterProject
//
//  Created by Andrew on 11/29/15.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class AMWProfileImageView;
@protocol AMWFindFriendsCellDelegate;

@interface AMWFindFriendsCell : UITableViewCell {
    id _delegate;
}

@property (nonatomic, strong) id<AMWFindFriendsCellDelegate> delegate;

/*! The user represented in the cell */
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) UILabel *photoLabel;
@property (nonatomic, strong) UIButton *followButton;

/*! Setters for the cell's content */
- (void)setUser:(PFUser *)user;

- (void)didTapUserButtonAction:(id)sender;
- (void)didTapFollowButtonAction:(id)sender;

/*! Static Helper methods */
+ (CGFloat)heightForCell;

@end

/*!
 The protocol defines methods a delegate of a AMWFindFriendsCell should implement.
 */
@protocol AMWFindFriendsCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PFUser of the user that was tapped
 */
- (void)cell:(AMWFindFriendsCell *)cellView didTapUserButton:(PFUser *)aUser;
- (void)cell:(AMWFindFriendsCell *)cellView didTapFollowButton:(PFUser *)aUser;

@end
