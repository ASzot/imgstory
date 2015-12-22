//
//  PeopleTableView.h
//  MyWall
//
//  Created by Andrew on 12/21/15.
//  Copyright © 2015 AndrewSzot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import "AMWFindFriendsCell.h"

@interface AMWPeopleTableViewController : PFQueryTableViewController<AMWFindFriendsCellDelegate>
@property (nonatomic, strong) PFQuery *peopleQuery;
@end
