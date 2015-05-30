//
//  DealItemCell.m
//  VinLoop
//
//  Created by Julien Hoachuck on 3/28/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import "DealItemCell.h"

@implementation DealItemCell

- (void)awakeFromNib {
    
    NSMutableAttributedString *atrOldPriceString = [[NSMutableAttributedString alloc] initWithString:_oldPrice.text];
    [atrOldPriceString addAttribute:NSStrikethroughStyleAttributeName
                            value:@2
                            range:NSMakeRange(0, [atrOldPriceString length])];
    _oldPrice.attributedText = atrOldPriceString;
    
    
    
    /*
    self.dealLabelDesc.numberOfLines = 0;
    NSString* string = @"String with line one. \n Line two. \n Line three.";
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 30.f;
    style.maximumLineHeight = 30.f;
    NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};
    self.dealLabelDesc.attributedText = [[NSAttributedString alloc] initWithString:string
                                                                        attributes:attributtes];
    [self.dealLabelDesc sizeToFit];
    
     */
    //[self.dealLabelDesc sizeToFit];
}
 

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/*
-(void) layoutSubviews
{
    [super layoutSubviews];
    cell.frame = CGRectOffset(cell.frame, 10, 10);
}
*/
@end
