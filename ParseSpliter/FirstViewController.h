//
//  FirstViewController.h
//  ParseSpliter
//
//  Created by Yusi Zhang on 4/25/14.
//  Copyright (c) 2014 08723 A4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBLoginViewController.h"

@interface FirstViewController : UIViewController


- (IBAction)click_checkbalance:(UIButton *)sender;

- (IBAction)click_createbill:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profile_uiview;


@end
