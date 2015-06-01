//
//  NavTableViewController.m
//  VinLoop
//
//  Created by Julien Hoachuck on 5/30/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0] // Used for color

#import "NavTableViewController.h"
#import "SWRevealViewController.h"
#import "FiltersViewController.h"
#import "DealsTableViewController.h"
#import "NavRowTableViewCell.h"
#import "NavTopTableViewCell.h"


@interface NavTableViewController ()

@end

@implementation NavTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib1 = [UINib nibWithNibName:@"NavRowTableViewCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"navbarCell"];
    
    UINib *nib2 = [UINib nibWithNibName:@"NavTopTableViewCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"navtop"];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.view.backgroundColor = UIColorFromRGB(0xFDF9F3);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewCell" forIndexPath:indexPath];
    
    
    
    if(indexPath.row == 0)
    {
        NavTopTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"navtop"];
        if(cell1 == nil)
        {
            cell1 = [[NavTopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"navtop"];
            
        }
        
        cell1.logo.image =[[UIImage imageNamed:@"logo2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        return cell1;
        
        
    }
    else
    {
        NavRowTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"navbarCell"];
        if(cell2 == nil)
        {
            cell2 = [[NavRowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"navbarCell"];
            
        }

        if(indexPath.row == 1)
        {
            cell2.rowText.text = @"Profile";
            cell2.rowIcon.image = [[UIImage imageNamed:@"ic_account_circle.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        else if(indexPath.row == 2)
        {
            cell2.rowText.text = @"Favorites";
            cell2.rowIcon.image = [[UIImage imageNamed:@"ic_favorite_border_36pt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        else if(indexPath.row == 3)
        {
            cell2.rowText.text = @"About";
            cell2.rowIcon.image = [[UIImage imageNamed:@"ic_bug_report"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        else if(indexPath.row == 4)
        {
            cell2.rowText.text = @"Contact";
            cell2.rowIcon.image = [[UIImage imageNamed:@"ic_headset_mic_36pt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        
        return cell2;
    }
    /*
    if(indexPath.row != 0)
    {
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        separatorLineView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:separatorLineView];
    }
     */
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 167;
    }
    else
    {
        return 48;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SWRevealViewController *revealController = [self revealViewController];
    
    if(indexPath.row == 1)
    {
        
        UINavigationController *dealsFrontController2 = (UINavigationController *) revealController.frontViewController;
        DealsTableViewController *rootView = [dealsFrontController2.viewControllers objectAtIndex:0];
        [rootView showSettings];
    } else if(indexPath.row == 2)
    {
        UINavigationController *dealsFrontController2 = (UINavigationController *) revealController.frontViewController;
        DealsTableViewController *rootView = [dealsFrontController2.viewControllers objectAtIndex:0];
        [rootView showFavorites];
        
    }
    
    

    [revealController revealToggle:self];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
