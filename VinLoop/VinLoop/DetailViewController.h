//
//  DetailViewController.h
//  VinLoop
//
//  Created by Julien Hoachuck on 4/15/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UIImageView+WebCache.h"
#import "DealItem.h"
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
@interface DetailViewController : UIViewController <MKMapViewDelegate, NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
    
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) DealItem *deal;
@property (nonatomic, strong) CLLocation *currentLocation;

- (IBAction)addToFavorites:(id)sender;

@end
