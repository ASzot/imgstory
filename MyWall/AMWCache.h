//
//  AMWCache.h
//  ParseStarterProject
//
//  Created by Andrew on 11/29/15.
//
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

@interface AMWCache : NSObject

+ (id)sharedCache;

- (void)clear;
- (NSDictionary *)attributesForPhoto:(PFObject *)photo;

- (NSDictionary *)attributesForUser:(PFUser *)user;
- (NSNumber *)photoCountForUser:(PFUser *)user;
- (BOOL)followStatusForUser:(PFUser *)user;
- (void)setPhotoCount:(NSNumber *)count user:(PFUser *)user;
- (void)setFollowStatus:(BOOL)following user:(PFUser *)user;

@end
