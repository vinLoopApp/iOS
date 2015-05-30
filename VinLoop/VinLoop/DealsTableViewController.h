//
//  DealsTableViewController.h
//  VinLoop
//
//  Created by Julien Hoachuck on 3/27/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DealsHTTPClient.h"
#import "FiltersViewController.h"
#import "ProfileViewController.h"
#import "FavViewController.h"
#import <CoreData/CoreData.h>

@interface DealsTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, ProfileViewControllerDelegate, FavViewControllerDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, DealsHTTPClientDelegate, NSFetchedResultsControllerDelegate>
{
    
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
    
}

// For core data stuffs
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


@property (nonatomic, weak) IBOutlet UITableView *dealsTableView;
@property (nonatomic, weak) IBOutlet UIView *sView;
@property (nonatomic, weak) IBOutlet UIView *sfView;

// Location Delegate Properties
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

// SearchBar Delegate properties
@property (nonatomic, strong) UISearchController *searchController;

// For state restoration
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

- (IBAction)showFilters:(id)sender;

+ (UIImage*) imageWithColor:(UIColor*)color andHeight:(CGFloat)height;

@end
