//
//  GeoPointAnnotation.h
//  Geolocations
//
//  Created by Héctor Ramos on 8/2/12.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface GeoPointAnnotation : NSObject <MKAnnotation>

- (id)initWithObject:(PFObject *)aObject;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;

@end
