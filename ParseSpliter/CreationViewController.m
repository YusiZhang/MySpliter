//
//  CreationViewController.m
//  ParseSpliter
//
//  Created by Yusi Zhang on 4/25/14.
//  Copyright (c) 2014 08723 A4. All rights reserved.
//

#import "CreationViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Bill.h"
#import <Parse/Parse.h>
#import "FinalPrototypeAppDelegate.h"
#import "FinalPrototypeViewController.h"


@interface CreationViewController (){
    CLLocationManager *locationManager;
    CLLocationCoordinate2D *coordinate2D;
    double lat;
    double lan;
}


@end

@implementation CreationViewController {
    Bill *billObj;
}

@synthesize amout_tf;
@synthesize count_lb;
@synthesize location_lb;
@synthesize description_tf;
//@synthesize billObj;


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
    //init billObj
    billObj = [[Bill alloc] init];
    
    //*************************Object in Object need to be init**************//
    billObj.friends = [[NSMutableArray alloc] init];
    billObj.ids = [[NSMutableArray alloc]init];
    billObj.image = [[UIImage alloc]init];
    //*************************Object in Object need to be init**************//
    
    locationManager = [[CLLocationManager alloc] init];
    lat = 0;
    lan = 0;
    [PFFacebookUtils session];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    
    
    tapGr.cancelsTouchesInView = NO;
    
    
    [self.view addGestureRecognizer:tapGr];
    
    //set location when view loaded.
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title.png"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickPickFriends:(UIButton *)sender {
    
    FBFriendPickerViewController *friendPickerController = [[FBFriendPickerViewController alloc] init];
    friendPickerController.title = @"Pick Friends";
    [friendPickerController loadData];
    
    // Use the modal wrapper method to display the picker.
    [friendPickerController presentModallyFromViewController:self animated:YES handler:
     ^(FBViewController *innerSender, BOOL donePressed) {
         if (!donePressed) {
             return;
         }
         
         NSString *message;
         
         if (friendPickerController.selection.count == 0) {
             message = @"<No Friends Selected>";
         } else {
             
             // we pick up the users from the selection, and create a string that we use to update the text view
             // at the bottom of the display; note that self.selection is a property inherited from our base class
             for (id<FBGraphUser> user in friendPickerController.selection) {
                 [billObj.friends addObject:user.name];
                 [billObj.ids addObject:user.id];
                 NSLog(@"%@",user.id);
                 NSString *inStr = [@([billObj.friends count]) stringValue];
                 NSLog(@"%@", inStr);
                 
             }

             
         }
         
         
         NSString *coutStr = [NSString stringWithFormat: @"%d", (int)friendPickerController.selection.count + 1];//including userself;
         count_lb.text = coutStr;
         NSLog(@"COUNT IS %@", coutStr);
     }];
    
    
    
    
    
}

- (IBAction)clickPickLocation:(UIButton *)sender {
    
    
    FBPlacePickerViewController *placePickerController = [[FBPlacePickerViewController alloc] init];
    placePickerController.title = @"Pick a Place";
    //============SHOULD USING GPS RETURN 2D COORDINATE!!!!!!!!!!================
    //    placePickerController.locationCoordinate = CLLocationCoordinate2DMake(47.6097, -122.3331);
    //    placePickerController.locationCoordinate = *(coordinate2D);
    placePickerController.locationCoordinate = CLLocationCoordinate2DMake(lat, lan);
    
    [placePickerController loadData];
    
    // Use the modal wrapper method to display the picker.
    [placePickerController presentModallyFromViewController:self animated:YES handler:
     ^(FBViewController *innerSender, BOOL donePressed) {
         if (!donePressed) {
             return;
         }
         
         NSString *placeName = placePickerController.selection.name;
         if (!placeName) {
             placeName = @"<No Place Selected>";
         }
         
         location_lb.text = placeName;
     }];
}

- (IBAction)clickNext:(UIButton *)sender {
    
    
    //set owner info
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            billObj.owner = userData[@"name"];
            NSLog(@"%@",billObj.owner);
        }
    }];
    
    
    
    
    
    
}

- (IBAction)clickPickImage_btn:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"prepareForSegue: %@", segue.identifier);
    if ([[segue identifier] isEqualToString:@"FinalPrototypeViewController"]) {
        
        
        billObj.lat = [NSNumber numberWithDouble:lat];
        billObj.lon = [NSNumber numberWithDouble:lan];
        
        billObj.location = location_lb.text;
        billObj.count = count_lb.text;
        [billObj setAmount:amout_tf.text];
        billObj.description = description_tf.text;
        
        NSLog(@"amount_tf.text: %@", amout_tf.text);
        NSLog(@"billObj.amount: %@", billObj.amount);
        
        // Get reference to the destination view controller
        FinalPrototypeViewController *dvc = [segue destinationViewController];
        dvc.billObj = billObj;
        NSLog(@"prepareForSegue amount: %@", billObj.amount);
        
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        lat = currentLocation.coordinate.latitude;
        lan = currentLocation.coordinate.longitude;
    }
    //stop updating at once!
    [locationManager stopUpdatingLocation];
}

#pragma mark - Return Keyboard deletege
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.amout_tf resignFirstResponder];
}


#pragma mark - ImagePickerDelegete
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.image.image = chosenImage;
    billObj.image = chosenImage;
    
    //    UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil);
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


@end
