//
//  CreationViewController.h
//  ParseSpliter
//
//  Created by Yusi Zhang on 4/25/14.
//  Copyright (c) 2014 08723 A4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill.h"
#import <CoreLocation/CoreLocation.h>
@interface CreationViewController : UIViewController <CLLocationManagerDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *amout_lb;

@property (strong, nonatomic) IBOutlet UILabel *location_lb;
//Firends Count Label
@property (strong, nonatomic) IBOutlet UILabel *count_lb;
//Amount text field
@property (strong, nonatomic) IBOutlet UITextField *amout_tf;
@property (strong, nonatomic) IBOutlet UITextField *description_tf;

//image
@property (strong, nonatomic) IBOutlet UIImageView *image;

//@property Bill *billObj;

//Clicking Button
- (IBAction)clickPickFriends:(UIButton *)sender;
- (IBAction)clickPickLocation:(UIButton *)sender;
- (IBAction)clickNext:(UIButton *)sender;

- (IBAction)clickPickImage_btn:(UIButton *)sender;

@end
