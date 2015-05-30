//
//  DealsTableViewController.m
//  VinLoop
//
//  Created by Julien Hoachuck on 3/27/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0] // Used for color

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#import "UIImageView+WebCache.h"
#import "DealsTableViewController.h"
#import "DealItemCell.h"
#import "DealItem.h"
#import "DetailViewController.h"
#import "FiltersViewController.h"
#import "FavViewController.h"
#import "ProfileViewController.h"
#import "VLSearchController.h"
#import "VLSearchBar.h"

@interface DealsTableViewController ()
@property (nonatomic, strong) NSURLSession *session;
@property (strong, nonatomic) NSMutableArray *deals;
@property (strong, nonatomic) NSMutableDictionary *wineryToDeals;
@property (nonatomic, copy) NSMutableDictionary *distance;
@property (nonatomic, strong) NSMutableArray *filteredDeals;



@end

@implementation DealsTableViewController

@synthesize filteredDeals;
@synthesize fetchedResultsController, managedObjectContext;
@synthesize distance, wineryToDeals;


// ---------------- View Code ----------------//

-(instancetype) init
{
    self = [super init];

    

    if(self)
    {
        
        // Init. config. and session
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
        
        // Background image
       [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navback.png"] forBarMetrics:UIBarMetricsDefault];
  
        
        // Buttons on right
        UIBarButtonItem *profileItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"profile.png" ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(showSettings)];
        
        UIBarButtonItem *heartItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"heart.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(showFavorites)];
        
        NSArray *actionButtonItems = @[profileItem, heartItem];
        self.navigationItem.rightBarButtonItems = actionButtonItems;
    
        
        // Logo on lefts
        UIBarButtonItem *logo = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]]];
        self.navigationItem.leftBarButtonItem = logo;

    }// Navigation Bar Initialization
    

    NSLog(@"INIT");
    return self;
}

-(void) viewDidLoad
{
    
    NSLog(@"ViewDidLoad");
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.dealsTableView.delegate = self;
    self.dealsTableView.dataSource = self;
    
    //// Search & Results Stuff
    _searchController = [[VLSearchController alloc] initWithSearchResultsController:nil]; // changed from self.resultsTableController
    self.searchController.searchResultsUpdater = self;

    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.barTintColor = [UIColor clearColor];
    self.searchController.searchBar.backgroundImage = [UIImage new];
    
    // Adding searchbar as subview of sfview
    [self.sView addSubview:self.searchController.searchBar];
    [self.sfView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"searchback.png"]]];
    
    //self.resultsTableController.tableView.dataSource = self;
    self.searchController.delegate  = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;
    self.searchController.searchBar.placeholder = @"Search by Wineries or Location                 ";
    
    // Allocating data structures to hold deals, wineryToDeals for Favoritelist
    self.deals = [NSMutableArray array]; // Original Deals array
    self.wineryToDeals = [[NSMutableDictionary alloc] init]; // Dictionary containing all the wineries to deals
    
    // Custom cell initialization
    UINib *nib = [UINib nibWithNibName:@"DealItemCell" bundle:nil];
    [self.dealsTableView registerNib:nib forCellReuseIdentifier:@"DealItemCell"];
    
    // Location manager initialization
    [self.locationManager requestWhenInUseAuthorization]; // Needed for being able to update location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        if(IS_OS_8_OR_LATER) {
            [self.locationManager requestAlwaysAuthorization];
        }
    }
    
    [self.locationManager startUpdatingLocation];
    
    // Loading deals into  deals array (self.deals)
    DealsHTTPClient *client = [DealsHTTPClient sharedDealsHTTPClient];
    client.delegate = self;
    [client updateDeals]; // updates the self.deals array
    
    filteredDeals = _deals; // Used as a place holder for filtering and searching
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // restore the searchController's active state
    if (self.searchControllerWasActive) {
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self calculateDistances]; // Update deals with distances
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

-(void)viewWillLayoutSubviews
{
    self.searchController.searchBar.frame = CGRectMake(0, 0, self.sView.bounds.size.width, 44);
}

-(void)showFavorites
{
    NSLog(@"----------- Show Favorites -----------");
    FavViewController *addFavController = [[FavViewController alloc] init];
    addFavController.delegate = self;
    addFavController.managedObjectContext=self.managedObjectContext;
    
    // Change this to be a FACTORY store for a favorite list.
    addFavController.favoriteList = [[NSMutableArray alloc] init];
    // Fetch Results
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorites" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    } else {
        NSLog(@"Here are the results\n %@", result);
    }
    
    // For each of the items retrieved for core data add the object to the favoriteList
    for(NSManagedObject *aResult in result)
    {
        // Adding deals to the favorite controller list
        [addFavController.favoriteList addObject:[self.wineryToDeals valueForKey:[aResult valueForKey:@"winery"]]];
        
        //Add to the winery name array for the favorite controller
        [addFavController.favWineList addObject:[aResult valueForKey:@"winery"]];
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addFavController];
    [self presentViewController:navigationController animated:YES completion:nil];
    
} // Favorites Button Event Function

-(void)showSettings
{
    ProfileViewController *addProfileController = [[ProfileViewController alloc] init];
    addProfileController.delegate = self;
    
    // Get info from core data
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Profile" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    }
    
    
    if([result count]  > 0)
    {
        NSManagedObject *profile = (NSManagedObject *)[result objectAtIndex:0];
        addProfileController.fName = [profile valueForKey:@"firstName"];
        addProfileController.lName = [profile valueForKey:@"lastName"];

    }

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addProfileController];
    [self presentViewController:navigationController animated:YES completion:nil];
    
} // Settings Button Event Function

- (IBAction)showFilters:(id)sender;
{
    FiltersViewController *addFiltersController = [[FiltersViewController alloc] init];
    addFiltersController.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addFiltersController];
    [self presentViewController:navigationController animated:YES completion:nil];
    
} // Filter Button Event Action

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
} // Memory Warning Stuff



// ---------------- End View Code ----------------//



// ---------------- Filters Delegate Code ----------------//


#pragma mark - FiltersControllerDelegate
- (void)filtersControllerDidCancel:(FiltersViewController *)controller
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)filtersControllerDidSearch:(FiltersViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"-------- Filter Search Pressed --------");
    NSArray *filtered = self.deals;
    
    // -------- Filter by Distance --------
    for(NSMutableDictionary *dict in controller.distanceArray)
    {
        NSLog(@"Potential Check: %@ with check = %@", [dict objectForKey:@"data"], [dict objectForKey:@"check"]);
        if([[dict objectForKey:@"check"] isEqualToString:@"1"])
        {
            NSLog(@"Less than distance: %@ and checked",[dict objectForKey:@"data"]);
            NSPredicate *tempPred = [NSPredicate predicateWithFormat:@"dist < %@",[dict objectForKey:@"data"]]; //figure out
            filtered = [filtered filteredArrayUsingPredicate:tempPred];
            break;
        }
    }
    
    // -------- Filter by Varietal --------
    for(NSMutableDictionary *dict in controller.varietalArray)
    {
        if([[dict objectForKey:@"check"] isEqualToString:@"1"])
        {
            NSLog(@"Are there any %@ ?",[dict objectForKey:@"data"]);
            NSPredicate *tempPred = [NSPredicate predicateWithFormat:@"varietal CONTAINS[cd] %@",[dict objectForKey:@"data"]];
            filtered = [filtered filteredArrayUsingPredicate:tempPred];
        }
    }

    self.filteredDeals = [filtered mutableCopy]; // copy over the filtered deals to the array the tableview uses
    

    // Sort by Distance
    if([[controller.sortbyArray[0] valueForKey:@"check"] isEqualToString:@"1"])
    {
        NSSortDescriptor *distSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dist" ascending:YES];
        [self.filteredDeals sortUsingDescriptors:[NSArray arrayWithObject:distSortDescriptor]];
    }
    else if([[controller.sortbyArray[1] valueForKey:@"check"] isEqualToString:@"1"]) // Sort by Gets
    {
        NSSortDescriptor *getSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"gets" ascending:YES];
        [self.filteredDeals sortUsingDescriptors:[NSArray arrayWithObject:getSortDescriptor]];
    }
    
    [self.dealsTableView reloadData];
}

// ---------------- End Filters Delegate Code ----------------//

// ---------------- Profile Delegate Code ----------------//

#pragma mark - ProfileControllerDelegate
- (void)profileControllerDidCancel:(ProfileViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)profileControllerDidSave:(ProfileViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Save the profile information to core data
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Profile" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    } else {
        NSLog(@"%@", result);
    }
    
    if([result count] > 0)
    {
        NSManagedObject *profile = (NSManagedObject *)[result objectAtIndex:0];
    
        [profile setValue:controller.firstName.text forKey:@"firstName"];
        [profile setValue:controller.lastName.text forKey:@"lastName"];
    
        NSError *saveError = nil;
    
        if (![profile.managedObjectContext save:&saveError])
        {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", saveError, saveError.localizedDescription);
        }
    } else
    {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Profile" inManagedObjectContext:self.managedObjectContext];
        
        NSManagedObject *newProfile = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
        
        [newProfile setValue:controller.firstName.text forKey:@"firstName"];
        [newProfile setValue:controller.lastName.text forKey:@"lastName"];
        // Need to add other proeprties
        
        NSError *error = nil;
        
        if (![newProfile.managedObjectContext save:&error])
        {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }
    NSLog(@"Here is where it should be");
    
}

// ---------------- End Profile Delegate Code ----------------//

// ---------------- Favorites Delegate Code ----------------//


#pragma mark - FiltersControllerDelegate
- (void)favControllerDidExit:(FavViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


// ---------------- End Profile Delegate Code ----------------//


// ---------------- TableView Delegate Code ----------------//

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 325;
}

// Using header as spacing between rows (which are actually whole sections)

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:UIColorFromRGB(0xdddddd)];
    return v;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self calculateDistances];
    return [filteredDeals count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    DealItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealItemCell" forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[DealItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DealItemCell"];
    }
    
    // Get array of items
    if(cell != nil)
    {
    
        DealItem *item = filteredDeals[indexPath.section];
        
        UIFont *myriadFont = [UIFont fontWithName:@"Helvetica-Light" size:15];
        // Configure the cell with PDItem
        
        // Description (title) Label
        NSMutableAttributedString *attrText = [cell.dealLabelDesc.attributedText mutableCopy];
        [attrText replaceCharactersInRange:NSMakeRange(0, [attrText.string length])
                                            withString:item.title];
        cell.dealLabelDesc.attributedText = attrText;
        //[cell.dealLabelDesc sizeToFit];
        
        
        // Which Winery Label
        NSMutableAttributedString *attrTextDesc = [cell.dealLabelWine.attributedText mutableCopy];
        [attrTextDesc replaceCharactersInRange:NSMakeRange(0, [attrTextDesc.string length])
                                    withString:[[NSString alloc] initWithFormat:@"%@ \u2022 %.1f mi.",item.name, [item.dist floatValue]]];
        [attrTextDesc addAttributes:@{NSFontAttributeName:myriadFont, NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, [attrTextDesc length])];
        cell.dealLabelWine.attributedText = attrTextDesc;
        
        // Old price strike out
        NSMutableAttributedString *attrDisPrice = [cell.disPrice.attributedText mutableCopy];
        [attrDisPrice replaceCharactersInRange:NSMakeRange(0, [attrDisPrice.string length])
                                    withString:[[NSString alloc] initWithFormat:@"$%@", item.origprice]];
        [attrDisPrice addAttribute:NSStrikethroughStyleAttributeName
                             value:@2 range:NSMakeRange(0, [attrDisPrice length])];
        cell.disPrice.attributedText=attrDisPrice;
        
        
        cell.getsLabel.text = [[NSString alloc] initWithFormat:@"%@+ Gets",item.gets];
        //cell.oldPrice.text = [[NSString alloc] initWithFormat:@"$%@",item.origprice];
        cell.disPrice.text = [[NSString alloc] initWithFormat:@"$%@", item.price];
        
        
        NSMutableAttributedString *attrTextWalk = [cell.byWalkorApp.attributedText mutableCopy];
        
        if([item.bywalk isEqual:@1])
        {
            [attrTextWalk replaceCharactersInRange:NSMakeRange(0, [attrTextWalk.string length])
                                        withString:@"By Walkin"];
            [attrTextWalk addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,[attrTextWalk length])];
            cell.byWalkorApp.attributedText = attrTextWalk;
        }
        else
        {
            [attrTextWalk replaceCharactersInRange:NSMakeRange(0, [attrTextWalk.string length])
                                        withString:@"By Appt."];
            //[attrTextWalk addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,[attrTextWalk length])];
           
            [attrTextWalk addAttributes:@{NSFontAttributeName:myriadFont, NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, [attrTextWalk length])];
            cell.byWalkorApp.attributedText = attrTextWalk;
        }

        // Use SDWebImageManager to get the picture
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:item.imageURL]
                         options:0
                        progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            
                        }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)  {
                           /**
                            We can do this because the block "captures" the
                            necessary variables in its context for reference
                            when it starts execution.
                            **/
                            NSArray *visibleIndexPaths = [tableView indexPathsForVisibleRows];
                            if ([visibleIndexPaths containsObject:indexPath]) {
                                cell.thumbnailView.image = [UIImage imageNamed:@"example.png"];//image;
                           }
                       }];
        
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DealItem *selectedDeal = self.deals[indexPath.section];
    
    // Passing off information to the detailView
    DetailViewController *detailContr = [[DetailViewController alloc] init];
    detailContr.deal = selectedDeal; // hand off the current product to the detail view controller
    detailContr.currentLocation = self.currentLocation;
    
    // To access core data to push favorite items
    detailContr.managedObjectContext = self.managedObjectContext; // pass down managedObjectcontext for core access
    
    [self.navigationController pushViewController:detailContr animated:YES];
    
    // note: should not be necessary but current iOS 8.0 bug (seed 4) requires it
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


// ---------------- End TableView Delegate Code ----------------//


// ---------------- CLLocationManager Delegate Code ----------------//

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // Last object contains the most recent location
    CLLocation *newLocation = [locations lastObject];
    
    // If the location is more than 5 mintues old, ignore it Change to distance
   // if([newLocation.timestamp timeIntervalSinceNow] > 300)
    //    return;
    
    self.currentLocation = newLocation;
    [self.locationManager stopUpdatingLocation];
}
// ---------------- End CLLocationManager Delegate Code ----------------//

// ---------------- DealsHTTPClient Delegate ----------------//

- (void) DealsHTTPClient:(DealsHTTPClient *)client didUpdateWithDeals:(id)deals
{
    [self convertDeals:deals]; // loads the deals array
    [self.dealsTableView reloadData];
}

- (void)DealsHTTPClient:(DealsHTTPClient *)client didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Deals" message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

// ---------------- End DealsHTTPClient Delegate ----------------//


// ---------------- UISearchController Delegate Code ----------------//

#pragma mark - UISearchController
- (void)willPresentSearchController:(UISearchController *)searchController {
    self.searchController.hidesNavigationBarDuringPresentation = false; // stop from animating
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.searchController.searchBar.showsCancelButton = false;
}

- (void)didDismissSearchController:(UISearchController *)searchController{
    filteredDeals=_deals; // Make sure to reload the deals with before the search
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    // update the filtered array based on the search text
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResults = [self.deals mutableCopy];
    
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    // build all the "AND" expressions for each value in the searchString
    //
    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    
    for (NSString *searchString in searchItems) {
        // each searchString creates an OR predicate for: name, yearIntroduced, introPrice
        //
        // example if searchItems contains "iphone 599 2007":
        //      name CONTAINS[c] "iphone"
        //      name CONTAINS[c] "599", yearIntroduced ==[c] 599, introPrice ==[c] 599
        //      name CONTAINS[c] "2007", yearIntroduced ==[c] 2007, introPrice ==[c] 2007
        //
        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
        
        // Below we use NSExpression represent expressions in our predicates.
        // NSPredicate is made up of smaller, atomic parts: two NSExpressions (a left-hand value and a right-hand value)
        
        // name field matching
        NSExpression *lhs = [NSExpression expressionForKeyPath:@"name"];
        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        
        [searchItemsPredicate addObject:finalPredicate];
        
        NSExpression *lhs2 = [NSExpression expressionForKeyPath:@"title"];
        NSExpression *rhs2 = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *finalPredicate2 = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs2
                                       rightExpression:rhs2
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        
        [searchItemsPredicate addObject:finalPredicate2];
         /*
        // yearIntroduced field matching
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
        NSNumber *targetNumber = [numberFormatter numberFromString:searchString];
        if (targetNumber != nil) {   // searchString may not convert to a number
            lhs = [NSExpression expressionForKeyPath:@"dealWinery"];
            rhs = [NSExpression expressionForConstantValue:targetNumber];
            finalPredicate = [NSComparisonPredicate
                              predicateWithLeftExpression:lhs
                              rightExpression:rhs
                              modifier:NSDirectPredicateModifier
                              type:NSEqualToPredicateOperatorType
                              options:NSCaseInsensitivePredicateOption];
            [searchItemsPredicate addObject:finalPredicate];
          
            // price field matching
            lhs = [NSExpression expressionForKeyPath:@""];
            rhs = [NSExpression expressionForConstantValue:targetNumber];
            finalPredicate = [NSComparisonPredicate
                              predicateWithLeftExpression:lhs
                              rightExpression:rhs
                              modifier:NSDirectPredicateModifier
                              type:NSEqualToPredicateOperatorType
                              options:NSCaseInsensitivePredicateOption];
            [searchItemsPredicate addObject:finalPredicate];
        */
        
        
        // at this OR predicate to our master AND predicate
        NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
        [andMatchPredicates addObject:orMatchPredicates];
    }
    
    // match up the fields of the Product object
    NSCompoundPredicate *finalCompoundPredicate =
    [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];

    // Set the resultant array of search results to the tableView data source: self.filteredDeals
    self.filteredDeals = searchResults;

    [self.dealsTableView reloadData];
}

// ---------------- End UISearchController Delegate Code ----------------//

// ---------------- UIStateRestoration Delegate Code ----------------//

#pragma mark - UIStateRestoration

// we restore several items for state restoration:
//  1) Search controller's active state,
//  2) search text,
//  3) first responder

NSString *const ViewControllerTitleKey = @"ViewControllerTitleKey";
NSString *const SearchControllerIsActiveKey = @"SearchControllerIsActiveKey";
NSString *const SearchBarTextKey = @"SearchBarTextKey";
NSString *const SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    // encode the view state so it can be restored later
    
    // encode the title
    [coder encodeObject:self.title forKey:ViewControllerTitleKey];
    
    UISearchController *searchController = self.searchController;
    
    // encode the search controller's active state
    BOOL searchDisplayControllerIsActive = searchController.isActive;
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchControllerIsActiveKey];
    
    // encode the first responser status
    if (searchDisplayControllerIsActive) {
        [coder encodeBool:[searchController.searchBar isFirstResponder] forKey:SearchBarIsFirstResponderKey];
    }
    
    // encode the search bar text
    [coder encodeObject:searchController.searchBar.text forKey:SearchBarTextKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the title
    self.title = [coder decodeObjectForKey:ViewControllerTitleKey];
    
    // restore the active state:
    // we can't make the searchController active here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerWasActive = [coder decodeBoolForKey:SearchControllerIsActiveKey];
    
    // restore the first responder status:
    // we can't make the searchController first responder here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
    
    // restore the text in the search field
    self.searchController.searchBar.text = [coder decodeObjectForKey:SearchBarTextKey];
}

// ---------------- End UIStateRestoration Delegate Code ----------------//


// ---------------- Extra Needed Functions ----------------//


-(void) convertDeals:(NSArray *) deals
{
    DealItem *sample;
    
    for(NSMutableDictionary *item in deals)
    {
        sample = [[DealItem alloc ]initWithTitle:item[@"title"]
                                      wineryName:item[@"name"]
                                        dealGets:item[@"gets"]
                                       wineryLat:item[@"latitude"]
                                       wineryLng:item[@"longitude"]
                                      dealByAppt:item[@"byappt"]
                                      dealByWalk:item[@"bywalk"]
                                    dealVarietal:item[@"varietal"]
                                       dealPrice:item[@"price"]
                                   dealOrigPrice:item[@"origprice"]
                                        dealDesc:item[@"description"]
                                       dealImage:item[@"imgURL"]];
        

        [self.wineryToDeals setObject:sample forKey:sample.name];
        [self.deals addObject:sample];
        
    }

} // Convert Deals Fucntion

-(void) calculateDistances
{
    NSLog(@"----------- Calculating Distances ------------");
    NSLog(@"Count of the deals array: %lu", (unsigned long)[self.deals count]);
    CLLocationCoordinate2D coord;
    for(DealItem *deal in self.filteredDeals)
    {
        coord.longitude = (CLLocationDegrees)[deal.lng doubleValue];
        coord.latitude = (CLLocationDegrees)[deal.lat doubleValue];
        CLLocation *wineryLoc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        CLLocationDistance meters = [wineryLoc distanceFromLocation:self.currentLocation];
        [self.distance setObject:[NSNumber numberWithDouble:meters] forKey:deal.name];
        deal.dist=[NSNumber numberWithDouble:(meters/1609.344)];
    }
}

+ (UIImage*) imageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
