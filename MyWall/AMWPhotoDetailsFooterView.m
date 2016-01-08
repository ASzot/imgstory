//
//  AMWPhotoDetailsFooterView.m
//  ParseStarterProject
//
//  Created by Andrew on 11/29/15.
//
//

#import "AMWPhotoDetailsFooterView.h"


@interface AMWPhotoDetailsFooterView ()
@property (nonatomic, strong) UIView *mainView;
@end

@implementation AMWPhotoDetailsFooterView

@synthesize mainView;
@synthesize hideDropShadow;
@synthesize captionTextField;


#pragma mark - NSObject

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        mainView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, frame.size.width, 51.0f)];
        mainView.backgroundColor = [UIColor whiteColor];
        [self addSubview:mainView];
        
        UIImageView *messageIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconAddCaption.png"]];
        messageIcon.frame = CGRectMake( 20.0f, 15.0f, 22.0f, 22.0f);
        [mainView addSubview:messageIcon];
        
        captionTextField = [[UITextField alloc] initWithFrame:CGRectMake( 66.0f, 8.0f, frame.size.width - 66.0f, 34.0f)];
        captionTextField.font = [UIFont systemFontOfSize:14.0f];
        captionTextField.placeholder = @"Add a caption.";
        captionTextField.returnKeyType = UIReturnKeyDone;
        captionTextField.textColor = [UIColor colorWithRed:34.0f / 255.0f green:34.0f / 255.0f blue:34.0f / 255.0f alpha:1.0f];
        captionTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [captionTextField setValue:[UIColor colorWithRed:114.0f / 255.0f green:114.0f / 255.0f blue:114.0f / 255.0f alpha:1.0f] forKeyPath:@"_placeholderLabel.textColor"]; // Are we allowed to modify private properties like this? -Héctor
        [mainView addSubview:captionTextField];
    }
    return self;
}

@end
