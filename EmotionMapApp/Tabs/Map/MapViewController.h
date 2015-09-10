//
//  MapViewController.h
//  EmotionMapApp
//
//  Created by wayne on 14-6-22.
//  Copyright (c) 2014年 Syracuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapLocation.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKReverseGeocoderDelegate, MKMapViewDelegate>

@property (strong, nonatomic) NSMutableArray *mapAnnotations;

@end
