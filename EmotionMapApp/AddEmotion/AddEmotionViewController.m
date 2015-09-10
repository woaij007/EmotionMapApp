//
//  AddEmotionViewController.m
//  EmotionMapApp
//
//  Created by wayne on 14-7-3.
//  Copyright (c) 2014年 Syracuse. All rights reserved.
//

#import "AddEmotionViewController.h"
#import "AddEmotionCell.h"
#import "MyTabBarViewController.h"
#import "CombBoxView.h"
#import "SendEmotion.h"
#import <QuartzCore/QuartzCore.h>

static NSString *cellIdentifier = @"AddEmotionCell";

@interface AddEmotionViewController ()

@property (nonatomic) int selectEmotionID;
@property (nonatomic) int selectEventID;
@property (nonatomic) int selectPlaceID;
@property (nonatomic) CGFloat lat;
@property (nonatomic) CGFloat lng;
@property (copy, nonatomic) NSString *address;

@property (nonatomic) NSInteger selectSegIndex;
@property (nonatomic) NSUInteger lastSelectedIndex;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (copy, nonatomic) NSArray *collectionImageArray;
@property (copy, nonatomic) NSArray *chooseArray;

@property (strong, nonatomic) CombBoxView *combBox;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextView *statusTextView;
@property (weak, nonatomic) IBOutlet UIButton *withFriendsButton;
@property (weak, nonatomic) IBOutlet UIButton *anonymousButton;
@property (weak, nonatomic) IBOutlet UILabel *withFriendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *anonymousLabel;
@property (weak, nonatomic) IBOutlet UILabel *switchLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

- (IBAction)backToLastView:(id)sender;
- (IBAction)sendMsg:(id)sender;
- (IBAction)segmentAction:(UISegmentedControl *)sender;
- (IBAction)switchAction:(id)sender;

@end

@implementation AddEmotionViewController

@synthesize selectEmotionID, selectEventID, selectPlaceID, lat, lng, address, selectSegIndex;

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
    
    // Set image of collectionview and combBox
    self.collectionImageArray = [NSArray arrayWithObjects:@"Alert", @"Excited", @"Elated", @"Happy",
                       @"Calm", @"Relaxed", @"Serene", @"Contented",
                       @"Tense", @"Nervous", @"Stressed", @"Upset",
                       @"Fatigued", @"Bored", @"Depressed", @"Sad", nil];
    self.chooseArray = @[@[@"Choose a location.", @"Church", @"Office", @"School", @"Store", @"Restaurant", @"Home", @"Others"],
                         @[@"Choose an activity.", @"Family", @"Work", @"Study", @"Shop", @"Eat", @"Meet", @"Others"]];
    
    // Set image of two checkBox.
    [self.withFriendsButton setImage:[UIImage imageNamed:@"checkBoxNoSelected.png"] forState:UIControlStateNormal];
    [self.withFriendsButton setImage:[UIImage imageNamed:@"checkBoxSelected.png"] forState:UIControlStateSelected];
    [self.withFriendsButton addTarget:self action:@selector(checkBoxClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.anonymousButton setImage:[UIImage imageNamed:@"checkBoxNoSelected.png"] forState:UIControlStateNormal];
    [self.anonymousButton setImage:[UIImage imageNamed:@"checkBoxSelected.png"] forState:UIControlStateSelected];
    [self.anonymousButton addTarget:self action:@selector(checkBoxClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // Set border of textView.
    self.statusTextView.layer.borderColor = [UIColor blackColor].CGColor;
    self.statusTextView.layer.borderWidth = 1;
    self.statusTextView.layer.cornerRadius = 5.0;
    
}

- (void) viewWillAppear:(BOOL)animated
{
    // Set combBox.
    [self.combBox removeFromSuperview];
    self.combBox = [[CombBoxView alloc] initWithFrame:CGRectMake(20,370, 280, 35) dataSource:self delegate:self];
    self.combBox.mSuperView = self.view;
    [self.view addSubview:self.combBox];
    
    // Get the lat and lng and address of place.
    [self findMe];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Init data to new tab

// Init collection view.
- (void)initCollectionView
{
    if ([[self.collectionView indexPathsForSelectedItems] count]) {
        NSIndexPath *indexPath = [self.collectionView indexPathsForSelectedItems][0];
        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
        AddEmotionCell *cell = (AddEmotionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        cell.emotionLabel.textColor = [UIColor blackColor];
    }
}

// Init textView
- (void)initTextView
{
    self.statusTextView.text = @"Say something...";
    self.statusTextView.textColor = [UIColor darkGrayColor];
}

// Init checkBox.
- (void)initCheckBox
{
    [self.withFriendsButton setSelected:NO];
    [self.anonymousButton setSelected:NO];
}

// Init switchButton
- (void)initSwitchButton
{
    [self.switchButton setOn:YES animated:YES];
    [self showCheckBox];
}

// Init all.
- (void)initAddEmotionView
{
    [self initCollectionView];
    [self initTextView];
    [self initCheckBox];
    [self initSwitchButton];
    [self.statusTextView resignFirstResponder];
}

#pragma mark - CollectionView Datasource Method

// Fill each cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AddEmotionCell *cell = (AddEmotionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSString *imageToLoad = @"";
    
    if (!self.segmentedControl.selectedSegmentIndex)
        imageToLoad = [NSString stringWithFormat:@"orange_%@.png", self.collectionImageArray[indexPath.row]];
    else
        imageToLoad = [NSString stringWithFormat:@"juice_%@.png", self.collectionImageArray[indexPath.row]];
    cell.emotionLabel.text = self.collectionImageArray[indexPath.row];
    cell.emotionImage.image = [UIImage imageNamed:imageToLoad];
    
    return cell;
}

#pragma mark - CollectionView Delegate Method

// Get item of each section
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  [self.collectionImageArray count];
}

// Select
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AddEmotionCell *cell = (AddEmotionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.emotionLabel.textColor = [UIColor redColor];
    
    switch (indexPath.row) {
        case 0:
            selectEmotionID = 9;
            break;
            
        case 1:
            selectEmotionID = 2;
            break;
            
        case 2:
            selectEmotionID = 15;
            break;
            
        case 3:
            selectEmotionID = 1;
            break;
            
        case 4:
            selectEmotionID = 8;
            break;
            
        case 5:
            selectEmotionID = 16;
            break;
            
        case 6:
            selectEmotionID = 11;
            break;
            
        case 7:
            selectEmotionID = 10;
            break;
            
        case 8:
            selectEmotionID = 4;
            break;
            
        case 9:
            selectEmotionID = 13;
            break;
            
        case 10:
            selectEmotionID = 5;
            break;
            
        case 11:
            selectEmotionID = 6;
            break;
            
        case 12:
            selectEmotionID = 12;
            break;
            
        case 13:
            selectEmotionID = 7;
            break;
            
        case 14:
            selectEmotionID = 14;
            break;
            
        case 15:
            selectEmotionID = 3;
            break;
            
        default:
            break;
    }
}

// Not select
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AddEmotionCell *cell = (AddEmotionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.emotionLabel.textColor = [UIColor blackColor];
}

#pragma mark - UITextView Delegate Method

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame = CGRectMake(0.0f, -215, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
    if ([textView.text isEqualToString:@"Say something..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSTimeInterval animationDuration = 0.20f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    [textView resignFirstResponder];
    
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Say something...";
        textView.textColor = [UIColor darkGrayColor];
    }
    [textView resignFirstResponder];
}

#pragma mark - combBox Delegate Method

-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index
{
}

#pragma mark - combBox DataSource Method

-(NSInteger)numberOfSections
{
    return [self.chooseArray count];
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSArray *arry = self.chooseArray[section];
    return [arry count];
}

-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
    return self.chooseArray[section][index];
}

-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    lat = newLocation.coordinate.latitude;
    lng = newLocation.coordinate.longitude;
    
    // Decode the location to get address
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error)
                   {
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       address = [NSString stringWithFormat:@"%@, %@, %@ %@", placemark.thoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode];
                   }];
    
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - All object methods

// Where am I.
- (void)findMe
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 500.0f;
    [self.locationManager startUpdatingLocation];
}

// Touch other place to end for textView.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.statusTextView isExclusiveTouch]) {
        [self.statusTextView resignFirstResponder];
    }
}

// Change button select image.
- (void)checkBoxClick: (UIButton *)btn
{
    btn.selected = !btn.selected;
}

// Hide button.
- (void)hideCheckBox
{
    self.withFriendsButton.hidden = YES;
    self.withFriendsLabel.hidden = YES;
    self.anonymousButton.hidden = YES;
    self.anonymousLabel.hidden = YES;
}

// Show button.
- (void)showCheckBox
{
    self.withFriendsButton.hidden = NO;
    self.withFriendsLabel.hidden = NO;
    self.anonymousButton.hidden = NO;
    self.anonymousLabel.hidden = NO;
}

// Hide switch.
- (void)hideSwitch
{
    self.switchButton.hidden = YES;
    self.switchLabel.hidden = YES;
}

// Show switch
- (void)showSwitch
{
    self.switchButton.hidden = NO;
    self.switchLabel.hidden = NO;
}

#pragma mark - All buttons actions methods

// Switch on and off action.
- (IBAction)switchAction:(id)sender
{
    BOOL isButtonOn = [self.switchButton isOn];
    if (isButtonOn) {
        [self showCheckBox];
    }
    else {
        [self hideCheckBox];
    }
}

// Cancel back to last view.
- (IBAction)backToLastView:(id)sender
{
    [self initAddEmotionView];
    [self.tabBarController setSelectedIndex:((MyTabBarViewController *)self.tabBarController).lastSelectedIndex];
}

// Send msg to Emotion Map Server.
- (IBAction)sendMsg:(id)sender
{
    SendEmotion *newEmotion = [[SendEmotion alloc] init];
    
    selectPlaceID = self.combBox.selectPlaceID;
    selectEventID = self.combBox.selectEventID;
    
    newEmotion.emotionID = selectEmotionID;
    newEmotion.eventID = selectEventID;
    newEmotion.placeID = selectPlaceID;
    
    newEmotion.sendText = self.statusTextView.text;
    
    BOOL isButtonOn = [self.switchButton isOn];
    if (!isButtonOn)
        newEmotion.level = 1;
    else if (isButtonOn && self.withFriendsButton.isSelected)
        newEmotion.level = 2;
    else
        newEmotion.level = 3;
    
    newEmotion.anonymousFlag = (self.anonymousButton.isSelected) ? 1 : 0;
    
    newEmotion.lat = lat;
    newEmotion.lng = lng;
    newEmotion.address = address;
    
    [newEmotion sendEmotionToServer];
    
    [self initAddEmotionView];
    [self.tabBarController setSelectedIndex:0];
}

// Do for each index.
- (IBAction)segmentAction:(UISegmentedControl *)sender {
    selectSegIndex = sender.selectedSegmentIndex;
    if (selectSegIndex == 0) {
        [self showCheckBox];
        [self showSwitch];
        self.navigationItem.rightBarButtonItem.title = @"Send";
    }
    else {
        [self hideCheckBox];
        [self hideSwitch];
        self.navigationItem.rightBarButtonItem.title = @"Throw";
    }
    
    [self.collectionView reloadData];
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

@end
