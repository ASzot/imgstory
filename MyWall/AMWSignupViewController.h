//
//  SignupViewController.h
//  MyWall
//
//  Created by Andrew on 12/19/15.
//  Copyright © 2015 AndrewSzot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMWLogSignDelegate.h"
#import "AMWAcceptTOUViewController.h"

@interface AMWSignupViewController : UIViewController<UITextFieldDelegate, AMWToUserActionDelegate>

@property (nonatomic, strong) id<AMWLogSignDelegate> delegate;

@end
