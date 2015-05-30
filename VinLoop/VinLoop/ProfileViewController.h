//
//  ProfileViewController.h
//  VinLoop
//
//  Created by Julien Hoachuck on 4/22/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProfileViewController;

@protocol ProfileViewControllerDelegate <NSObject>
-(void)profileControllerDidCancel:(ProfileViewController *)controller;
-(void)profileControllerDidSave:(ProfileViewController *)controller;
@end

@interface ProfileViewController : UIViewController
@property (nonatomic, weak) id <ProfileViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString* fName;
@property (strong, nonatomic) NSString* lName;

@property (weak, nonatomic) IBOutlet UITextField* firstName;
@property (weak, nonatomic) IBOutlet UITextField* lastName;
@property (weak, nonatomic) IBOutlet UITextField* zipcode;
@property (weak, nonatomic) IBOutlet UITextField* email;

-(void)saveControllerButton;
-(void)cancelController;
@end
