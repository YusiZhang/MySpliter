//
//  DetailBillViewController.m
//  ParseSpliter
//
//  Created by Yusi Zhang on 4/27/14.
//  Copyright (c) 2014 08723 A4. All rights reserved.
//

#import "DetailBillViewController.h"
#import "GeoPointAnnotation.h"
#import <Parse/Parse.h>

@interface DetailBillViewController ()


@end

@implementation DetailBillViewController
@synthesize ownee_lb;
@synthesize owner_lb;
@synthesize time_lb;
@synthesize amount_lb;
@synthesize image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@",_billObj.ownee);
    ownee_lb.text = _billObj.ownee;
    owner_lb.text = _billObj.owner;
    amount_lb.text = [amount_lb.text stringByAppendingString:_billObj.amount];
    time_lb.text = _billObj.time;
    
    image.image = _billObj.image;
    
    // center our map view around this geopoint
    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake([_billObj.lat doubleValue], [_billObj.lon doubleValue]), MKCoordinateSpanMake(0.005f, 0.005f));
    
    NSLog(@"%@", [_billObj.lat stringValue]);
//    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(51.50998, -0.1337), MKCoordinateSpanMake(0.01f, 0.01f));
    
    
    // add the annotation
    GeoPointAnnotation *annotation = [[GeoPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake([_billObj.lat doubleValue], [_billObj.lon doubleValue]);
    annotation.title = _billObj.location;
    [self.mapView addAnnotation:annotation];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title.png"]];
    
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *GeoPointAnnotationIdentifier = @"RedPin";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:GeoPointAnnotationIdentifier];
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:GeoPointAnnotationIdentifier];
        annotationView.pinColor = MKPinAnnotationColorRed;
        annotationView.canShowCallout = YES;
        annotationView.draggable = YES;
        annotationView.animatesDrop = YES;
    }
    
    return annotationView;
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

@end
