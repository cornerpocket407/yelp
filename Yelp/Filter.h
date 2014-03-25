//
//  SortBy.h
//  Yelp
//
//  Created by Tony Dao on 3/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Filter : NSObject
@property (nonatomic, strong) NSMutableArray *filters;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSString *param;
@property (nonatomic, strong) NSString *selectedParam;
@property (nonatomic, strong) NSString *selectedLabel;
@property (nonatomic, assign) BOOL expanded;
- (void)select: (NSInteger)index;
- (NSString *)getLabel: (NSInteger)index;
- (id) initWithObjects:(NSArray *)array;
- (NSInteger) size;
@end