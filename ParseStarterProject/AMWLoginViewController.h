//
//  AMWLoginViewController.h
//  ParseStarterProject
//
//  Created by Andrew on 12/4/15.
//
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@protocol AMWLoginViewControllerDelegate;


@interface AMWLoginViewController : UIViewController

@property (nonatomic, strong) id<AMWLoginViewControllerDelegate> delegate;

@end


@protocol AMWLoginViewControllerDelegate <NSObject>

- (void)loginViewControllerDidLogUserIn: (AMWLoginViewController*)loginViewController;

@end
