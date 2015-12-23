//
//  AMWPhotoHeaderView.h
//  ParseStarterProject
//
//  Created by Andrew on 11/28/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

typedef enum {
    AMWPhotoHeaderButtonsNone = 0,
    AMWPhotoHeaderButtonsRepost = 1 << 0,
    AMWPhotoHeaderButtonsUser = 1 << 1,
    
    AMWPhotoHeaderButtonsDefault = AMWPhotoHeaderButtonsRepost | AMWPhotoHeaderButtonsUser
    
} AMWPhotoHeaderButtons;


@protocol AMWPhotoHeaderViewDelegate;

@interface AMWPhotoHeaderView : UITableViewCell

// Creates the view with the specified buttons.
- (id)initWithFrame:(CGRect)frame buttons:(AMWPhotoHeaderButtons)otherButtons;

// The photo data associated with this image.
@property (nonatomic, strong) PFObject *photo;

// The bitmask which specifies which buttons have been clicked.
@property (nonatomic, readonly, assign) AMWPhotoHeaderButtons buttons;

@property (nonatomic, readonly) UIButton *repostButton;

@property (nonatomic, readonly) UIButton *deleteButton;

@property (nonatomic, weak) id<AMWPhotoHeaderViewDelegate> delegate;

@end


@protocol AMWPhotoHeaderViewDelegate <NSObject>
@optional

- (void) photoHeaderView: (AMWPhotoHeaderView*)photoHeaderView didTapUserButton: (UIButton*) button user: (PFUser*)user;

- (void) photoHeaderView: (AMWPhotoHeaderView*)photoHeaderView didTapRepostButton: (UIButton*) button photo: (PFObject*)photo;

- (void) photoHeaderView: (AMWPhotoHeaderView*)photoHeaderView didTapDeleteButton: (UIButton*) button photo: (PFObject*)photo;

@end
