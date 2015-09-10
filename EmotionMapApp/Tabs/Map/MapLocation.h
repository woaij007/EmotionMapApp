//
//  MapLocation.h
//  EmptionMap
//
//  Created by wayne on 14-5-17.
//  Copyright (c) 2014年 Syracuse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapLocation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

// Data for show on view.
@property (copy, nonatomic) NSString *userID;
@property (copy, nonatomic) NSString *userName;
@property (nonatomic) int emotionID;
@property (copy, nonatomic) NSString *emotionDescription;
@property (nonatomic) int hugCount;
@property (nonatomic) int commentCount;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSDate *timeStamp;

// Data for comment.
@property (nonatomic) int locationID; // Which emotion to comment.

@end
