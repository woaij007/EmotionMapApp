//
//  MapViewController.m
//  EmotionMapApp
//
//  Created by wayne on 14-6-22.
//  Copyright (c) 2014年 Syracuse. All rights reserved.
//

#import "MapViewController.h"
#import "EmotionDetailViewController.h"

@interface MapViewController ()
{
    NSMutableData *allEmotions;
    NSURLConnection *connection;
    NSMutableArray *arraylat;
    NSMutableArray *arraylon;
    NSMutableArray *imageId;
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) EmotionDetailViewController *emotionDetailView;

@property (copy, nonatomic) NSArray *imageArray;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UIView *detailContainerView;

// Data for emotion detail use.
@property (nonatomic) CGFloat lat;
@property (nonatomic) CGFloat lng;

@end

@implementation MapViewController

@synthesize lat, lng;

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

    // Set the map type.
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.delegate = self;
    
    arraylat = [[NSMutableArray alloc]init];
    arraylon = [[NSMutableArray alloc]init];
    imageId = [[NSMutableArray alloc]init];
    self.mapAnnotations = [[NSMutableArray alloc]init];
    
    self.imageArray = [NSArray arrayWithObjects:@"Happy", @"Excited", @"Sad", @"Tense",
                       @"Stressed", @"Upset", @"Bored", @"Calm",
                       @"Alert", @"Contented", @"Serene", @"Fatigued",
                       @"Nervous", @"Depressed", @"Elated", @"Relaxed",
                       @"Frustrated", @"Angry", @"Scared", @"Lonely", nil];
    
    // Set container view border.
    self.detailContainerView.layer.cornerRadius = 10;
    self.detailContainerView.layer.borderColor = [UIColor clearColor].CGColor;
    
    // Assign the content of container view.
    self.emotionDetailView = [[EmotionDetailViewController alloc] init];
    self.emotionDetailView = self.childViewControllers[0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self findMe];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)findMe
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 500.0f;
    [self.locationManager startUpdatingLocation];

    self.activity.hidden = NO;
    [self.activity startAnimating];
}

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}

+ (CGFloat)calloutHeight;
{
    return 40.0f;
}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1000, 1000);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    lat = newLocation.coordinate.latitude;
    lng = newLocation.coordinate.longitude;
    
    [self.locationManager stopUpdatingLocation];
    [self getEmotionFromServer];
}

- (void)getEmotionFromServer
{
    [arraylat removeAllObjects];
    [arraylon removeAllObjects];
    [imageId removeAllObjects];
    
    NSURL *url = [NSURL URLWithString:@"https://orange.ischool.syr.edu:8443/emotionmap-android-group/control/map/mark.do?method=getRecentEmotions&parameter=%7B%20%22device%22:%22065577820acc8ef8%22,%20%22distance%22:10,%20%22idStr%22:%22100007930481901,100007430075210,12404593,100008006828530%22,%20%22lat%22:43.0997851,%20%22lng%22:-76.1837525,%20%22uid%22:1%20%7D"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if (connection)
        allEmotions = [[NSMutableData alloc]init];
}

#pragma mark - URL connection delegate method
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [allEmotions setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [allEmotions appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *allData = [NSJSONSerialization JSONObjectWithData:allEmotions options:0 error:nil];
    NSArray *data = [allData objectForKey:@"data"];
    CLLocationCoordinate2D location;
    
    MapLocation *myAnn;
    for (NSDictionary *diction in data) {
        // Data for customize annotation.
        NSString *userID = [diction objectForKey:@"userid"];
        NSString *userName = [diction objectForKey:@"username"];
        NSString *emotionId = [diction objectForKey:@"emotionid"];
        NSString *emotionDescription = [diction objectForKey:@"description"];
        NSString *hugCount = [diction objectForKey:@"hugcount"];
        NSString *commentCount = [diction objectForKey:@"contactcount"];
        NSString *address = [diction objectForKey:@"address"];
        NSString *timeStamp = [diction objectForKey:@"timeStamp"];
        NSString *latString = [diction objectForKey:@"latitude"];
        NSString *lonString = [diction objectForKey:@"longitude"];
        
        // Data for comment.
        NSString *locationID = [diction objectForKey:@"id"];
        
        location.latitude = [latString doubleValue];
        location.longitude = [lonString doubleValue];
        
        myAnn = [[MapLocation alloc]init];
        myAnn.coordinate = location;
        myAnn.userID = userID;
        myAnn.userName = userName;
        myAnn.emotionID = [emotionId intValue] -1;
        myAnn.emotionDescription = emotionDescription;
        myAnn.hugCount = [hugCount intValue];
        myAnn.commentCount = [commentCount intValue];
        myAnn.address = address;
        myAnn.timeStamp = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue] / 1000];
        
        myAnn.locationID = [locationID intValue];
        
        [arraylat addObject:latString];
        [arraylon addObject:lonString];
        [imageId addObject:emotionId];
        [self.mapAnnotations addObject:myAnn];
    }
    [self.mapView addAnnotations:self.mapAnnotations];
    
    [self.activity stopAnimating];
    self.activity.hidden = YES;
}

#pragma mark - MKMapViewAnnotationDelegate Methods
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;

    if ([annotation isKindOfClass:[MapLocation class]]) {
        static NSString* EmotionAnnotationIdentifier = @"emotionAnnotationIdentifier";
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:EmotionAnnotationIdentifier];
        if (!pinView) {
            MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:EmotionAnnotationIdentifier];
            
            customPinView.canShowCallout = NO;

            NSString *eId = imageId[0];
            [imageId removeObjectAtIndex:0];
            NSInteger myInt = [eId integerValue] - 1;
            
            NSString *imageToLoad = [NSString stringWithFormat:@"orange_%@.png", self.imageArray[myInt]];
            
            UIImage *emotionImage = [UIImage imageNamed:imageToLoad];
            
            CGRect resizeRect;
            resizeRect.size.height = 40.0f;
            resizeRect.size.width = 40.0f;
            
            resizeRect.origin = (CGPoint){0.0f, 0.0f};
            UIGraphicsBeginImageContext(resizeRect.size);
            
            [emotionImage drawInRect:resizeRect];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            customPinView.image = resizedImage;

            customPinView.opaque = NO;
            
            return customPinView;
        }
        else
            pinView.annotation = annotation;
        return pinView;
    }
    return nil;
}

// Pop the emotion detail table when select a pin.
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MapLocation *clickAnnotation = [[MapLocation alloc] init];
    clickAnnotation = (MapLocation *)(view.annotation);
    
    // Show view
    self.emotionDetailView.userID = clickAnnotation.userID;
    self.emotionDetailView.userName = clickAnnotation.userName;
    self.emotionDetailView.emotionID = clickAnnotation.emotionID;
    self.emotionDetailView.emotionDescription = clickAnnotation.emotionDescription;
    self.emotionDetailView.hugCount = clickAnnotation.hugCount;
    self.emotionDetailView.commentCount = clickAnnotation.commentCount;
    self.emotionDetailView.address = clickAnnotation.address;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy  HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:clickAnnotation.timeStamp];
    self.emotionDetailView.timeStamp = destDateString;
    
    // Send data for comment
    self.emotionDetailView.lat = lat;
    self.emotionDetailView.lng = lng;
    self.emotionDetailView.locationID = clickAnnotation.locationID;
    
    [self.emotionDetailView viewWillAppear:YES];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.detailContainerView.alpha = 0.85;
        self.detailContainerView.center = CGPointMake(160, 284);
    }];
}

// Remove the emotion detail table when touch others.
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    [UIView animateWithDuration:0.5 animations:^{
        self.detailContainerView.alpha = 1;
        self.detailContainerView.center = CGPointMake(160, 896);
    }];
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Failed to Load the Map!!!"
                          message:[error localizedDescription]
                          delegate:nil
                          cancelButtonTitle:@"Retry"
                          otherButtonTitles:nil];
    [alert show];
}

@end
