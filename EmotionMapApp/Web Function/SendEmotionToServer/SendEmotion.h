//
//  SendEmotion.h
//  EmotionMapApp
//
//  Created by wayne on 14-7-8.
//  Copyright (c) 2014年 Syracuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendEmotion : NSObject

@property (nonatomic) int emotionID;
@property (nonatomic) int eventID;
@property (nonatomic) int placeID;
@property (nonatomic) int level;
@property (nonatomic) int anonymousFlag;
@property (nonatomic) CGFloat lat;
@property (nonatomic) CGFloat lng;
@property (copy, nonatomic) NSString *sendText;
@property (copy, nonatomic) NSString *idStr;
@property (copy, nonatomic) NSString *address;

//data response from server
@property (copy, nonatomic) NSString *responseText;

- (void)sendEmotionToServer;

@end
