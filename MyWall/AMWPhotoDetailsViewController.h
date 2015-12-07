//
//  AMWPhotoDetailsViewController.h
//  ParseStarterProject
//
//  Created by Andrew on 11/29/15.
//
//

#import "AMWPhotoDetailsHeaderView.h"
#import "AMWBaseTextCell.h"
#import "ParseUI/ParseUI.h"

@interface AMWPhotoDetailsViewController : PFQueryTableViewController <UIActionSheetDelegate, AMWPhotoDetailsHeaderViewDelegate, AMWBaseTextCellDelegate>

@property (nonatomic, strong) PFObject *photo;

- (id) initWithPhoto:(PFObject *)aPhoto;

@end
