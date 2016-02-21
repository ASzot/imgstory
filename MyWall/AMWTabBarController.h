//
//  AMWTabBarController.h
//  ParseStarterProject
//
//  Created by Andrew on 11/28/15.
//
//

#import <UIKit/UIKit.h>
#import "AMWEditPhotoViewController.h"

@protocol AMWTabBarControllerDelegate;

@interface AMWTabBarController : UITabBarController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, AMWEditPhotoViewControllerDelegate>

- (BOOL)shouldPresentPhotoCaptureController;

@end

@protocol AMWTabBarControllerDelegate <NSObject>

- (void)tabBarController:(UITabBarController *)tabBarController cameraButtonTouchUpInsideAction:(UIButton *)button;

@end
