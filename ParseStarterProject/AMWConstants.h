//
//  AMWConstants.h
//  ParseStarterProject
//
//  Created by Andrew on 11/28/15.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    AMWHomeTabBarItemIndex = 0,
    AMWEmptyTabBarItemIndex = 1,
    AMWActivityTabBarItemIndex = 2
} AMWTabBarControllerViewControllerIndex;

#define kAMWParseEmployeeAccounts [NSArray arrayWithObjects:@"400680", @"403902", @"1225726", @"4806789", @"6409809", @"12800553", @"121800083", @"500011038", @"558159381", @"723748661", nil]


extern NSString *const kAMWUserDefaultsActivityFeedViewControllerLastRefreshKey;


extern NSString *const kAMWLaunchURLHostTakePicture;


extern NSString *const AMWAppDelegationApplicationDidReceiveRemoteNotification;
extern NSString *const AMWUtilityUserFollowingChangedNotification;
extern NSString *const AMWUtilityUserLikedUnlikedPhotoCallbackFinishedNotification;
extern NSString *const AMWUtilityDidFinishProcessingProfilePictureNotification;
extern NSString *const AMWTabBarControllerDidFinishEditingPhotoNotification;
extern NSString *const AMWTabBarControllerDidFinishImageFileUploadNotification;
extern NSString *const AMWPhotoDetailsViewControllerUserDeletedPhotoNotification;
extern NSString *const AMWPhotoDetailsViewControllerUserLikedUnlikedPhotoNotification;
extern NSString *const AMWPhotoDetailsViewControllerUserCommentedOnPhotoNotification;


extern NSString *const kAMWInstallationUserKey;


extern NSString *const kAMWActivityClassKey;


extern NSString *const kAMWActivityTypeKey;
extern NSString *const kAMWActivityFromUserKey;
extern NSString *const kAMWActivityToUserKey;
extern NSString *const kAMWActivityContentKey;
extern NSString *const kAMWActivityPhotoKey;


extern NSString *const kAMWActivityTypeLike;
extern NSString *const kAMWActivityTypeFollow;
extern NSString *const kAMWActivityTypeComment;
extern NSString *const kAMWActivityTypeJoined;


extern NSString *const kAMWUserDisplayNameKey;
extern NSString *const kAMWUserFacebookIDKey;
extern NSString *const kAMWUserPhotoIDKey;
extern NSString *const kAMWUserProfilePicSmallKey;
extern NSString *const kAMWUserProfilePicMediumKey;
extern NSString *const kAMWUserFacebookFriendsKey;
extern NSString *const kAMWUserAlreadyAutoFollowedFacebookFriendsKey;
extern NSString *const kAMWUserEmailKey;
extern NSString *const kAMWUserAutoFollowKey;


extern NSString *const kAMWPhotoClassKey;


extern NSString *const kAMWPhotoPictureKey;
extern NSString *const kAMWPhotoThumbnailKey;
extern NSString *const kAMWPhotoUserKey;
extern NSString *const kAMWPhotoOpenGraphIDKey;


extern NSString *const kAMWPhotoAttributesIsLikedByCurrentUserKey;
extern NSString *const kAMWPhotoAttributesLikeCountKey;
extern NSString *const kAMWPhotoAttributesLikersKey;
extern NSString *const kAMWPhotoAttributesCommentCountKey;
extern NSString *const kAMWPhotoAttributesCommentersKey;


extern NSString *const kAMWUserAttributesPhotoCountKey;
extern NSString *const kAMWUserAttributesIsFollowedByCurrentUserKey;


extern NSString *const kAMWPushPayloadPayloadTypeKey;
extern NSString *const kAMWPushPayloadPayloadTypeActivityKey;

extern NSString *const kAMWPushPayloadActivityTypeKey;
extern NSString *const kAMWPushPayloadActivityLikeKey;
extern NSString *const kAMWPushPayloadActivityCommentKey;
extern NSString *const kAMWPushPayloadActivityFollowKey;

extern NSString *const kAMWPushPayloadFromUserObjectIdKey;
extern NSString *const kAMWPushPayloadToUserObjectIdKey;
extern NSString *const kAMWPushPayloadPhotoObjectIdKey;

