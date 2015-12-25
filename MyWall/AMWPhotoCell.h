//
//  AMWPhotoCell.h
//  ParseStarterProject
//
//  Created by Andrew on 11/29/15.
//
//

#import <Foundation/Foundation.h>
#import <ParseUI/ParseUI.h>

@class PFImageView;

@interface AMWPhotoCell : PFTableViewCell

@property (nonatomic, strong) UIButton *photoButton;

-(void)setCaption:(NSString *)captionStr;

@end
