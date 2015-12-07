//
//  AMWActivityFeedViewController.h
//  ParseStarterProject
//
//  Created by Andrew on 11/29/15.
//
//

#import "AMWActivityCell.h"
#import "ParseUI/ParseUI.h"

@interface AMWActivityFeedViewController : PFQueryTableViewController<AMWActivityCellDelegate>

+(NSString *)stringForActivityType:(NSString*)activityType;

@end
