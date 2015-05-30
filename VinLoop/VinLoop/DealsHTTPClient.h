//
//  DealsHTTPClient.h
//  VinLoop
//
//  Created by Julien Hoachuck on 4/3/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@protocol DealsHTTPClientDelegate;

@interface DealsHTTPClient : AFHTTPSessionManager
@property (nonatomic, strong) id<DealsHTTPClientDelegate> delegate; // used to be weak

+(DealsHTTPClient *)sharedDealsHTTPClient;
-(instancetype)initWithBaseURL:(NSURL *)url;
-(void)updateDeals;

@end

@protocol DealsHTTPClientDelegate <NSObject>

@optional
-(void)DealsHTTPClient: (DealsHTTPClient *)client didUpdateWithDeals:(id)deals;
-(void)DealsHTTPClient:(DealsHTTPClient *)client didFailWithError:(NSError *)error;
@end


