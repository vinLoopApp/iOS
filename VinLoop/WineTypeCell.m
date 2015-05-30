//
//  WineTypeCell.m
//  VinLoop
//
//  Created by Julien Hoachuck on 5/26/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import "WineTypeCell.h"

@implementation WineTypeCell

- (void)awakeFromNib {
        self.typeSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
