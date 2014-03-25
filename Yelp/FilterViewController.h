//
//  FilterViewController.h
//  Yelp
//
//  Created by Tony Dao on 3/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpClient.h"

@protocol FilterViewControllerDelegate <NSObject>
- (void)doSearchOnController;
@end

@interface FilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, weak) id <FilterViewControllerDelegate> delegate;
@end
