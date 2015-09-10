//
//  EmotionDetailViewController.h
//  EmotionMapApp
//
//  Created by wayne on 14-7-13.
//  Copyright (c) 2014年 Syracuse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmotionDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

// Data for show on view
@property (copy, nonatomic) NSString *userID;
@property (copy, nonatomic) NSString *userName;
@property (nonatomic) int emotionID;
@property (copy, nonatomic) NSString *emotionDescription;
@property (nonatomic) int hugCount;
@property (nonatomic) int commentCount;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *timeStamp;

// Data for hug/comment
@property (nonatomic) int uID;
@property (nonatomic) int locationID;
@property (nonatomic) CGFloat lat;
@property (nonatomic) CGFloat lng;
@property (copy, nonatomic) NSString *idStr;
@property (copy, nonatomic) NSString *deviceID;
@property (copy, nonatomic) NSString *commentUserName;

@end
