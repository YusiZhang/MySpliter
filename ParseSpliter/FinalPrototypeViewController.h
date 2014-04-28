//
//  FinalPrototypeViewController.h
//  ParseSpliter
//
//  Created by Yusi Zhang on 4/23/14.
//  Copyright (c) 2014 08723 A4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill.h"

@interface FinalPrototypeViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *amount_lb;

@property (strong, nonatomic) IBOutlet UITextView *friends_tv;

@property (strong, nonatomic) IBOutlet UILabel *location_lb;

@property (strong, nonatomic) IBOutlet UILabel *average_lb;


@property (nonatomic) Bill *billObj;





- (IBAction)upload_btn:(UIButton *)sender;

- (IBAction)share_btn:(UIButton *)sender;

@end
