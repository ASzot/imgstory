//
//  AMWAcceptTOUViewController.h
//  imgStory
//
//  Created by Andrew Szot on 1/28/16.
//  Copyright © 2016 AndrewSzot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMWToUserActionDelegate<NSObject>

- (void)onAccept;
- (void)onDecline;

@end

@interface AMWAcceptTOUViewController : UIViewController
@property (nonatomic, strong) id<AMWToUserActionDelegate> delegate;
@end
