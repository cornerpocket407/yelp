//
//  SearchResult.m
//  Yelp
//
//  Created by Tony Dao on 3/24/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "SearchResult.h"
@implementation SearchResult
- (id) initWithDictionary:(NSDictionary *)dictionary nth:(NSInteger)nth {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];;
        self.imageUrl = dictionary[@"image_url"];
        self.address = [dictionary[@"location"][@"address"] count] ? dictionary[@"location"][@"address"][0] : nil;
        self.reviewCount = dictionary[@"review_count"];
        self.ratingUrl = dictionary[@"rating_img_url"];
        self.categories = dictionary[@"categories"];
        self.nth = nth;
    }
    return self;
}
@end
