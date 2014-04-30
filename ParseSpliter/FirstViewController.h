//
//  FirstViewController.h
//  ParseSpliter
//
//  Created by Yusi Zhang on 4/25/14.
//  Copyright (c) 2014 08723 A4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBLoginViewController.h"

@interface FirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *mainArray;
}


- (IBAction)click_checkbalance:(UIButton *)sender;

- (IBAction)click_createbill:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profile_uiview;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *youown_lb;
@property (strong, nonatomic) IBOutlet UILabel *owned_lb;


@property (strong, nonatomic) IBOutlet UILabel *owe;

@property (strong, nonatomic) IBOutlet UILabel *owed;



@end
