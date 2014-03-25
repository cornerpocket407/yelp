//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpClient.h"

@implementation YelpClient
- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
    self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
    if (self) {
        BDBOAuthToken *token = [BDBOAuthToken tokenWithToken:accessToken secret:accessSecret expiration:nil];
        [self.requestSerializer saveAccessToken:token];
    }
    return self;
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setObject:term forKey:@"term"];
    [parameters setObject:@"San Francisco" forKey:@"location"];
    [parameters setObject:@"37.77493,-122.419415" forKey:@"cll"];
    if (self.sort) {
        [parameters setObject:self.sort forKey:@"sort"];
    }
    if (self.radius) {
        [parameters setObject:@"965" forKey:@"radius_filter"];
    }
    if (self.deals) {
        [parameters setObject:@(self.deals) forKey:@"deals_filter"];
    }
    NSLog(@"Using paramters %@", parameters);
    return [self GET:@"search" parameters:parameters success:success failure:failure];
}
@end
