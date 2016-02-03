//
//  AMWAcceptTOUViewController.m
//  imgStory
//
//  Created by Andrew Szot on 1/28/16.
//  Copyright © 2016 AndrewSzot. All rights reserved.
//

#import "AMWAcceptTOUViewController.h"

@interface AMWAcceptTOUViewController () {
}

@end

@implementation AMWAcceptTOUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)acceptBtnAction:(id)sender {
    [self.delegate performSelector:@selector(onAccept)];
}
- (IBAction)declineBtnAction:(id)sender {
    [self.delegate performSelector:@selector(onDecline)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
