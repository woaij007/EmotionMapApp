//
//  SendHugOrComment.h
//  EmotionMapApp
//
//  Created by Jun Mao on 7/16/14.
//  Copyright (c) 2014 Syracuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendHugOrComment : NSObject

@property (nonatomic) int followType;
@property (nonatomic) int uID;
@property (nonatomic) int locationID;
@property (nonatomic) CGFloat lat;
@property (nonatomic) CGFloat lng;
@property (copy, nonatomic) NSString *sendText;
@property (copy, nonatomic) NSString *idStr;
@property (copy, nonatomic) NSString *deviceID;
@property (copy, nonatomic) NSString *userName;

- (void)sendHugOrComment;

@end
