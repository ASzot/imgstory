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
@property (nonatomic, strong) AMWProfileImageView *avatarImageView;
@property (nonatomic, strong) UIButton *userButton;
@property (nonatomic, strong) UILabel *timestampLabel;
@property (nonatomic, strong) TTTTimeIntervalFormatter *timeIntervalFormatter;
@end


@implementation AMWPhotoHeaderView
@synthesize avatarImageView;
@synthesize userButton;
@synthesize timestampLabel;
@synthesize timeIntervalFormatter;
@synthesize photo;
@synthesize buttons;
@synthesize repostButton;
@synthesize deleteButton;
@synthesize delegate;

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame buttons:(AMWPhotoHeaderButtons)otherButtons {
    self = [super initWithFrame:frame];
    if (self) {
        [AMWPhotoHeaderView validateButtons:otherButtons];
        buttons = otherButtons;
        
        self.clipsToBounds = NO;
        self.superview.clipsToBounds = NO;
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.avatarImageView = [[AMWProfileImageView alloc] init];
        self.avatarImageView.frame = CGRectMake( 4.0f, 4.0f, 35.0f, 35.0f);
        [self.avatarImageView.profileButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.avatarImageView];
        
        self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        
        // timestamp
        self.timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake( 50.0f, 24.0f, self.bounds.size.width - 50.0f - 72.0f, 18.0f)];
        [self addSubview:self.timestampLabel];
        [self.timestampLabel setTextColor:[UIColor colorWithRed:114.0f/255.0f green:114.0f/255.0f blue:114.0f/255.0f alpha:1.0f]];
        [self.timestampLabel setFont:[UIFont systemFontOfSize:11.0f]];
        [self.timestampLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}


- (BOOL)currentUserOwnsPhoto {
    NSString *photoId = [[self.photo objectForKey:kAMWPhotoUserKey] objectId];
    NSString *userId = [[PFUser currentUser] objectId];
    return [photoId isEqualToString:userId];
}

#pragma mark - AMWPhotoHeaderView

- (void)setPhoto:(PFObject *)aPhoto {
    photo = aPhoto;
    
    const float repostBtnWidth = 29.0f;
    float boundWidth = self.bounds.size.width;
    BOOL userOwnsPhoto = [self currentUserOwnsPhoto];
    NSString *imageAssetStr = nil;
    
    UIButton *setBtn = nil;
    if (userOwnsPhoto) {
        deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton addTarget:self action:@selector(didTapDeleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        setBtn = deleteButton;
        imageAssetStr = @"ButtonMore.png";
    }
    else {
        if (self.buttons & AMWPhotoHeaderButtonsRepost) {
            // Repost button
            repostButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [repostButton addTarget:self action:@selector(didTapRepostButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            setBtn = repostButton;
            imageAssetStr = @"ButtonLike.png";
        }
    }
    
    CGFloat constrainWidth = self.bounds.size.width;
    
    if (setBtn != nil && imageAssetStr != nil && (self.buttons & AMWPhotoHeaderButtonsRepost)) {
        [self addSubview:setBtn];
        
        [setBtn setFrame:CGRectMake(boundWidth, 9.0f, repostBtnWidth, 29.0f)];
        [setBtn setBackgroundColor:[UIColor clearColor]];
        [setBtn setTitle:@"" forState:UIControlStateNormal];
        [setBtn setTitleColor:[UIColor colorWithRed:254.0f / 255.0f green:149.0f / 255.0f blue:50.0f / 255.0f alpha:1.0f] forState:UIControlStateNormal];
        [setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [setBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        [[setBtn titleLabel] setFont:[UIFont systemFontOfSize:12.0f]];
        [[setBtn titleLabel] setMinimumScaleFactor:0.8f];
        [[setBtn titleLabel] setAdjustsFontSizeToFitWidth:YES];
        [setBtn setAdjustsImageWhenHighlighted:NO];
        [setBtn setAdjustsImageWhenDisabled:NO];
        [setBtn setBackgroundImage:[UIImage imageNamed:imageAssetStr] forState:UIControlStateNormal];
        [setBtn setSelected:NO];
        
        constrainWidth = setBtn.frame.origin.x;
    }
    
    PFUser *user = [self.photo objectForKey:kAMWPhotoUserKey];
    
    if (self.buttons & AMWPhotoHeaderButtonsUser) {
        // This is the user's display name, on a button so that we can tap on it
        self.userButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.userButton];
        [self.userButton setBackgroundColor:[UIColor clearColor]];
        [[self.userButton titleLabel] setFont:[UIFont boldSystemFontOfSize:15]];
        [self.userButton setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:34.0f/255.0f blue:34.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [self.userButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [[self.userButton titleLabel] setLineBreakMode:NSLineBreakByTruncatingTail];
        
        NSString *authorName = [user objectForKey:kAMWUserDisplayNameKey];
        [self.userButton setTitle:authorName forState:UIControlStateNormal];
        
        // we resize the button to fit the user's name to avoid having a huge touch area
        CGPoint userButtonPoint = CGPointMake(50.0f, 6.0f);
        constrainWidth -= userButtonPoint.x;
        CGSize constrainSize = CGSizeMake(constrainWidth, self.bounds.size.height - userButtonPoint.y * 2.0f);
        
        CGSize userButtonSize = [self.userButton.titleLabel.text boundingRectWithSize:constrainSize
                                                                              options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                                           attributes:@{NSFontAttributeName:self.userButton.titleLabel.font}
                                                                              context:nil].size;
        
        CGRect userButtonFrame = CGRectMake(userButtonPoint.x, userButtonPoint.y, userButtonSize.width, userButtonSize.height);
        [self.userButton setFrame:userButtonFrame];
        if (userOwnsPhoto)
            [self.userButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // user's avatar
    
    if ([AMWUtility userHasProfilePictures:user]) {
        [avatarImageView setFile:[user objectForKey:kAMWUserProfilePicSmallKey]];
    }
    else {
        [self.avatarImageView setImage:[AMWUtility defaultProfilePicture]];
    }
    
    [self.avatarImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.avatarImageView.layer.cornerRadius = 17.5;
    self.avatarImageView.layer.masksToBounds = YES;
    
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

- (void)didTapRepostButtonAction:(UIButton *)sender {
    if (delegate && [delegate respondsToSelector:@selector(photoHeaderView:didTapRepostButton:photo:)]) {
        [delegate photoHeaderView:self didTapRepostButton:sender photo:[self.photo objectForKey:kAMWPhotoUserKey]];
    }
}

-(void)didTapDeleteButtonAction:(UIButton *)sender {
    if (delegate && [delegate respondsToSelector:@selector(photoHeaderView:didTapDeleteButton:photo:)]) {
        [delegate photoHeaderView:self didTapDeleteButton:sender photo:self.photo];
    }
}

@end
