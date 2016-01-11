//
//  AMWEditPhotoViewController.m
//  ParseStarterProject
//
//  Created by Andrew on 12/6/15.
//
//

#import "AMWEditPhotoViewController.h"
#import "ParseUI/ParseUI.h"
#import "AMWEditPhotoViewController.h"
#import "AMWPhotoDetailsFooterView.h"
#import <Parse/Parse.h>
#import "UIImage+ResizeAdditions.h"
#import "AMWCache.h"
#import "AMWConstants.h"

#define MAX_PHOTOS_PER_DAY 5

@interface AMWEditPhotoViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) PFFile *photoFile;
@property (nonatomic, strong) PFFile *thumbnailFile;
@property (nonatomic, strong) UITextField *captionTextField;
@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier photoPostBackgroundTaskId;
@property (nonatomic, weak) NSString *caption;
@end

@implementation AMWEditPhotoViewController {
    BOOL isReposting;
}
@synthesize scrollView;
@synthesize image;
@synthesize captionTextField;
@synthesize photoFile;
@synthesize thumbnailFile;
@synthesize fileUploadBackgroundTaskId;
@synthesize photoPostBackgroundTaskId;

#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (id)initWithImage:(UIImage *)aImage {
    return [self initWithImage:aImage withCaption:nil];
}

- (id)initWithImage:(UIImage *)aImage withCaption:(NSString*)caption {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (!aImage) {
            return nil;
        }
        
        self.image = aImage;
        isReposting = caption != nil;
        
        self.caption = caption == nil ? @"" : caption;
        
        self.fileUploadBackgroundTaskId = UIBackgroundTaskInvalid;
        self.photoPostBackgroundTaskId = UIBackgroundTaskInvalid;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"Memory warning on Edit");
}


#pragma mark - UIViewController

- (void)loadView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.view = self.scrollView;
    
    // Make sure the image ratio is 1:1 therefore use the width of the screen for both the height and width and height of the image.
    UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.scrollView.bounds.size.width, self.scrollView.bounds.size.width)];
    [photoImageView setBackgroundColor:[UIColor blackColor]];
    [photoImageView setImage:self.image];
    [photoImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.scrollView addSubview:photoImageView];
    
    CGRect footerRect = CGRectMake(0.0f, 0.0f, self.scrollView.bounds.size.width, 69.0f);
    footerRect.origin.y = photoImageView.frame.origin.y + photoImageView.frame.size.height;
    
    AMWPhotoDetailsFooterView *footerView = [[AMWPhotoDetailsFooterView alloc] initWithFrame:footerRect];
    [self.scrollView addSubview:footerView];
    
    captionTextField = footerView.captionTextField;
    captionTextField.delegate = self;
    captionTextField.text = self.caption;
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.bounds.size.width, photoImageView.frame.origin.y + photoImageView.frame.size.height + footerView.frame.size.height)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!isReposting)
        [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoNavigationBar.png"]];
    if (!isReposting) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonAction:)];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:(isReposting ? @"Repost" : @"Post") style:UIBarButtonItemStyleDone target:self action:@selector(publishButtonAction:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self shouldUploadImage:self.image];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self doneButtonAction:textField];
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - ()

- (BOOL)shouldUploadImage:(UIImage *)anImage {
    // First check that the user has not posted MAX_PHOTOS_PER_DAY images in the past day.
    NSDate *oneDayAgo = [[NSDate date] dateByAddingTimeInterval:(-24*60*60)];
    
    PFQuery *imageCountQuery = [PFQuery queryWithClassName:kAMWPhotoClassKey];
    [imageCountQuery whereKey:kAMWPhotoUserKey equalTo:[PFUser currentUser]];
    [imageCountQuery whereKey:@"createdAt" greaterThan:oneDayAgo];
    imageCountQuery.limit = MAX_PHOTOS_PER_DAY;
    [imageCountQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (number != MAX_PHOTOS_PER_DAY) {
            // Actually upload the image.
            [self uploadImage:anImage];
        }
        else {
            // Display a message to the user saying they have reached the max photo count for the day.
            NSString *message = [@"" stringByAppendingFormat:@"The max number of %@ photos per day have been uploaded", @MAX_PHOTOS_PER_DAY];
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Could not upload image" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
    return YES;
}

- (BOOL)uploadImage:(UIImage*)anImage {
    UIImage *resizedImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(560.0f, 560.0f) interpolationQuality:kCGInterpolationHigh];
    UIImage *thumbnailImage = [anImage thumbnailImage:86.0f transparentBorder:0.0f cornerRadius:10.0f interpolationQuality:kCGInterpolationDefault];
    
    // JPEG to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
    NSData *thumbnailImageData = UIImagePNGRepresentation(thumbnailImage);
    
    if (!imageData || !thumbnailImageData) {
        return NO;
    }
    
    self.photoFile = [PFFile fileWithData:imageData];
    self.thumbnailFile = [PFFile fileWithData:thumbnailImageData];
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    
    NSLog(@"Requested background expiration task with id %lu for MyWall photo upload", (unsigned long)self.fileUploadBackgroundTaskId);
    [self.photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Photo uploaded successfully");
            [self.thumbnailFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Thumbnail uploaded successfully");
                }
                [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
            }];
        } else {
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }
    }];
    
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)note {
    CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize scrollViewContentSize = self.scrollView.bounds.size;
    scrollViewContentSize.height += keyboardFrameEnd.size.height;
    [self.scrollView setContentSize:scrollViewContentSize];
    
    CGPoint scrollViewContentOffset = self.scrollView.contentOffset;
    // Align the bottom edge of the photo with the keyboard
    scrollViewContentOffset.y = scrollViewContentOffset.y + keyboardFrameEnd.size.height*3.4f - [UIScreen mainScreen].bounds.size.height;
    
    [self.scrollView setContentOffset:scrollViewContentOffset animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)note {
    CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize scrollViewContentSize = self.scrollView.bounds.size;
    scrollViewContentSize.height -= keyboardFrameEnd.size.height;
    [UIView animateWithDuration:0.200f animations:^{
        [self.scrollView setContentSize:scrollViewContentSize];
    }];
}

- (void)publishButtonAction:(id)sender {
    NSString *trimmedComment = [self.captionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // Keep the caption to under 100 characters.
    trimmedComment = [trimmedComment substringWithRange:NSMakeRange(0, 100)];
    
    if (!self.photoFile || !self.thumbnailFile) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Couldn't post your photo" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *alert) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:dismissAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    // both files have finished uploading
    
    // create a photo object
    PFObject *photo = [PFObject objectWithClassName:kAMWPhotoClassKey];
    [photo setObject:[PFUser currentUser] forKey:kAMWPhotoUserKey];
    [photo setObject:self.photoFile forKey:kAMWPhotoPictureKey];
    [photo setObject:self.thumbnailFile forKey:kAMWPhotoThumbnailKey];
    [photo setObject:trimmedComment forKey:kAMWPhotoAttributesCaptionKey];
    
    // photos are public, but may only be modified by the user who uploaded them
    PFACL *photoACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [photoACL setPublicReadAccess:YES];
    photo.ACL = photoACL;
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.photoPostBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
    }];
    
    // save
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[NSNotificationCenter defaultCenter] postNotificationName:AMWTabBarControllerDidFinishEditingPhotoNotification object:photo];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Couldn't post your photo" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *alert) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:dismissAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
    }];
    
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonAction:(id)sender {
    //[self textFieldShouldReturn:captionTextField];
}

- (void)cancelButtonAction:(id)sender {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
