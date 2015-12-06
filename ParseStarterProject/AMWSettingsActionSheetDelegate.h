//
//  AMWSettingsActionSheetDelegate.h
//  ParseStarterProject
//
//  Created by Andrew on 12/5/15.
//
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface AMWSettingsActionSheetDelegate : NSObject<UIActionSheetDelegate>

@property (nonatomic, strong) UINavigationController *navController;

- (id) initWithNavigationController: (UINavigationController *)navigationController;

@end
