//
//  AMWEditPhotoViewController.h
//  ParseStarterProject
//
//  Created by Andrew on 12/6/15.
//
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@protocol AMWEditPhotoViewControllerDelegate <NSObject>

- (void)onDismissed;

@end

@interface AMWEditPhotoViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) id<AMWEditPhotoViewControllerDelegate> delegate;

- (id) initWithImage:(UIImage *)aImage;
- (id) initWithImage:(UIImage *)aImage withCaption:(NSString*)caption;

@end
