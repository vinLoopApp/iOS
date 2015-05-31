//
//  FavViewController.m
//  VinLoop
//
//  Created by Julien Hoachuck on 4/28/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import "FavViewController.h"
#import "DealItemCell.h"
#import "DealItem.h"
#import "UIImageView+WebCache.h"
#import "SWRevealViewController.h"

@interface FavViewController ()
@end

@implementation FavViewController

@synthesize delegate;
@synthesize fetchedResultsController, managedObjectContext;

-(instancetype)init
{
    self =[super init];
    self.favWineList = [NSMutableArray array];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Custom cell initialization
    UINib *nib = [UINib nibWithNibName:@"DealItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"DealItemCell"];
    
    
    UIBarButtonItem *exitItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(exitControllerButton)];
    [exitItem setTintColor:[UIColor whiteColor]];
    /*
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchControllerButton)];
    [searchItem setTintColor:[UIColor whiteColor]];
    
    */
    self.navigationItem.leftBarButtonItem=exitItem;
    //self.navigationItem.rightBarButtonItem=searchItem;
    UIBarButtonItem *removeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteWineryDeals)];
    [exitItem setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem=removeItem;
    SWRevealViewController *revealController = [self revealViewController];
    revealController.panGestureRecognizer.enabled = NO;
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    SWRevealViewController *revealController = [self revealViewController];
    revealController.panGestureRecognizer.enabled = YES;
}

-(void)exitControllerButton
{
    [self.favoriteList removeAllObjects];
    [delegate favControllerDidExit:self];

}

-(void)deleteWineryDeals
{
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Remove Deals From Winery"
                                 message:@"Select a winery to remove."
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    for(NSString *wineryName in self.favWineList)
    {
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:wineryName
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                                 
                                 NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorites" inManagedObjectContext:self.managedObjectContext];
                                 [fetchRequest setEntity:entity];
                                 
                                 NSError *error = nil;
                                 NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                                 
                                 if (error) {
                                     NSLog(@"Unable to execute fetch request.");
                                     NSLog(@"%@, %@", error, error.localizedDescription);
                                     
                                 } else {
                                     NSLog(@"%@", result);
                                 }
                                 
                                for(NSManagedObject *wineryCell in result)
                                 {
                                     
                                     if([[wineryCell valueForKey:@"winery"] isEqualToString:action.title])
                                     {
                                         [self.managedObjectContext deleteObject:wineryCell];
                                         NSError *deleteError = nil;
                                         
                                         if (![wineryCell.managedObjectContext save:&deleteError]) {
                                             NSLog(@"Unable to save managed object context.");
                                             NSLog(@"%@, %@", deleteError, deleteError.localizedDescription);
                                         }
                                     }
                                 }
                                 

                                 NSMutableArray *rowsToDelete = [NSMutableArray array];
                                 DealItem *aDeal;
                                 for(int i = 0; i < [self.favoriteList count]; i++)
                                 {
                                     aDeal = self.favoriteList[i];
                                     if([aDeal.name isEqualToString:action.title])
                                     {
                                         NSLog(@"Winery Name: %@ at index: %d",aDeal.name, i);
                                         [self.favoriteList removeObjectAtIndex:i];
                                         NSIndexPath *myIP = [NSIndexPath indexPathForRow:i inSection:0];
                                         [rowsToDelete addObject:myIP];
                                     }
                                 }
                                 
                                 for(int i = 0; i < [self.favWineList count]; i++)
                                 {
                                     if([self.favWineList[i] isEqualToString:action.title])
                                         [self.favWineList removeObjectAtIndex:i];
                                 }
                                 
                                 [self.tableView deleteRowsAtIndexPaths:rowsToDelete withRowAnimation:UITableViewRowAnimationFade];
                                 
                                 //[self.tableView reloadData];
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                                 
                             }];
        
        
        
        [view addAction:ok];
    }
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    

    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
    //[self.tableView reloadData];
    NSLog(@"After it disappears?");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// ---------------- TableView Delegate Code ----------------//

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 325;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_favoriteList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    DealItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealItemCell" forIndexPath:indexPath];
    
    // Get array of items
    if(cell != nil)
    {
        
        DealItem *item = _favoriteList[indexPath.row];
        
        
        // Configure the cell with PDItem
        
        cell.dealLabelDesc.text = item.title;
        cell.dealLabelWine.text = item.name;
        //cell.likesLabel.text = [NSString stringWithFormat:@"%d", item.likes];
        //cell.disPrice.text = [NSString stringWithFormat:@"%d", item.disPrice];
        //cell.origPrice.text = item.origPrice;
        
        // Use SDWebImageManager to get the picture
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:item.imageURL]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)  {
     
                                NSArray *visibleIndexPaths = [tableView indexPathsForVisibleRows];
                                if ([visibleIndexPaths containsObject:indexPath]) {
                                    cell.thumbnailView.image = image;
                                }
                                
                            }];
        
    }
    
    
    return cell;
}

/*

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DealItem *selectedDeal = (tableView == self.tableView) ?
    self.deals[indexPath.section] : self.resultsTableController.filteredDeals[indexPath.row];
    
    DetailViewController *detailContr = [[DetailViewController alloc] init];
    detailContr.deal = selectedDeal; // hand off the current product to the detail view controller
    detailContr.currentLocation = self.currentLocation;
    
    
    [self.navigationController pushViewController:detailContr animated:YES];
    
    // note: should not be necessary but current iOS 8.0 bug (seed 4) requires it
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
 */
@end
