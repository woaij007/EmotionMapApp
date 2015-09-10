//
//  GetHugsOrComments.h
//  EmotionMapApp
//
//  Created by Jun Mao on 7/16/14.
//  Copyright (c) 2014 Syracuse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HugOrComment.h"

@interface GetHugsOrComments : NSObject

@property (nonatomic) int followType;
@property (nonatomic) int uID;
@property (nonatomic) int locationID;
@property (nonatomic) int startID;
@property (nonatomic) CGFloat lat;
@property (nonatomic) CGFloat lng;
@property (copy, nonatomic) NSString *deviceID;

//data response from server
@property (strong, nonatomic) NSMutableArray *hugorcommentList;

- (void)getHugsOrComments;

@end
