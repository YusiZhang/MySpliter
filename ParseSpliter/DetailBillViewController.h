//
//  DetailBillViewController.h
//  ParseSpliter
//
//  Created by Yusi Zhang on 4/27/14.
//  Copyright (c) 2014 08723 A4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface DetailBillViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic) Bill *billObj;


@property (strong, nonatomic) IBOutlet UILabel *time_lb;
@property (strong, nonatomic) IBOutlet UILabel *ownee_lb;
@property (strong, nonatomic) IBOutlet UILabel *owner_lb;
@property (strong, nonatomic) IBOutlet UILabel *amount_lb;

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) PFObject *detailItem;

@end
