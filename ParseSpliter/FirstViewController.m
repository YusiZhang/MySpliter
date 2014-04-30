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
#import "FirstPageTableViewController.h"


@interface FirstViewController ()

@end

@implementation FirstViewController{
    NSString *name;
    NSMutableDictionary *dic;
    NSMutableDictionary *dic2;
//    FirstPageTableViewController *first;
    
}
@synthesize tableView;
@synthesize owned_lb;
@synthesize youown_lb;

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
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title.png"]];
    dic = [[NSMutableDictionary alloc]init];
    dic2 = [[NSMutableDictionary alloc]init];
    mainArray = [[NSMutableArray alloc] initWithObjects:@"this", @"is", @"a", @"table", @"view", nil];
    tableView.delegate = self;
    tableView.dataSource = self;

    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title.png"]];
    
    
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
        
        logInViewController.logInView.backgroundColor = [UIColor colorWithPatternImage:
                                                         [UIImage imageNamed:@"BlueBackground.png"]];
        
        
        
        logInViewController.logInView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
        
        logInViewController.logInView.logo.frame = CGRectMake(66.5f, 70.0f, 180.0f, 110.5f);
        
        [logInViewController.logInView.facebookButton setImage: nil forState:UIControlStateNormal];
        [logInViewController.logInView.facebookButton setImage: nil  forState:UIControlStateHighlighted];
        
        [logInViewController.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"fb-login-button.png"] forState:UIControlStateHighlighted];
        [logInViewController.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"fb-login-button.png"] forState:UIControlStateNormal];
        [logInViewController.logInView.facebookButton setTitle:@"" forState:UIControlStateNormal];
        [logInViewController.logInView.facebookButton setTitle:@"" forState:UIControlStateHighlighted];


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
            //fetch user's bill info and calculate overall balance;
            //calculate positive1
            name = userData[@"name"];
            NSLog(@"Login name is %@", name);
            PFQuery *query = [PFQuery queryWithClassName:@"Bill"];
            
            [query whereKey:@"owner" equalTo:name];
            NSLog(query.debugDescription);
            NSArray *objArray = [query findObjects];
            double positive = 0;
            
            for ( PFObject *object in objArray) {
                positive += [object[@"amount"] doubleValue];
            }
            
            
            
            NSNumber *number = [[NSNumber alloc] initWithDouble: positive];
            NSLog(@"positive amount is %@",[number stringValue]);
            owned_lb.text = [owned_lb.text stringByAppendingString:[number stringValue]];
            
            //============================================================
            //calculate negetive2
            //============================================================
            PFQuery *query2 = [PFQuery queryWithClassName:@"Bill"];
            [query2 whereKey:@"ownee" equalTo:name];
            NSArray *objArray2 = [query2 findObjects];
            NSLog(@"%@",objArray2.debugDescription);

            //nonosfe
            double negetive = 0;
            
            for ( PFObject *object2 in objArray2) {
                negetive += [object2[@"amount"] doubleValue];
            }
            NSNumber *number2 = [[NSNumber alloc] initWithDouble: negetive];
            NSLog(@"negetive amount is %@",[number2 stringValue]);
            youown_lb.text = [youown_lb.text stringByAppendingString:[number2 stringValue]];
            
            
            
//            double balance = positive - negetive;
            
            //============================================================
            //calculate overall group by people
            //============================================================
            PFQuery *query3 = [PFQuery queryWithClassName:@"Bill"];
            [query3 whereKey:@"owner" equalTo:name];
            NSArray *objArray3 = [query3 findObjects];
            for ( PFObject *object3 in objArray3) {
                NSString *owner = object3[@"owner"];
                //                NSLog(owner);
                if (([object3[@"ownee"] isEqualToString:owner]) == NO){
                    if ([[dic allKeys] containsObject:object3[@"ownee"]]) {
                        double sum = [[dic objectForKey:object3[@"ownee"]] doubleValue] + [object3[@"amount"] doubleValue];
                        NSNumber *number3 = [[NSNumber alloc] initWithDouble: sum];
                        [dic setValue:[number3 stringValue]forKey:object3[@"ownee"]];
                    } else {
                        double sum = [object3[@"amount"] doubleValue];
                        NSNumber *number3 = [[NSNumber alloc] initWithDouble: sum];
                        [dic setValue:[number3 stringValue ]forKey:object3[@"ownee"]];
                    }
                }
            }
            NSLog(dic.debugDescription);
            
            //            NSMutableDictionary *dic2 = [[NSMutableDictionary alloc]init];
            PFQuery *query4 = [PFQuery queryWithClassName:@"Bill"];
            [query4 whereKey:@"ownee" equalTo:name];
            NSArray *objArray4 = [query4 findObjects];
            for ( PFObject *object4 in objArray4) {
                NSString *owner = object4[@"owner"];
                if (([object4[@"ownee"] isEqualToString:owner]) == NO){
                    if ([[dic2 allKeys] containsObject:object4[@"ownee"]]) {
                        double sum = [[dic2 objectForKey:object4[@"owner"]] doubleValue] + [object4[@"amount"] doubleValue];
                        NSNumber *number4 = [[NSNumber alloc] initWithDouble: sum];
                        [dic2 setValue:[number4 stringValue]forKey:object4[@"owner"]];
                    } else {
                        double sum = [object4[@"amount"] doubleValue] * -1;
                        NSNumber *number4 = [[NSNumber alloc] initWithDouble: sum];
                        [dic2 setValue:[number4 stringValue]forKey:object4[@"owner"]];
                    }
                }
            }
            
            for (NSString *ownee in dic) {
                if ([[dic2 allKeys] containsObject:ownee]) {
                    double sum = [dic[ownee] doubleValue] + [dic2[ownee] doubleValue];
                    NSNumber *result = [[NSNumber alloc] initWithDouble: sum];
                    [dic setValue:[result stringValue] forKey:ownee];
                }
            }
            //add those not created by owner.
            for (NSString *owner in dic2) {
                if ([[dic allKeys] containsObject:owner] == NO) {
                    double sum = [dic2[owner] doubleValue];
                    NSNumber *result = [[NSNumber alloc] initWithDouble: sum];
                    [dic setValue:[result stringValue] forKey:owner];
                }
            }
            
            [tableView reloadData];
            

            
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    NSLog(@"in section is called");
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    // Configure the cell...
//    cell.textLabel.text = [mainArray objectAtIndex:indexPath.row];
    NSLog(@"cellforrowatindexpath is called!");
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if ([dic count] > 0) {
        
        
        NSString *key = [dic allKeys][indexPath.row];
        NSLog(key.debugDescription);
        NSString *amount = [dic objectForKey:key];
        NSString *owner = key;
        NSLog(owner.debugDescription);

        cell.textLabel.text  = owner;
//        cell.detailTextLabel.text  = amount;
        cell.textLabel.text = [cell.textLabel.text stringByAppendingString:@": \t $ "];
        cell.textLabel.text = [cell.textLabel.text stringByAppendingString:amount];

    }

    
    return cell;
    
    
}


@end
