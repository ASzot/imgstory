//
//  AMWProfileImageView.h
//  ParseStarterProject
//
//  Created by Andrew on 11/28/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PFImageView;
@class PFFile;


@interface AMWProfileImageView : UIView

@property (nonatomic, strong) UIButton *profileButton;
@property (nonatomic, strong) PFImageView *profileImageView;

- (void) setFile: (PFFile *)file;
- (void) setImage: (UIImage *)image;

@end
