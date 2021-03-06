//
//  FinalPrototypeViewController.m
//  ParseSpliter
//
//  Created by Yusi Zhang on 4/23/14.
//  Copyright (c) 2014 08723 A4. All rights reserved.
//

#import "FinalPrototypeViewController.h"
#import <Parse/Parse.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "MBProgressHUD.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FirstViewController.h"


@interface FinalPrototypeViewController ()



@end

@implementation FinalPrototypeViewController
@synthesize  amount_lb;
@synthesize friends_tv;
@synthesize location_lb;
@synthesize average_lb;
@synthesize description;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title.png"]];

    //set amount
   amount_lb.text = [amount_lb.text stringByAppendingString:_billObj.amount];
    //set location
    location_lb.text = [location_lb.text stringByAppendingString:_billObj.location];
   
    //set average
    //string to double and double to string
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * amount = [f numberFromString:_billObj.amount];
    NSNumber * count = [f numberFromString:_billObj.count];
    double average = [amount doubleValue] / [count doubleValue];
    NSNumber *myaverage = [NSNumber numberWithDouble:average];
    average_lb.text = [average_lb.text stringByAppendingString:[myaverage stringValue]];
    
    //set friends names
    for (NSString *name in _billObj.friends) {
        [name stringByAppendingString:@"\n"];
        friends_tv.text = [friends_tv.text stringByAppendingString:name];
        friends_tv.text = [friends_tv.text stringByAppendingString:@"; "];
    }
    //set description
    description.text = _billObj.description;
    

}




#pragma mark - Button 



- (IBAction)upload_btn:(UIButton *)sender {
    

    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * amount = [f numberFromString:_billObj.amount];
    NSNumber * count = [f numberFromString:_billObj.count];
    double average = [amount doubleValue] / [count doubleValue];
    NSNumber *myaverage = [NSNumber numberWithDouble:average];
    int i = 0;
    int index = [_billObj.friends count];
    for (NSString *name in _billObj.friends) {
        PFObject *bill = [PFObject objectWithClassName:@"Bill"];
        bill[@"owner"] = _billObj.owner;
        bill[@"ownee"] = name;

        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        [formatter setMaximumFractionDigits:2];
        
        [formatter setRoundingMode: NSNumberFormatterRoundUp];

        NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:[myaverage floatValue]]];
        bill[@"amount"] = numberString;
        bill[@"location"] = _billObj.location;
        bill[@"lat"] = _billObj.lat;
        bill[@"lon"] = _billObj.lon;
        bill[@"owneeid"] = _billObj.ids[i];
        bill[@"description"] = _billObj.description;
        NSData *imageData = UIImageJPEGRepresentation(_billObj.image, 1.00f);
        PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
        bill[@"image"] = imageFile;
//        bill[@"owneeid"] = [_billObj.ids objectAtIndex:i];
        NSLog(@"Final id is %@",[_billObj.ids objectAtIndex:i]);
        i++;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Uploading";
        [hud show:YES];
        
        
        [bill saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [hud hide:YES];
            
            if (!error) {
                // Show success message
                if (index== 1) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Your bill is created." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                                    }
                // Notify table view to reload the recipes from Parse cloud
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                
                // Dismiss the controller
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            
        }];
        index--;
        
    }
    
    
    
}
//alert delegete
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"user pressed Button Indexed 0");
        NSString *friends = [[NSString alloc]init];
        for (NSString *name in _billObj.friends) {
            friends = [friends stringByAppendingString:name];
            friends = [friends stringByAppendingString:@"; "];
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"MySpliter", @"name",
                                       @"Check Bills on MySpliter", @"caption",
                                       friends, @"description",
                                       @"https://developers.facebook.com/docs/ios/share/", @"link",
                                       @"http://i.imgur.com/g3Qc1HN.png", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
        FirstViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
//        [self.navigationController presentedViewController:vc];
        [self.navigationController popToRootViewControllerAnimated:YES];
//
      

    }
    else
    {
        NSLog(@"user pressed Button Indexed 1");
        // Any action can be performed here
    }
}

//- (IBAction)share_btn:(UIButton *)sender {
//    
//
//
//     // publish just a link using the Feed dialog
//    
//        // Put together the dialog parameters
//    NSString *friends = [[NSString alloc]init];
//    for (NSString *name in _billObj.friends) {
//        friends = [friends stringByAppendingString:name];
//        friends = [friends stringByAppendingString:@"; "];
//    }
//        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                       @"MySpliter", @"name",
//                                       @"Check Bills on MySpliter", @"caption",
//                                       friends, @"description",
//                                       @"https://developers.facebook.com/docs/ios/share/", @"link",
//                                       @"http://i.imgur.com/g3Qc1HN.png", @"picture",
//                                       nil];
//        
//        // Show the feed dialog
//        [FBWebDialogs presentFeedDialogModallyWithSession:nil
//                                               parameters:params
//                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
//                                                      if (error) {
//                                                          // An error occurred, we need to handle the error
//                                                          // See: https://developers.facebook.com/docs/ios/errors
//                                                          NSLog(@"Error publishing story: %@", error.description);
//                                                      } else {
//                                                          if (result == FBWebDialogResultDialogNotCompleted) {
//                                                              // User canceled.
//                                                              NSLog(@"User cancelled.");
//                                                          } else {
//                                                              // Handle the publish feed callback
//                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
//                                                              
//                                                              if (![urlParams valueForKey:@"post_id"]) {
//                                                                  // User canceled.
//                                                                  NSLog(@"User cancelled.");
//                                                                  
//                                                              } else {
//                                                                  // User clicked the Share button
//                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
//                                                                  NSLog(@"result %@", result);
//                                                              }
//                                                          }
//                                                      }
//                                                  }];
//
//   
    //after upload successfully back to homepage
//    FirstViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
//    [self presentViewController:vc animated:YES completion:nil];
//
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

@end
