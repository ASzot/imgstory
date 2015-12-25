//
//  AMWPhotoCell.m
//  ParseStarterProject
//
//  Created by Andrew on 11/29/15.
//
//

#import "AMWPhotoCell.h"

@interface AMWPhotoCell ()
@property (nonatomic, strong) UILabel *captionLbl;
@property (nonatomic, strong) UIView *footerView;
@end

@implementation AMWPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        self.opaque = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.clipsToBounds = NO;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.imageView.frame = CGRectMake( 0.0f, 0.0f, self.bounds.size.width, self.bounds.size.width);
        self.imageView.backgroundColor = [UIColor blackColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.photoButton.frame = CGRectMake( 0.0f, 0.0f, self.bounds.size.width, self.bounds.size.width);
        self.photoButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.photoButton];
        
        self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0, self.bounds.size.width, self.bounds.size.width)];
        [self.contentView addSubview:self.footerView];
        
        self.captionLbl = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, self.bounds.size.width, 50.0f)];
        [self.captionLbl setFont:[UIFont systemFontOfSize:12.0f]];
        [self.captionLbl setBackgroundColor:[UIColor clearColor]];
        [self.captionLbl setTextColor:[UIColor blackColor]];
        [self.captionLbl setText:@"Tester caption"];
        [self.footerView addSubview:self.captionLbl];
        
        [self.contentView bringSubviewToFront:self.imageView];
        [self.contentView bringSubviewToFront:self.footerView];
    }
    
    return self;
}

- (void)setCaption:(NSString*)captionStr {
    if (captionStr == nil) {
        self.footerView.frame = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
    }
    else
        self.captionLbl.text = captionStr;
}


#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const float photoHeight = self.bounds.size.width;
    
    self.imageView.frame = CGRectMake( 0.0f, 0.0f, self.bounds.size.width, photoHeight);
    self.photoButton.frame = CGRectMake( 0.0f, 0.0f, self.bounds.size.width, photoHeight);
    if (self.footerView.frame.size.width != 0.0f) {
        self.footerView.frame = CGRectMake( 0.0f, photoHeight, self.bounds.size.width, 50.0f);
        [self.footerView setBackgroundColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f]];
    }
}

@end
