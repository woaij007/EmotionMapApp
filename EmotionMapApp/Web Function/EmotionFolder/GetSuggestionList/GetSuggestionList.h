//
//  GetSuggestionList.h
//  EmotionMapApp
//
//  Created by Jun Mao on 7/16/14.
//  Copyright (c) 2014 Syracuse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Suggestion.h"

@interface GetSuggestionList : NSObject

@property (nonatomic) int emotionID;
@property (nonatomic) int uID;
@property (nonatomic) CGFloat lat;
@property (nonatomic) CGFloat lng;
@property (copy, nonatomic) NSString *deviceID;

//data response from server
@property (strong, nonatomic) NSMutableArray *suggestionList;

- (void)getSuggestionList;

@end
