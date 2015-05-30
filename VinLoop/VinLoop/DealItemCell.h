//
//  DealItemCell.h
//  VinLoop
//
//  Created by Julien Hoachuck on 3/28/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *dealLabelDesc;
@property (weak, nonatomic) IBOutlet UILabel *dealLabelWine;
@property (weak, nonatomic) IBOutlet UILabel *dealDist;
@property (weak, nonatomic) IBOutlet UILabel *getsLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
@property (weak, nonatomic) IBOutlet UILabel *disPrice;
@property (weak, nonatomic) IBOutlet UILabel *byWalkorApp;


@end
  