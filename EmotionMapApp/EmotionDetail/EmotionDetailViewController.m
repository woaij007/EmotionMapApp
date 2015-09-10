//
//  EmotionDetailViewController.m
//  EmotionMapApp
//
//  Created by wayne on 14-7-13.
//  Copyright (c) 2014年 Syracuse. All rights reserved.
//

#import "EmotionDetailViewController.h"
#import "EmotionDetailTableViewCell.h"
#import <FacebookSDK/FBProfilePictureView.h>
#import "SendHugOrComment.h"
#import "GetHugsOrComments.h"

static NSString *cellIdentifier = @"ListCell";
static int HUG = 1;
static int COMMENT = 2;

@interface EmotionDetailViewController ()

@property (copy, nonatomic) NSArray *imageArray;

@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfilePicture;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *emotionImage;
@property (strong, nonatomic) IBOutlet UILabel *emotionLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (copy, nonatomic) NSArray *hugList;
@property (copy, nonatomic) NSArray *commentList;

// Data for hug/comment
@property (nonatomic) int followType;
@property (copy, nonatomic) NSString *sendText;

- (IBAction)segmentAction:(UISegmentedControl *)sender;
- (IBAction)hugOrComment:(UIButton *)sender;

@end

@implementation EmotionDetailViewController

@synthesize userID, userName, emotionID, emotionDescription, hugCount, commentCount, hugList, commentList, address, timeStamp;
@synthesize followType, uID, locationID, lat, lng, sendText, idStr, deviceID, commentUserName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageArray = [NSArray arrayWithObjects:@"Happy", @"Excited", @"Sad", @"Tense",
                       @"Stressed", @"Upset", @"Bored", @"Calm",
                       @"Alert", @"Contented", @"Serene", @"Fatigued",
                       @"Nervous", @"Depressed", @"Elated", @"Relaxed",
                       @"Frustrated", @"Angry", @"Scared", @"Lonely", nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getHugOrCommentList:HUG from:hugCount];
    //[self getHugOrCommentList:COMMENT from:0];
    [self setAllData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   
    if (self.listTableView.delegate == nil)
        self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    else
        self.listTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    if (self.segmentedControl.selectedSegmentIndex == 1)
        return commentCount;
    
    return hugCount;
}

#pragma mark - UITableView datasource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EmotionDetailTableViewCell *cell = (EmotionDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSString *listUserID = [[NSString alloc] init];
    NSString *listUserName = [[NSString alloc] init];
    NSString *listComment = [[NSString alloc] init];
    NSString *listTimeStamp = [[NSString alloc] init];
    
    if (!self.segmentedControl.selectedSegmentIndex) {
        NSDictionary *hugPerson = hugList[hugCount - indexPath.row];
        NSLog(@"hug info is %@", hugList);
        listUserID = [hugPerson objectForKey:@"userid"];
        listUserName = [hugPerson objectForKey:@"name_"];
        listComment = @"";
        NSString *destDateString = [hugPerson objectForKey:@"createtime"];
        
        NSDate *createTime = [NSDate dateWithTimeIntervalSince1970:[destDateString doubleValue] / 1000];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yy  HH:mm:ss"];
        listTimeStamp = [dateFormatter stringFromDate:createTime];
    }
    else if (self.segmentedControl.selectedSegmentIndex == 1) {
        NSLog(@"%i", indexPath.row);
        NSDictionary *commentPerson = commentList[indexPath.row];
        
        listUserID = [commentPerson objectForKey:@"userid"];
        listUserName = [commentPerson objectForKey:@"name_"];
        listComment = [commentPerson objectForKey:@"comment"];
        NSString *destDateString = [commentPerson objectForKey:@"createtime"];
        
        NSDate *createTime = [NSDate dateWithTimeIntervalSince1970:[destDateString doubleValue] / 1000];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yy  HH:mm:ss"];
        listTimeStamp = [dateFormatter stringFromDate:createTime];
    }
    
    cell.listUserProfilePicture.profileID = listUserID;
    cell.listUserNameLabel.text = listUserName;
    cell.listCommentLabel.text = listComment;
    [cell.listCommentLabel sizeToFit];
    cell.listTimeLabel.text = listTimeStamp;
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - All object methods

- (void)setAllData
{
    self.userProfilePicture.profileID = userID;
    self.userNameLabel.text = userName;
    self.emotionLabel.text = self.imageArray[emotionID];
    
    NSString *imageToLoad = [NSString stringWithFormat:@"orange_%@.png", self.imageArray[emotionID]];
    self.emotionImage.image = [UIImage imageNamed:imageToLoad];
    
    self.statusLabel.text = emotionDescription;
    [self.statusLabel sizeToFit];
    
    self.addressLabel.text = address;
    self.timeLabel.text = timeStamp;
    
    [self setHugOrCommentData];
}

- (void)setHugOrCommentData
{
    NSString *titleForHug = [[NSString alloc] initWithFormat:@"Hug (%i)", hugCount];
    NSString *titleForComment = [[NSString alloc] initWithFormat:@"Comment (%i)", commentCount];
    [self.segmentedControl setTitle:titleForHug forSegmentAtIndex:0];
    [self.segmentedControl setTitle:titleForComment forSegmentAtIndex:1];
    
    [self.listTableView reloadData];
}

- (void)getHugOrCommentList:(int)type from:(int)startPoint
{
    GetHugsOrComments *getData = [[GetHugsOrComments alloc] init];
    
    getData.followType = type;
    getData.uID = 1;
    getData.locationID = locationID;
    getData.startID = startPoint;
    getData.lat = lat;
    getData.lng = lng;
    getData.deviceID = @"065577820acc8ef8";
    
    [getData getHugsOrComments];
    
}

#pragma mark - All buttons action methods

- (IBAction)segmentAction:(UISegmentedControl *)sender {
    [self.listTableView reloadData];
}

- (IBAction)hugOrComment:(UIButton *)sender
{
    SendHugOrComment *newComment = [[SendHugOrComment alloc] init];
    
    if (sender.tag == 101) {
        followType = HUG;
        sendText = @"no comment";
    }
    else if (sender.tag == 102) {
        followType = COMMENT;
        sendText = emotionDescription;
    }
    
    uID = 1;
    idStr = @"100007930481901,100007430075210,100007231501353,661149005,724130934,848845120,1085234071,1173644147,100000130793067100006283807652,100006588150856,166400861,506891389,12404593,100008006828530";
    deviceID = @"065577820acc8ef8";
    commentUserName = @"Yu Sun";
    
    newComment.followType = followType;
    newComment.uID = uID;
    newComment.locationID = locationID;
    newComment.lat = lat;
    newComment.lng = lng;
    newComment.sendText = sendText;
    newComment.idStr = idStr;
    newComment.deviceID = deviceID;
    newComment.userName = commentUserName;
    
    [newComment sendHugOrComment];
}

@end
