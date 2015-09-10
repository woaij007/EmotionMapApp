//
//  GetSuggestionList.m
//  EmotionMapApp
//
//  Created by Jun Mao on 7/16/14.
//  Copyright (c) 2014 Syracuse. All rights reserved.
//

#import "GetSuggestionList.h"
#import "APIDelegate.h"

@implementation GetSuggestionList

@synthesize uID, lat, lng, deviceID, emotionID, suggestionList;

- (void)getSuggestionList
{
    NSString *param = [NSString stringWithFormat:@"https://orange.ischool.syr.edu:8443/emotionmap-android-group/control/map/mark.do?method=getEmotionSuggestions&parameter={ "
                       "\"device\":\"%@\", "
                       "\"emotionId\":%d, "
                       "\"lat\":%f, "
                       "\"lng\":%f, "
                       "\"uid\":%d "
                       "}", deviceID, emotionID, lat, lng, uID];
    
    NSString *url = [param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", url);
    
    NSURL *sendUrl = [NSURL URLWithString:url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:sendUrl];
    APIDelegate *apiRequest = [[APIDelegate alloc] init];
    [apiRequest addDelegate:self];
    
    (void)[[NSURLConnection alloc] initWithRequest:urlRequest delegate:apiRequest startImmediately:YES];
}


- (void)finishWithData:(NSData *)returnData
{
    NSLog(@"Response for getting suggestion list");
    NSDictionary *alldata = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
    NSArray *data = [alldata objectForKey:@"data"];
    NSLog(@"%@",data);
    // Parse data here
    Suggestion *mySuggestion;
    suggestionList = [[NSMutableArray alloc]init];
    for (NSDictionary *diction in data) {
        NSString *categoryID = [diction objectForKey:@"categoryid"];
        NSString *suggestionDescription = [diction objectForKey:@"description"];
        NSString *myemotionID = [diction objectForKey:@"emotionid"];
        NSString *suggestionID = [diction objectForKey:@"id"];
        NSString *likesNUM = [diction objectForKey:@"likes"];
        NSString *suggestionTag = [diction objectForKey:@"tag"];
        NSString *myuID = [diction objectForKey:@"uid"];
        
        mySuggestion = [[Suggestion alloc]init];
        mySuggestion.categoryID = [categoryID intValue];
        mySuggestion.suggestionDescription = suggestionDescription;
        mySuggestion.emotionID = [myemotionID intValue];
        mySuggestion.suggestionID = [suggestionID intValue];
        mySuggestion.likesNUM = [likesNUM intValue];
        mySuggestion.suggestionTag = suggestionTag;
        mySuggestion.uID = [myuID intValue];
        
        [suggestionList addObject:mySuggestion];
    }
}
@end
