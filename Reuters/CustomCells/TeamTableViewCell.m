//
//  TeamTableViewCell.m
//  Reuters
//
//  Created by Priya Talreja on 31/01/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import "TeamTableViewCell.h"

@implementation TeamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.memberImg.layer.cornerRadius = 70/2;
    self.memberImg.layer.masksToBounds = true;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
