//
//  GetNotification.h
//  EmotionMapApp
//
//  Created by Jun Mao on 7/16/14.
//  Copyright (c) 2014 Syracuse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Notification.h"

@interface GetNotification : NSObject

@property (nonatomic) int uID;
@property (nonatomic) CGFloat lat;
@property (nonatomic) CGFloat lng;
@property (copy, nonatomic) NSString *deviceID;
@property (nonatomic) NSString *currentTime;

//data response from server
@property (strong, nonatomic) NSMutableArray *notificationList;

- (void)getNotification;

@end
