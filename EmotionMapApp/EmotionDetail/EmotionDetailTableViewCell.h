//
//  EmotionDetailTableViewCell.h
//  EmotionMapApp
//
//  Created by wayne on 14-7-18.
//  Copyright (c) 2014年 Syracuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FBProfilePictureView.h>

@interface EmotionDetailTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet FBProfilePictureView *listUserProfilePicture;
@property (strong, nonatomic) IBOutlet UILabel *listUserNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *listCommentLabel;
@property (strong, nonatomic) IBOutlet UILabel *listTimeLabel;


@end
