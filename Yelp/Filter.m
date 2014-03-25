//
//  SortBy.m
//  Yelp
//
//  Created by Tony Dao on 3/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "Filter.h"
@interface Filter ()

@end

@implementation Filter

- (id) initWithObjects:(NSArray *)array {
    self = [super init];
    if (self) {
        self.filters = [NSMutableArray arrayWithArray:array];
        [self select:0]; //TODO: Not very elegant..
    }
    return self;
}
- (void)select: (NSInteger)index {
    self.selectedIndex = index;
    self.selectedParam = self.filters[index][@"param"];
    self.selectedLabel = self.filters[index][@"name"];
}
- (NSString *)getLabel: (NSInteger)index {
    NSDictionary *sortBy = self.filters[index];
    return sortBy[@"name"];
}
- (NSInteger) size {
    return self.filters.count;
}
@end
