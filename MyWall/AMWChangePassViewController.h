//
//  AMWChangePassViewController.h
//  imgStory
//
//  Created by Andrew Szot on 1/27/16.
//  Copyright © 2016 AndrewSzot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMWChangePassViewControllerDelegate<NSObject>

- (void)onDismissChangePassViewController;

@end

@interface AMWChangePassViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, weak) id<AMWChangePassViewControllerDelegate> delegate;

@end
