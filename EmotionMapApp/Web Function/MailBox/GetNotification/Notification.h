//
//  Notification.h
//  EmotionMapApp
//
//  Created by Jun Mao on 7/17/14.
//  Copyright (c) 2014 Syracuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject

@property (nonatomic) int bottleID;
@property (nonatomic) int ID;       //notification id
@property (nonatomic) int locationID;
@property (nonatomic) int type;     // 1:a hug operation, 2:a comment operation
@property (copy, nonatomic) NSString *createTime;
@property (copy, nonatomic) NSString *notificationDescription;
@property (copy, nonatomic) NSString *userID;  // the owner of the emotion 

@end
