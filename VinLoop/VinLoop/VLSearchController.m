//
//  VLSearchController.m
//  VinLoop
//
//  Created by Julien Hoachuck on 5/3/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import "VLSearchController.h"
#import "VLSearchBar.h"

@interface VLSearchController () 
@end

@implementation VLSearchController{
    UISearchBar *_searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UISearchBar *)searchBar {

    if (_searchBar == nil) {
        _searchBar = [[VLSearchBar alloc] initWithFrame:CGRectZero];
       _searchBar.delegate = self;
    }
    return _searchBar;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchBar.text length] > 0) {
        self.active = true;
    } else {
        self.active = false;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"SearchBar Clicked");
    [searchBar resignFirstResponder];
}


@end
