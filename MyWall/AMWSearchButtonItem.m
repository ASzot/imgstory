//
//  AMWSearchButtonItem.m
//  MyWall
//
//  Created by Andrew on 12/21/15.
//  Copyright © 2015 AndrewSzot. All rights reserved.
//

#import "AMWSearchButtonItem.h"

@implementation AMWSearchButtonItem

- (id)initWithTarget:(id)target action:(SEL)action {
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self = [super initWithCustomView:settingsButton];
    if (self) {
        [settingsButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [settingsButton setFrame:CGRectMake(0.0f, 0.0f, 35.0f, 32.0f)];
        [settingsButton setImage:[UIImage imageNamed:@"ButtonImageSearch.png"] forState:UIControlStateNormal];
    }
    
    return self;
}

@end
