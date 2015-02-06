//
//  BusinessCell.m
//  Yelp
//
//  Created by Xiangyu Zhang on 2/3/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "BusinessCell.h"
#import "UIImageView+AFNetworking.h"

@interface BusinessCell ()
@property (weak, nonatomic) IBOutlet UIImageView *businessImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@end

@implementation BusinessCell

- (void)awakeFromNib {
    // Initialization code
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    self.businessImageView.layer.cornerRadius = 3;
    self.businessImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setBusiness:(Business *) business{
    _business = business;
    
    //set the business thumb image
    [self.businessImageView setImageWithURL:[NSURL URLWithString:self.business.imageUrl]];
    //set business name
    self.nameLabel.text = self.business.name;
    //set business rating
    [self.ratingImageView setImageWithURL:[NSURL URLWithString:self.business.ratingImageUrl]];
    //set business review text
    self.reviewLabel.text = [NSString stringWithFormat:@"%ld Reviews", self.business.numReviews];
    //set business address
    self.addressLabel.text = self.business.address;
    //set business distance
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", self.business.distance];
    //set business categories
    self.categoryLabel.text =self.business.categories;
}

- (void) layoutSubviews{
    [super layoutSubviews];
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
}
@end
