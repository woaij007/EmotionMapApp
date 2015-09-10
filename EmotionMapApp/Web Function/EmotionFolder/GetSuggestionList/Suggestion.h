//
//  Suggestion.h
//  EmotionMapApp
//
//  Created by Jun Mao on 7/17/14.
//  Copyright (c) 2014 Syracuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Suggestion : NSObject

@property (nonatomic) int categoryID;
@property (nonatomic) int suggestionID;
@property (nonatomic) int likesNUM;
@property (nonatomic) int uID;
@property (nonatomic) int emotionID;
@property (copy, nonatomic) NSString *suggestionDescription;
@property (copy, nonatomic) NSString *suggestionTag;

@end
