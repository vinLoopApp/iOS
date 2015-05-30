//
//  FiltersViewController.h
//  VinLoop
//
//  Created by Julien Hoachuck on 4/22/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APLSectionHeaderView.h"
@class FiltersViewController;

@protocol FiltersViewControllerDelegate <NSObject>
-(void)filtersControllerDidCancel:(FiltersViewController *)controller;
-(void)filtersControllerDidSearch:(FiltersViewController *)controller;
@end

@interface FiltersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SectionHeaderViewDelegate>

@property (nonatomic, weak) id <FiltersViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *distanceArray;
@property (nonatomic, strong) NSMutableArray *varietalArray;
@property (nonatomic, strong) NSMutableArray *sortbyArray;
@property (nonatomic, strong) NSMutableArray *filterOptions;

@property (assign, nonatomic) NSInteger currentDistanceSelection;
@property (assign, nonatomic) NSInteger currentVarietalSelection;
@property (assign, nonatomic) NSInteger currentSortBySelection;
-(void)cancelController;
-(void) searchControllerButton;



@end
