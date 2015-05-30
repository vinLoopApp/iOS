//
//  FiltersViewController.m
//  VinLoop
//
//  Created by Julien Hoachuck on 4/22/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//


#import "FiltersViewController.h"
#import "APLSectionInfo.h"
#import "APLSectionHeaderView.h"
#import "WineTypeCell.h"


#define DEFAULT_ROW_HEIGHT 30
#define HEADER_HEIGHT 34
static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

@interface FiltersViewController ()

// Tables
@property (nonatomic, weak) IBOutlet UITableView *distanceTable;
@property (nonatomic, weak) IBOutlet UITableView *WineTypeTable;

@property (nonatomic, weak) IBOutlet UIButton *oneDollar;
@property (nonatomic, weak) IBOutlet UIButton *twoDollar;
@property (nonatomic, weak) IBOutlet UIButton *threeDollar;
@property (nonatomic, weak) IBOutlet UIButton *fourDollar;

@property (nonatomic, weak) IBOutlet UISwitch *redSwitch;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;


// Section Index Stuff
@property (nonatomic) NSMutableArray *sectionInfoArray;
@property (nonatomic) NSInteger openSectionIndex;
@property (nonatomic) IBOutlet APLSectionHeaderView *sectionHeaderView;


@end

@implementation FiltersViewController
@synthesize delegate;
@synthesize distanceTable, WineTypeTable;


-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0];
    [self.view addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:0];
    [self.view addConstraint:rightConstraint];
    
    
    //
    self.distanceTable.delegate=self;
    self.distanceTable.dataSource=self;
    
    self.WineTypeTable.delegate = self;
    self.WineTypeTable.dataSource=self;
    
    // Turn off scrolling
    self.distanceTable.scrollEnabled = NO;
    self.WineTypeTable.scrollEnabled=NO;
    
    // Create array of dictionary items for one tableView
    self.distanceArray = [[NSMutableArray alloc] init];
    self.varietalArray = [[NSMutableArray alloc] init];
    self.sortbyArray = [[NSMutableArray alloc] init];

    
    // distance
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict3 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict4 = [[NSMutableDictionary alloc] init];
        
    [dict1 setObject:[NSNumber numberWithInt:1] forKey:@"data"];
    [dict2 setObject:[NSNumber numberWithInt:5] forKey:@"data"];
    [dict3 setObject:[NSNumber numberWithInt:10] forKey:@"data"];
    [dict4 setObject:[NSNumber numberWithInt:34] forKey:@"data"];
    
    [dict1 setObject:@"0" forKey:@"check"];
    [dict2 setObject:@"0" forKey:@"check"];
    [dict3 setObject:@"0" forKey:@"check"];
    [dict4 setObject:@"0" forKey:@"check"];
    
    [self.distanceArray addObject:dict1];
    [self.distanceArray addObject:dict2];
    [self.distanceArray addObject:dict3];
    [self.distanceArray addObject:dict4];
    
    // varietal
    
    NSMutableDictionary *dict5 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict6 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict7 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict8 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict9 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict10 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict11 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict12 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict13 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict14 = [[NSMutableDictionary alloc] init];
    
    [dict5 setObject:[NSString stringWithFormat:@"CBS"] forKey:@"data"];
    [dict6 setObject:[NSString stringWithFormat:@"ME"] forKey:@"data"];
    [dict7 setObject:[NSString stringWithFormat:@"SY"] forKey:@"data"];
    [dict8 setObject:[NSString stringWithFormat:@"CF"] forKey:@"data"];
    [dict9 setObject:[NSString stringWithFormat:@"ZIN"] forKey:@"data"];
    [dict10 setObject:[NSString stringWithFormat:@"CH"] forKey:@"data"];
    [dict11 setObject:[NSString stringWithFormat:@"SB"] forKey:@"data"];
    [dict12 setObject:[NSString stringWithFormat:@"PG"] forKey:@"data"];
    [dict13 setObject:[NSString stringWithFormat:@"Ri"] forKey:@"data"];
    [dict13 setObject:[NSString stringWithFormat:@"Vi"] forKey:@"data"];
    
    
    [dict5 setObject:@"0" forKey:@"check"];
    [dict6 setObject:@"0" forKey:@"check"];
    [dict7 setObject:@"0" forKey:@"check"];
    [dict8 setObject:@"0" forKey:@"check"];
    [dict9 setObject:@"0" forKey:@"check"];
    [dict10 setObject:@"0" forKey:@"check"];
    [dict11 setObject:@"0" forKey:@"check"];
    [dict12 setObject:@"0" forKey:@"check"];
    [dict13 setObject:@"0" forKey:@"check"];
    
    [self.varietalArray addObject:dict5];
    [self.varietalArray addObject:dict6];
    [self.varietalArray addObject:dict7];
    [self.varietalArray addObject:dict8];
    [self.varietalArray addObject:dict8];
    [self.varietalArray addObject:dict9];
    [self.varietalArray addObject:dict10];
    [self.varietalArray addObject:dict11];
    [self.varietalArray addObject:dict12];
    [self.varietalArray addObject:dict13];
    
    // sortby
    
    NSMutableDictionary *dict15 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict16 = [[NSMutableDictionary alloc] init];

    
    [dict15 setObject:[NSString stringWithFormat:@"Distance"] forKey:@"data"];
    [dict16 setObject:[NSString stringWithFormat:@"Gets"] forKey:@"data"];
    
    [dict15 setObject:@"0" forKey:@"check"];
    [dict16 setObject:@"0" forKey:@"check"];
    
    [self.sortbyArray addObject:dict15];
    [self.sortbyArray addObject:dict16];


    self.filterOptions = [NSMutableArray arrayWithArray:@[self.distanceArray, self.varietalArray, self.sortbyArray]];
    

    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelController)];
    [cancelItem setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchControllerButton)];
    [searchItem setTintColor:[UIColor whiteColor]];

    
    self.navigationItem.leftBarButtonItem=cancelItem;
    self.navigationItem.rightBarButtonItem=searchItem;
    
    self.currentDistanceSelection = -1;
    self.currentVarietalSelection = -1;
    self.currentSortBySelection = -1;
    
    
    // Accordian Setup
    self.distanceTable.sectionHeaderHeight = HEADER_HEIGHT;
    self.openSectionIndex = NSNotFound;
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"SectionHeaderView" bundle:nil];
    [self.distanceTable registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    
    // Custom cell initialization
    UINib *nib = [UINib nibWithNibName:@"WineTypeCell" bundle:nil];
    [self.WineTypeTable registerNib:nib forCellReuseIdentifier:@"WineTypeCell"];
    

    
    self.distanceTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //self.WineTypeTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.WineTypeTable.contentInset = UIEdgeInsetsZero;
    self.WineTypeTable.contentInset = UIEdgeInsetsMake(-20.0f, 0.0f, 0.0f, 0.0f);

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    

    
    /*
     Check whether the section info array has been created, and if so whether the section count still matches the current section count. In general, you need to keep the section info synchronized with the rows and section. If you support editing in the table view, you need to appropriately update the section info during editing operations.
     */
    if ((self.sectionInfoArray == nil) ||
        ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.distanceTable])) {
        
        
        NSMutableArray *infoArray = [[NSMutableArray alloc] init];
        // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
        for (NSMutableArray *option in self.filterOptions) {
            
            APLSectionInfo *sectionInfo = [[APLSectionInfo alloc] init];
            sectionInfo.items = option;
            sectionInfo.open = NO;
            
            NSNumber *defaultRowHeight = @(DEFAULT_ROW_HEIGHT);
            NSInteger countOfOptions = [sectionInfo.items count];
            for (NSInteger i = 0; i < countOfOptions; i++)
            {
                [sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
            }
            
            [infoArray addObject:sectionInfo];
        }
        
        self.sectionInfoArray = infoArray;
    }
    
    
   // NSLog(@"Section info Array: %lu", (unsigned long)[self.sectionInfoArray count]);
    
}

-(void)cancelController
{
    [delegate filtersControllerDidCancel:self];
}

-(void)searchControllerButton
{
    
    [delegate filtersControllerDidSearch:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma - mark UITablViewDelegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([tableView isEqual:distanceTable])
        return [self.filterOptions count];
    else
        return 1;
        
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if([tableView isEqual:distanceTable])
    {
        APLSectionInfo *sectionInfo = (self.sectionInfoArray)[section]; // Need to have SectionInfo class to know if it is open
        NSInteger numStoriesInSection = [sectionInfo.items count];
        return sectionInfo.open ? numStoriesInSection : 0;
    } else
    {
        return 3;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell1;
    WineTypeCell *cell2;
    
    
    if([tableView isEqual:distanceTable])
    {
        CellIdentifier= @"Cell";
        cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell1 == nil)
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    else
    {
        CellIdentifier = @"WineTypeCell"; // Custom Cell for WineType
        cell2 = [self.WineTypeTable dequeueReusableCellWithIdentifier:CellIdentifier];
        
       if(cell2 == nil)
            cell2 = [[WineTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // configure cell
    if([tableView isEqual:distanceTable])
    {
        NSArray *options = (NSArray *)[(self.sectionInfoArray)[indexPath.section] items];
        cell1.textLabel.text = [NSString stringWithFormat:@"%@", [[options objectAtIndex:indexPath.row] objectForKey:@"data"]];
        
    
        if ([[[options objectAtIndex:indexPath.row] objectForKey:@"check"] integerValue] == 1)
        {
            cell1.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell1.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell1;
        
    } else
    {
        //cell2.textLabel.text = @"Wine Type";
        return cell2;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    if([tableView isEqual:WineTypeTable ])
    {
        UIView *noSectionHeader=[[UIView alloc] initWithFrame:CGRectZero];
        return noSectionHeader;
    }
    APLSectionHeaderView *sectionHeaderView = [self.distanceTable dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    
    APLSectionInfo *sectionInfo = (self.sectionInfoArray)[section];
    sectionInfo.headerView = sectionHeaderView;
    
    if(section == 0)
        sectionHeaderView.titleLabel.text = @"Distance";
    if (section == 1)
        sectionHeaderView.titleLabel.text = @"Varietal";
    if(section == 2)
        sectionHeaderView.titleLabel.text = @"Sort By";
    
    sectionHeaderView.section = section;
    sectionHeaderView.delegate = self;
    
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([tableView isEqual:distanceTable])
    {
        APLSectionInfo *sectionInfo = (self.sectionInfoArray)[indexPath.section];
        return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
        
    } else
    {
        return 34;
    }

    // Alternatively, return rowHeight.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:distanceTable])
    {
        NSArray *options = (NSArray *)[(self.sectionInfoArray)[indexPath.section] items];
        
        if([[[options objectAtIndex:indexPath.row] objectForKey:@"check"] integerValue] == 1)
        {
            [[options objectAtIndex:indexPath.row] setObject:@"0" forKey:@"check"];
        } // check if the current row has already been checked
        else
        {
            if(indexPath.section == 0)
            {
                if(self.currentDistanceSelection != -1) // if a distance was selected previously ... uncheck that distance
                    [[options objectAtIndex:self.currentDistanceSelection] setObject:@"0" forKey:@"check"];
                [[options objectAtIndex:indexPath.row] setObject:@"1" forKey:@"check"];
                self.currentDistanceSelection = indexPath.row;
            }
            else if(indexPath.section == 1)
            {
                [[options objectAtIndex:indexPath.row] setObject:@"1" forKey:@"check"];
            }
            else if(indexPath.section == 2)
            {
                if(self.currentSortBySelection != -1)
                    [[options objectAtIndex:self.currentSortBySelection] setObject:@"0" forKey:@"check"];
                [[options objectAtIndex:indexPath.row] setObject:@"1" forKey:@"check"];
                self.currentSortBySelection = indexPath.row;
            }
    
        } // if it hasn't been checked
        
        
        NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < [options count]; i++)
          [indexPathArray addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
        //You can add one or more indexPath in this array...
        
        [self.distanceTable reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        [self tableView:self.distanceTable viewForHeaderInSection:[indexPath section]];
        
        
    }
    
}


#pragma mark - SectionHeaderViewDelegate

- (void)sectionHeaderView:(APLSectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
    
    APLSectionInfo *sectionInfo = (self.sectionInfoArray)[sectionOpened];
    
    sectionInfo.open = YES;
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [sectionInfo.items count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
        
        APLSectionInfo *previousOpenSection = (self.sectionInfoArray)[previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [previousOpenSection.items count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // style the animation so that there's a smooth flow in either direction
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // apply the updates
    [self.distanceTable beginUpdates];
    [self.distanceTable insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.distanceTable deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.distanceTable endUpdates];
    
    self.openSectionIndex = sectionOpened;
}


- (void)sectionHeaderView:(APLSectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
    APLSectionInfo *sectionInfo = (self.sectionInfoArray)[sectionClosed];
    
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.distanceTable numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.distanceTable deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
}



@end
