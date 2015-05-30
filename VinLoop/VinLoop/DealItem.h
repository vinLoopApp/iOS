//
//  DealItem.h
//  VinLoop
//
//  Created by Julien Hoachuck on 3/28/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DealItem : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *gets;
@property (nonatomic) NSNumber *lat;
@property (nonatomic) NSNumber *lng;
@property (nonatomic) NSNumber *byappt;
@property (nonatomic) NSNumber *bywalk;
@property (nonatomic) NSArray *varietal;
@property (nonatomic) NSNumber *price;
@property (nonatomic) NSNumber *origprice;
@property (nonatomic) NSNumber *dist;
@property (nonatomic) NSString *desc;
@property (nonatomic) NSString *imageURL;



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
                  dealImage:(NSString *) imageURL;

@end
