//
//  DeleteNotification.h
//  EmotionMapApp
//
//  Created by Jun Mao on 7/16/14.
//  Copyright (c) 2014 Syracuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeleteNotification : NSObject

@property (nonatomic) int nID;
@property (nonatomic) int uID;
@property (nonatomic) CGFloat lat;
@property (nonatomic) CGFloat lng;
@property (copy, nonatomic) NSString *deviceID;

//data response from server
@property (nonatomic) int deleteResut; // if result > 0, delete operation is success

- (void)deleteNotification;

@end
