//
//  AddEmotionViewController.h
//  EmotionMapApp
//
//  Created by wayne on 14-7-3.
//  Copyright (c) 2014年 Syracuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CombBoxChoose.h"

@interface AddEmotionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate,
                                                        CLLocationManagerDelegate, CombBoxChooseDataSource,CombBoxChooseDelegate>

@end
