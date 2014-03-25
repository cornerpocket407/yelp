//
//  ResultCellTableViewCell.m
//  Yelp
//
//  Created by Tony Dao on 3/24/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "ResultCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation ResultCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
- (void)setResult:(SearchResult *)result {
    _result = result;
    self.nameLabel.text = [NSString stringWithFormat:@"%d. %@", result.nth + 1, result.name];
    self.reviewCountLabel.text = [NSString stringWithFormat:@"%@ Reviews", [(NSNumber*)_result.reviewCount stringValue]];
    self.addressLabel.text = _result.address;
    self.distanceLabel.text = _result.distance;
    self.categoriesLabel.text = [_result.categories[0] componentsJoinedByString:@", "];
    [self.profileView setImageWithURL:[NSURL URLWithString:result.imageUrl]];
    [self.ratingView setImageWithURL:[NSURL URLWithString:result.ratingUrl]];
}
@end
