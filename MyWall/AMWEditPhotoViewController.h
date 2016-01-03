//
//  AMWEditPhotoViewController.h
//  ParseStarterProject
//
//  Created by Andrew on 12/6/15.
//
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface AMWEditPhotoViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>

- (id) initWithImage:(UIImage *)aImage;
- (id) initWithImage:(UIImage *)aImage withCaption:(NSString*)caption;

@end
