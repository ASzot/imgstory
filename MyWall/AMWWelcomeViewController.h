//
//  AMWWelcomeViewController.h
//  ParseStarterProject
//
//  Created by Andrew on 12/4/15.
//
//

#import <UIKit/UIKit.h>
#import "AMWStartViewController.h"

@interface AMWWelcomeViewController : UIViewController<AMWStartViewControllerDelegate>

- (void)presentLoginViewController:(BOOL)animated;

@end
