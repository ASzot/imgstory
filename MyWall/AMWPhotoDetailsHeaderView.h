//
//  AMWPhotoDetailsHeaderView.h
//  ParseStarterProject
//
//  Created by Andrew on 11/29/15.
//
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@protocol AMWPhotoDetailsHeaderViewDelegate;

@interface AMWPhotoDetailsHeaderView : UIView

/// The photo displayed in the view
@property (nonatomic, strong, readonly) PFObject *photo;

/// The user that took the photo
@property (nonatomic, strong, readonly) PFUser *photographer;


/*! @name Delegate */
@property (nonatomic, strong) id<AMWPhotoDetailsHeaderViewDelegate> delegate;

+ (CGRect)rectForView;

- (id)initWithFrame:(CGRect)frame photo:(PFObject*)aPhoto;
- (id)initWithFrame:(CGRect)frame photo:(PFObject*)aPhoto photographer:(PFUser*)aPhotographer;

@end

@protocol AMWPhotoDetailsHeaderViewDelegate <NSObject>

@optional

// Sent to the delegate when the users's profile is tapped.
- (void) photoDetailsHeaderView:(AMWPhotoDetailsHeaderView *)headerView didTapUserButton: (UIButton *)button user:(PFUser *)user;

@end
