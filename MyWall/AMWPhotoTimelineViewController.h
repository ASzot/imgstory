//
//  AMWPhotoTimelineViewController.h
//  ParseStarterProject
//
//  Created by Andrew on 11/28/15.
//
//

#import "AMWPhotoHeaderView.h"
#import "ParseUI/ParseUI.h"
#import "AMWEditPhotoViewController.h"

@interface AMWPhotoTimelineViewController : PFQueryTableViewController<AMWPhotoHeaderViewDelegate, AMWEditPhotoViewControllerDelegate>

- (AMWPhotoHeaderView *)dequeueReusableSectionHeaderView;

@end
