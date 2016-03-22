//
//  AMWConstants.m
//  ParseStarterProject
//
//  Created by Andrew on 11/28/15.
//
//

#import "AMWConstants.h"

NSString *const AMWAppDelegationApplicationDidReceiveRemoteNotification =
@"com.parse.ParseStarterProject.parseStarterProjectAppDelegate.applicationDidReceiveRemoteNotification";
NSString *const AMWUtilityUserFollowingChangedNotification                      = @"com.parse.Anypic.utility.userFollowingChanged";
NSString *const AMWUtilityUserLikedUnlikedPhotoCallbackFinishedNotification     = @"com.parse.Anypic.utility.userLikedUnlikedPhotoCallbackFinished";
NSString *const AMWUtilityDidFinishProcessingProfilePictureNotification         = @"com.parse.Anypic.utility.didFinishProcessingProfilePictureNotification";
NSString *const AMWTabBarControllerDidFinishEditingPhotoNotification            = @"com.parse.Anypic.tabBarController.didFinishEditingPhoto";
NSString *const AMWTabBarControllerDidFinishImageFileUploadNotification         = @"com.parse.Anypic.tabBarController.didFinishImageFileUploadNotification";
NSString *const AMWPhotoDetailsViewControllerUserDeletedPhotoNotification       = @"com.parse.Anypic.photoDetailsViewController.userDeletedPhoto";
NSString *const AMWPhotoDetailsViewControllerUserLikedUnlikedPhotoNotification  = @"com.parse.Anypic.photoDetailsViewController.userLikedUnlikedPhotoInDetailsViewNotification";
NSString *const AMWPhotoDetailsViewControllerUserCommentedOnPhotoNotification   = @"com.parse.Anypic.photoDetailsViewController.userCommentedOnPhotoInDetailsViewNotification";


NSString *const kAMWInstallationUserKey = @"user";

NSString *const kAMWEditPhotoViewControllerUserInfoCaptionKey = @"comment";


NSString *const kAMWAbuseReportClassKey = @"AbuseReports";
NSString *const kAMWAbuseReportPhoto = @"image";
NSString *const KAMWAbuseReportToUser = @"user";
NSString *const kAMWAbuseReportFromUser = @"fromUser";


NSString *const kAMWActivityClassKey = @"Activity";


NSString *const kAMWActivityTypeKey        = @"type";
NSString *const kAMWActivityFromUserKey    = @"fromUser";
NSString *const kAMWActivityToUserKey      = @"toUser";
NSString *const kAMWActivityContentKey     = @"content";
NSString *const kAMWActivityPhotoKey       = @"photo";


NSString *const kAMWActivityTypeLike       = @"like";
NSString *const kAMWActivityTypeFollow     = @"follow";
NSString *const kAMWActivityTypeComment    = @"comment";
NSString *const kAMWActivityTypeJoined     = @"joined";


NSString *const kAMWUserDisplayNameKey                          = @"displayName";
NSString *const kAMWUserFacebookIDKey                           = @"facebookId";
NSString *const kAMWUserPhotoIDKey                              = @"photoId";
NSString *const kAMWUserProfilePicSmallKey                      = @"profilePictureSmall";
NSString *const kAMWUserProfilePicMediumKey                     = @"profilePictureMedium";
NSString *const kAMWUserFacebookFriendsKey                      = @"facebookFriends";
NSString *const kAMWUserAlreadyAutoFollowedFacebookFriendsKey   = @"userAlreadyAutoFollowedFacebookFriends";
NSString *const kAMWUserEmailKey                                = @"email";
NSString *const kAMWUserAutoFollowKey                           = @"autoFollow";


NSString *const kAMWPhotoClassKey = @"Photo";


NSString *const kAMWPhotoPictureKey         = @"image";
NSString *const kAMWPhotoThumbnailKey       = @"thumbnail";
NSString *const kAMWPhotoUserKey            = @"user";
NSString *const kAMWPhotoOpenGraphIDKey    = @"fbOpenGraphID";


NSString *const kAMWPhotoAttributesIsLikedByCurrentUserKey = @"isLikedByCurrentUser";
NSString *const kAMWPhotoAttributesLikeCountKey            = @"likeCount";
NSString *const kAMWPhotoAttributesLikersKey               = @"likers";
NSString *const kAMWPhotoAttributesCommentCountKey         = @"commentCount";
NSString *const kAMWPhotoAttributesCaptionKey              = @"caption";
