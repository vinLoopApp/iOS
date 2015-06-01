//
//  NavRowTableViewCell.h
//  VinLoop
//
//  Created by Julien Hoachuck on 5/31/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavRowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rowIcon;
@property (weak, nonatomic) IBOutlet UILabel *rowText;

@end
