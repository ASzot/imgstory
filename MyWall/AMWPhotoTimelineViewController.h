//
//  AMWPhotoTimelineViewController.h
//  ParseStarterProject
//
//  Created by Andrew on 11/28/15.
//
//

#import "AMWPhotoHeaderView.h"
#import "ParseUI/ParseUI.h"

@interface AMWPhotoTimelineViewController : PFQueryTableViewController<AMWPhotoHeaderViewDelegate>

- (AMWPhotoHeaderView *)dequeueReusableSectionHeaderView;

@end
