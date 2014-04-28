//
//  LoginViewController.h
//  ParseSpliter
//
//  Created by Yusi Zhang on 4/24/14.
//  Copyright (c) 2014 08723 A4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class FinalPrototypeViewController;

@interface LoginViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (strong,nonatomic) FinalPrototypeViewController *loginviewcontroller;

@end
