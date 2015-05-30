//
//  DealsHTTPClient.m
//  VinLoop
//
//  Created by Julien Hoachuck on 4/3/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import "DealsHTTPClient.h"

@implementation DealsHTTPClient
static NSString * const DealsURLString = @"http://www.zoomonby.com/vinLoop/dealTable.php"; // base URL

+(DealsHTTPClient *)sharedDealsHTTPClient
{
    static DealsHTTPClient *_sharedDealsHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{_sharedDealsHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:DealsURLString]];
    });
    
    return _sharedDealsHTTPClient;
} // Only create once

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if(self)
    {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
    
} // initialize with the BASE URL and set up the serializers.

-(void)updateDeals // add some data structure holding the different filters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"format"]=@"json";
    
    [self GET:@"jTest.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if([self.delegate
            respondsToSelector:@selector(DealsHTTPClient:didUpdateWithDeals:)])
        {
            [self.delegate DealsHTTPClient:self didUpdateWithDeals:responseObject]; // updates the delegate ... notifies the controller that information is to be updated
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(DealsHTTPClient:didFailWithError:)]) {
            [self.delegate DealsHTTPClient:self didFailWithError:error]; // updates the delegate
        }
    }];
} // Function used to get the current deals... Filterd options will be added later


@end
