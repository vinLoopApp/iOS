//
//  DetailViewController.m
//  VinLoop
//
//  Created by Julien Hoachuck on 4/15/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import "DetailViewController.h"
#import "SWRevealViewController.h"

#import <MapKit/MapKit.h>

@interface DetailViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImage;
@property (weak, nonatomic) IBOutlet UILabel *dealDetail;
@property (weak, nonatomic) IBOutlet UILabel *dealWinery;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *origPrice;
@property (weak, nonatomic) IBOutlet UILabel *disPrice;
@property (weak, nonatomic) IBOutlet UIToolbar *theToolBar;

@property (strong, nonatomic) MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailMap;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;




@end

@implementation DetailViewController

@synthesize fetchedResultsController, managedObjectContext;

- (IBAction)addToFavorites:(id)sender
{
    NSError *error = nil;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Favorites" inManagedObjectContext:self.managedObjectContext];
        
    NSManagedObject *newFavorite = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
        
    [newFavorite setValue:self.deal.name forKey:@"winery"];
        
    if (![newFavorite.managedObjectContext save:&error])
    {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
    }
} // If deal added to favorites then save the winery to core data

-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    
    // Transparent tool bar
    [self.theToolBar setBackgroundImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [self.theToolBar setShadowImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny];
    NSLog(@"Detail View did load!!! --------");
    SWRevealViewController *revealController = [self revealViewController];
    revealController.panGestureRecognizer.enabled = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Picture for Deal
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:self.deal.imageURL]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)  {
                            /**
                             We can do this because the block "captures" the
                             necessary variables in its context for reference
                             when it starts execution.
                             **/

                            self.thumbnailImage.image= image;
                            
                        }];
    
    // ------ Information in Detail Section ---------
    
    // Deal Title (desc)
    NSMutableAttributedString *attrText = [self.dealDetail.attributedText mutableCopy];
    [attrText replaceCharactersInRange:NSMakeRange(0, [attrText.string length])
                            withString:self.deal.title];
    self.dealDetail.attributedText = attrText;
    
    // Winery Name
    self.dealWinery.text = self.deal.name;
    
    // Original Price Cross out
    NSMutableAttributedString *atrOldPriceString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%@", self.deal.origprice]];
    [atrOldPriceString addAttribute:NSStrikethroughStyleAttributeName
                              value:@2
                              range:NSMakeRange(0, [atrOldPriceString length])];
    self.origPrice.attributedText = atrOldPriceString;
    
    
    //self.origPrice.text = [NSString stringWithFormat:@"$%@", self.deal.origprice];
    self.disPrice.text = [NSString stringWithFormat:@"$%@", self.deal.price];
    self.likesLabel.text = [NSString stringWithFormat:@"%@+",self.deal.gets];
    
    // Map Screenshot
    
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    self.mapView = [[MKMapView alloc] init];
    [self.mapView setPitchEnabled:NO];
    float spanX = 0.00725;
    float spanY = 0.00725;
    
    //Create annotation
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D pinCoordinate;
    pinCoordinate.latitude = self.currentLocation.coordinate.latitude;
    pinCoordinate.longitude = self.currentLocation.coordinate.longitude;
    
    annotation.coordinate = CLLocationCoordinate2DMake(self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
    annotation.title = @"VinLoop Location";
    annotation.subtitle = @"Best Wine Deal";
    
    [self.mapView addAnnotation:annotation];
    
    MKCoordinateRegion region;
    region.center.latitude = self.currentLocation.coordinate.latitude;
    region.center.longitude = self.currentLocation.coordinate.longitude;
    
    
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    
    options.region = region;
    options.size = self.thumbnailMap.frame.size;
    options.scale = [[UIScreen mainScreen] scale];
    options.showsPointsOfInterest = YES;
    


    
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        if (error) {
            NSLog(@"[Error] %@", error);
            return;
        }
        
        UIImage *image = snapshot.image;
        
        MKAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:nil];
        UIGraphicsBeginImageContextWithOptions(image.size, YES, image.scale);
        {
            [image drawAtPoint:CGPointMake(0.0f, 0.0f)];
            
            CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
            for (id <MKAnnotation> annotation in self.mapView.annotations) {
                CGPoint point = [snapshot pointForCoordinate:annotation.coordinate];
                if (CGRectContainsPoint(rect, point)) {
                    point.x = point.x + pin.centerOffset.x -
                    (pin.bounds.size.width / 2.0f);
                    point.y = point.y + pin.centerOffset.y -
                    (pin.bounds.size.height / 2.0f);
                    [pin.image drawAtPoint:point];
                }
            }
            
            UIImage *compositeImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        
            self.thumbnailMap.image = compositeImage;

        }
        

    }];
    
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    SWRevealViewController *revealController = [self revealViewController];
    revealController.panGestureRecognizer.enabled = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ---------------- MKMapViewDelegate Delegate Code  ----------------//

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[_mapView regionThatFits:region] animated:YES];

}




@end
