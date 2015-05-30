//
//  AppDelegate.h
//  VinLoop
//
//  Created by Julien Hoachuck on 3/27/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLTSViewController.h"
#import <CoreData/CoreData.h>

@interface VinLoopDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;



- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end



