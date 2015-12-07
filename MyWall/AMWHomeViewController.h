//
//  AMWHomeViewController.h
//  ParseStarterProject
//
//  Created by Andrew on 12/4/15.
//
//

#import <Foundation/Foundation.h>
#import "AMWPhotoTimelineViewController.h"

@interface AMWHomeViewController : AMWPhotoTimelineViewController

@property (nonatomic, assign, getter = isFirstLaunch) BOOL firstLaunch;

@end
