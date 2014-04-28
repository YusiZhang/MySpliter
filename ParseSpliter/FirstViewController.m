//
//  FirstViewController.m
//  ParseSpliter
//
//  Created by Yusi Zhang on 4/25/14.
//  Copyright (c) 2014 08723 A4. All rights reserved.
//

#import "FirstViewController.h"
#import <Parse/Parse.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "MBProgressHUD.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MyTableViewController.h"
#import "Bill.h"


@interface FirstViewController ()

@end

@implementation FirstViewController{
    NSString *name;
}

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
    name = [[NSString alloc]init];
    NSLog(@"Bundle ID: %@",[[NSBundle mainBundle] bundleIdentifier]);
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //Show login page
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        logInViewController.fields = PFLogInFieldsFacebook;
        
        logInViewController.facebookPermissions = @[@"friends_about_me"];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];


    }
    
}

#pragma mark - PFLogInViewControllerDelegate


// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    
    
    
    //successfully login and set profile pic;
    FBRequest *request = [FBRequest requestForMe];
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            //set profile pic
            NSString *facebookID = userData[@"id"];
            self.profile_uiview.profileID = facebookID;
            
            self.profile_uiview.layer.cornerRadius = self.profile_uiview.frame.size.width / 2;
//            self.profile_uiview.layer.cornerRadius = self.profile_uiview.frame.size.width / 2;
//
//            self.profile_uiview.clipsToBounds = YES;
//            
//            self.profile_uiview.layer.borderWidth = 3.0f;
//            self.profile_uiview.layer.borderColor = [UIColor whiteColor].CGColor;
        }
    }];
    
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Button function

- (IBAction)click_checkbalance:(UIButton *)sender {
    //navigate to pfquery table page
    
    FBRequest *request = [FBRequest requestForMe];
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            name = userData[@"name"];
            NSLog(@"FaceBook user name is %@",name);
        }
    }];
}

- (IBAction)click_createbill:(UIButton *)sender {
    //navigate to creationg vc
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"MyTableViewController"]) {
        MyTableViewController *dvc = [segue destinationViewController];
        dvc.name = name;
        
    }
    
}



@end
