//
//  LikeASuggestion.h
//  EmotionMapApp
//
//  Created by Jun Mao on 7/16/14.
//  Copyright (c) 2014 Syracuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LikeASuggestion : NSObject

@property (nonatomic) int suggestionID;
@property (nonatomic) int uID;
@property (nonatomic) CGFloat lat;
@property (nonatomic) CGFloat lng;
@property (copy, nonatomic) NSString *deviceID;

- (void)likeASuggestion;

@end
