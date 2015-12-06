//
//  AMWWelcomeViewController.h
//  ParseStarterProject
//
//  Created by Andrew on 12/4/15.
//
//

#import <UIKit/UIKit.h>
#import "AMWLoginViewController.h"

@interface AMWWelcomeViewController : UIViewController<AMWLoginViewControllerDelegate>

- (void)presentLoginViewController:(BOOL)animated;

@end
