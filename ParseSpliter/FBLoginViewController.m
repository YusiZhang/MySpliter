//
//  FBLoginViewController.m
//  ParseSpliter
//
//  Created by Yusi Zhang on 4/26/14.
//  Copyright (c) 2014 08723 A4. All rights reserved.
//

#import "FBLoginViewController.h"
#import "FirstViewController.h"


@interface FBLoginViewController ()

@end

@implementation FBLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Check if user is cached and linked to Facebook, if so, bypass login
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
//        FirstViewController *vc = [[FirstViewController alloc] init];
//        [self presentViewController: vc animated:YES completion:NULL ];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickFBLogin_btn:(UIButton *)sender {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
//        [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
//            FirstViewController *vc = [[FirstViewController alloc] init];
//            [self presentViewController: vc animated:YES completion:NULL ];
            [self dismissViewControllerAnimated:YES completion:NULL];
        } else {
            NSLog(@"User with facebook logged in!");
//            FirstViewController *vc = [[FirstViewController alloc] init];
//            [self presentViewController: vc animated:YES completion:NULL ];

            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }];
    
//    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
}
@end
