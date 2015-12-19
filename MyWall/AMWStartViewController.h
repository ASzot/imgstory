//
//  AMWLoginViewController.h
//  ParseStarterProject
//
//  Created by Andrew on 12/4/15.
//
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "AMWLogSignDelegate.h"

@protocol AMWStartViewControllerDelegate;


@interface AMWStartViewController : UIViewController<AMWLogSignDelegate>

@property (nonatomic, strong) id<AMWStartViewControllerDelegate> delegate;

-(void)logSignActionOccured;

@end


@protocol AMWStartViewControllerDelegate <NSObject>

- (void)logInViewControllerDidLogUserIn: (AMWStartViewController*)loginViewController;

@end
