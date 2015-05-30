//
//  FavViewController.h
//  VinLoop
//
//  Created by Julien Hoachuck on 4/28/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class FavViewController;

@protocol FavViewControllerDelegate <NSObject>
-(void)favControllerDidExit:(FavViewController *)controller;
@end

@interface FavViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
    
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
    
}


// For core data stuffs
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) id <FavViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *favoriteList;
@property (strong, nonatomic) NSMutableArray *favWineList;

-(void)exitControllerButton;
-(void)deleteWineryDeals;

@end
