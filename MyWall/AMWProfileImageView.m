//
//  AMWProfileImageView.m
//  ParseStarterProject
//
//  Created by Andrew on 11/28/15.
//
//

#import "AMWProfileImageView.h"
#import "ParseUI/ParseUI.h"

@interface AMWProfileImageView ()
@property (nonatomic, strong) UIImageView *borderImageView;
@end

@implementation AMWProfileImageView

@synthesize borderImageView;
@synthesize profileImageView;
@synthesize profileButton;

- (id) initWithFrame: (CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.profileImageView = [[PFImageView alloc] initWithFrame:frame];
        [self addSubview:self.profileImageView];
        
        self.profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.profileButton];
        
        [self addSubview:self.borderImageView];
    }
    
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self bringSubviewToFront:self.borderImageView];
    
    self.profileImageView.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    self.borderImageView.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    self.profileButton.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
}

- (void) setFile:(PFFile *)file {
    if (!file) {
        return;
    }
    
    self.profileImageView.image = [UIImage imageNamed:@"AvatarPlaceholder.png"];
    self.profileImageView.file = file;
    [self.profileImageView loadInBackground];
}

- (void) setImage:(UIImage *)image {
    self.profileImageView.image = image;
}

@end
