//
//  AMWActivityCell.h
//  ParseStarterProject
//
//  Created by Andrew on 11/29/15.
//
//

#import "AMWBaseTextCell.h"

@protocol AMWActivityCellDelegate;

@interface AMWActivityCell : AMWBaseTextCell

/*!Setter for the activity associated with this cell */
@property (nonatomic, strong) PFObject *activity;

/*!Set the new state. This changes the background of the cell. */
- (void)setIsNew:(BOOL)isNew;

@end


/*!
 The protocol defines methods a delegate of a AMWBaseTextCell should implement.
 */
@protocol AMWActivityCellDelegate <AMWBaseTextCellDelegate>
@optional

/*!
 Sent to the delegate when the activity button is tapped
 @param activity the PFObject of the activity that was tapped
 */
- (void)cell:(AMWActivityCell *)cellView didTapActivityButton:(PFObject *)activity;

@end