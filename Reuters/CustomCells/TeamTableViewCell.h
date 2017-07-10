//
//  TeamTableViewCell.h
//  Reuters
//
//  Created by Priya Talreja on 31/01/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *memberImg;
@property (weak, nonatomic) IBOutlet UILabel *memberName;
@property (weak, nonatomic) IBOutlet UILabel *desg;

@end
