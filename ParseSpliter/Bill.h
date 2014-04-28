//
//  Bill.h
//  ParseSpliter
//
//  Created by Yusi Zhang on 4/25/14.
//  Copyright (c) 2014 08723 A4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Bill : NSObject

@property (strong, nonatomic) NSString *owner;
@property (strong, nonatomic) NSString *ownee;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *amount;

@property (strong, nonatomic) NSString *count;
@property (strong, nonatomic) NSMutableArray *friends;
@property (strong, nonatomic) NSMutableArray *ids;

@property (strong, nonatomic) NSNumber *lon;
@property (strong, nonatomic) NSNumber *lat;




@end
