//
//  GetHugsOrComments.m
//  EmotionMapApp
//
//  Created by Jun Mao on 7/16/14.
//  Copyright (c) 2014 Syracuse. All rights reserved.
//

#import "GetHugsOrComments.h"
#import "APIDelegate.h"

@implementation GetHugsOrComments

@synthesize followType, uID, locationID, lat, lng, deviceID, startID, hugorcommentList;

- (void)getHugsOrComments
{
    NSString *param = [NSString stringWithFormat:@"https://orange.ischool.syr.edu:8443/emotionmap-android-group/control/map/mark.do?method=getFollows&parameter={ "
                       "\"device\":\"%@\", "
                       "\"followtype\":%d, " // 1：add a hug 2: add a comment
                       "\"lat\":%f, "
                       "\"lng\":%f, "
                       "\"locationid\":%d, "
                       "\"startid\":%d, " // hug starts from maximum id,comment starts from minimum id
                       "\"uid\":%d "
                       "}", deviceID, followType, lat, lng, locationID, startID, uID];
    
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
    NSLog(@"Response for getting hugs or comments");
    NSDictionary *alldata = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
    NSArray *data = [alldata objectForKey:@"data"];
    NSLog(@"%@",data);
    // Parse data here
    HugOrComment *myHugOrComment;
    hugorcommentList = [[NSMutableArray alloc]init];
    for (NSDictionary *diction in data) {
        NSString *ID = [diction objectForKey:@"id"];
        NSString *blocked = [diction objectForKey:@"blocked"];
        NSString *myfollowType = [diction objectForKey:@"followtype"];
        NSString *followComment = [diction objectForKey:@"comment"];
        NSString *followID = [diction objectForKey:@"followid"];
        NSString *userID = [diction objectForKey:@"userid"];
        NSString *email = [diction objectForKey:@"email"];
        NSString *createTime = [diction objectForKey:@"createtime"];
        NSString *name = [diction objectForKey:@"name_"];
        
        myHugOrComment = [[HugOrComment alloc]init];
        myHugOrComment.ID = [ID intValue];
        myHugOrComment.followType = [myfollowType intValue];
        myHugOrComment.followComment = followComment;
        myHugOrComment.followID = [followID intValue];
        myHugOrComment.userID = userID;
        myHugOrComment.email = email;
        myHugOrComment.createTime = createTime;
        myHugOrComment.blocked = [blocked intValue];
        myHugOrComment.name = name;
        
        [hugorcommentList addObject:myHugOrComment];
    }
}

@end
