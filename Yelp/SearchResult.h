//
//  SearchResult.h
//  Yelp
//
//  Created by Tony Dao on 3/24/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResult : NSObject
@property(nonatomic, strong) NSString *imageUrl;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *reviewCount;
@property(nonatomic, strong) NSString *ratingUrl;
@property(nonatomic, strong) NSArray *categories;
@property(nonatomic, strong) NSString *distance;
@property (nonatomic, assign) NSInteger nth;
- (id) initWithDictionary:(NSDictionary *)dictionary nth:(NSInteger)nth;
@end
