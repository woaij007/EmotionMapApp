//
//  RecommendTableViewCell.h
//  EmotionMapApp
//
//  Created by wayne on 14-7-18.
//  Copyright (c) 2014年 Syracuse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *recommendCatIcon;
@property (strong, nonatomic) IBOutlet UILabel *recommendContentLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UILabel *likeNumberLabel;

@end
