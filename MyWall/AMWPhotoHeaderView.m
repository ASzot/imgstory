//
//  AMWPhotoHeaderView.m
//  ParseStarterProject
//
//  Created by Andrew on 11/28/15.
//
//

#import "AMWPhotoHeaderView.h"
#import "AMWProfileImageView.h"
#import "TTTTimeIntervalFormatter.h"
#import "AMWUtility.h"
#import "AMWConstants.h"


@interface AMWPhotoHeaderView ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) AMWProfileImageView *avatarImageView;
@property (nonatomic, strong) UIButton *userButton;
@property (nonatomic, strong) UILabel *timestampLabel;
@property (nonatomic, strong) TTTTimeIntervalFormatter *timeIntervalFormatter;
@end


@implementation AMWPhotoHeaderView
@synthesize containerView;
@synthesize avatarImageView;
@synthesize userButton;
@synthesize timestampLabel;
@synthesize timeIntervalFormatter;
@synthesize photo;
@synthesize buttons;
@synthesize repostButton;
@synthesize delegate;

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame buttons:(AMWPhotoHeaderButtons)otherButtons {
    self = [super initWithFrame:frame];
    if (self) {
        [AMWPhotoHeaderView validateButtons:otherButtons];
        buttons = otherButtons;
        
        self.clipsToBounds = NO;
        self.containerView.clipsToBounds = NO;
        self.superview.clipsToBounds = NO;
        [self setBackgroundColor:[UIColor clearColor]];
        
        // translucent portion
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height)];
        [self addSubview:self.containerView];
        [self.containerView setBackgroundColor:[UIColor whiteColor]];
        
        
        self.avatarImageView = [[AMWProfileImageView alloc] init];
        self.avatarImageView.frame = CGRectMake( 4.0f, 4.0f, 35.0f, 35.0f);
        [self.avatarImageView.profileButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:self.avatarImageView];
        
        if (self.buttons & AMWPhotoHeaderButtonsRepost) {
            // like button
            repostButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [containerView addSubview:self.repostButton];
            [self.repostButton setFrame:CGRectMake(246.0f, 9.0f, 29.0f, 29.0f)];
            [self.repostButton setBackgroundColor:[UIColor clearColor]];
            [self.repostButton setTitle:@"" forState:UIControlStateNormal];
            [self.repostButton setTitleColor:[UIColor colorWithRed:254.0f/255.0f green:149.0f/255.0f blue:50.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.repostButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [self.repostButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
            [[self.repostButton titleLabel] setFont:[UIFont systemFontOfSize:12.0f]];
            [[self.repostButton titleLabel] setMinimumScaleFactor:0.8f];
            [[self.repostButton titleLabel] setAdjustsFontSizeToFitWidth:YES];
            [self.repostButton setAdjustsImageWhenHighlighted:NO];
            [self.repostButton setAdjustsImageWhenDisabled:NO];
            [self.repostButton setBackgroundImage:[UIImage imageNamed:@"ButtonLike.png"] forState:UIControlStateNormal];
            //[self.repostButton setBackgroundImage:[UIImage imageNamed:@"ButtonLikeSelected.png"] forState:UIControlStateSelected];
            [self.repostButton setSelected:NO];
        }
        
        if (self.buttons & AMWPhotoHeaderButtonsUser) {
            // This is the user's display name, on a button so that we can tap on it
            self.userButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [containerView addSubview:self.userButton];
            [self.userButton setBackgroundColor:[UIColor clearColor]];
            [[self.userButton titleLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            [self.userButton setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:34.0f/255.0f blue:34.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.userButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            [[self.userButton titleLabel] setLineBreakMode:NSLineBreakByTruncatingTail];
        }
        
        self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        
        // timestamp
        self.timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake( 50.0f, 24.0f, containerView.bounds.size.width - 50.0f - 72.0f, 18.0f)];
        [containerView addSubview:self.timestampLabel];
        [self.timestampLabel setTextColor:[UIColor colorWithRed:114.0f/255.0f green:114.0f/255.0f blue:114.0f/255.0f alpha:1.0f]];
        [self.timestampLabel setFont:[UIFont systemFontOfSize:11.0f]];
        [self.timestampLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}


#pragma mark - AMWPhotoHeaderView

- (void)setPhoto:(PFObject *)aPhoto {
    photo = aPhoto;
    
    // user's avatar
    PFUser *user = [self.photo objectForKey:kAMWPhotoUserKey];
    [self.avatarImageView setImage:[AMWUtility defaultProfilePicture]];
    
    [self.avatarImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.avatarImageView.layer.cornerRadius = 17.5;
    self.avatarImageView.layer.masksToBounds = YES;
    
    NSString *authorName = [user objectForKey:kAMWUserDisplayNameKey];
    [self.userButton setTitle:authorName forState:UIControlStateNormal];
    
    CGFloat constrainWidth = containerView.bounds.size.width;
    
    if (self.buttons & AMWPhotoHeaderButtonsUser) {
        [self.userButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.buttons & AMWPhotoHeaderButtonsRepost) {
        constrainWidth = self.repostButton.frame.origin.x;
        // Add the selector for the did tap photo repost button.
//        [self.repostButton addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // we resize the button to fit the user's name to avoid having a huge touch area
    CGPoint userButtonPoint = CGPointMake(50.0f, 6.0f);
    constrainWidth -= userButtonPoint.x;
    CGSize constrainSize = CGSizeMake(constrainWidth, containerView.bounds.size.height - userButtonPoint.y*2.0f);
    
    CGSize userButtonSize = [self.userButton.titleLabel.text boundingRectWithSize:constrainSize
                                                                          options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                                       attributes:@{NSFontAttributeName:self.userButton.titleLabel.font}
                                                                          context:nil].size;
    
    CGRect userButtonFrame = CGRectMake(userButtonPoint.x, userButtonPoint.y, userButtonSize.width, userButtonSize.height);
    [self.userButton setFrame:userButtonFrame];
    
    NSTimeInterval timeInterval = [[self.photo createdAt] timeIntervalSinceNow];
    NSString *timestamp = [self.timeIntervalFormatter stringForTimeInterval:timeInterval];
    [self.timestampLabel setText:timestamp];
    
    [self setNeedsDisplay];
}

#pragma mark - ()

+ (void)validateButtons:(AMWPhotoHeaderButtons)buttons {
    if (buttons == AMWPhotoHeaderButtonsNone) {
        [NSException raise:NSInvalidArgumentException format:@"Buttons must be set before initializing AMWPhotoHeaderView."];
    }
}

- (void)didTapUserButtonAction:(UIButton *)sender {
    if (delegate && [delegate respondsToSelector:@selector(photoHeaderView:didTapUserButton:user:)]) {
        [delegate photoHeaderView:self didTapUserButton:sender user:[self.photo objectForKey:kAMWPhotoUserKey]];
    }
}

@end
