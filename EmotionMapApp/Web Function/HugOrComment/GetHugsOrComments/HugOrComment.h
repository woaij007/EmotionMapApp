//
//  HugOrComment.h
//  EmotionMapApp
//
//  Created by Jun Mao on 7/17/14.
//  Copyright (c) 2014 Syracuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HugOrComment : NSObject

@property (nonatomic) int blocked;
@property (nonatomic) int followID;
@property (nonatomic) int followType;
@property (nonatomic) int ID;
@property (copy, nonatomic) NSString *followComment;
@property (copy, nonatomic) NSString *createTime;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *userID;

@end
