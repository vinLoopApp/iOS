//
//  ProfileViewController.m
//  VinLoop
//
//  Created by Julien Hoachuck on 4/22/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import "ProfileViewController.h"
#import "SWRevealViewController.h"

@interface ProfileViewController ()
// UI elements
@property (weak, nonatomic) IBOutlet UIView* contentView;
@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@end

@implementation ProfileViewController
@synthesize delegate;
@synthesize firstName, lastName, zipcode, email;


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
    
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelController)];
    [cancelItem setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveControllerButton)];
    [searchItem setTintColor:[UIColor whiteColor]];
    
    
    self.navigationItem.leftBarButtonItem=cancelItem;
    self.navigationItem.rightBarButtonItem=searchItem;
    
    self.lastName.text = self.lName;
    self.firstName.text = self.fName;
    
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

-(void)cancelController
{
    [delegate profileControllerDidCancel:self];
}

-(void)saveControllerButton
{
    [delegate profileControllerDidSave:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
