//
//  DealItem.m
//  VinLoop
//
//  Created by Julien Hoachuck on 3/28/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import "DealItem.h"

@implementation DealItem

-(instancetype)initWithTitle:(NSString *)title
                 wineryName:(NSString *)name
                   dealGets:(NSNumber *)gets
                  wineryLat: (NSNumber *)lat
                  wineryLng: (NSNumber *) lng
                 dealByAppt:(NSNumber *) byappt
                 dealByWalk:(NSNumber *) bywalk
               dealVarietal:(NSString *) varietal
                  dealPrice:(NSNumber *) price
              dealOrigPrice:(NSNumber *) origPrice
                   dealDesc:(NSString *) desc
                  dealImage:(NSString *) imageURL
{
    
    self = [super init];
    if(self)
    {
        _title=title;
        _name=name;
        _gets=gets;
        _lat=lat;
        _lng=lng;
        _byappt=byappt;
        _bywalk=bywalk;
        _varietal = [varietal componentsSeparatedByString:@","];
        NSLog(@"%@", _varietal[0]);
        _price=price;
        _origprice=origPrice;
        _desc=desc;
        _imageURL=imageURL;
    }
    
    return self;
}

@end
