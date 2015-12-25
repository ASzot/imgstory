//
//  AMWLoginViewController.h
//  MyWall
//
//  Created by Andrew on 12/15/15.
//  Copyright © 2015 AndrewSzot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMWLogSignDelegate.h"

@interface AMWLoginViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) id<AMWLogSignDelegate> delegate;

@end
