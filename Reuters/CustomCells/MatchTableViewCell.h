//
//  MatchTableViewCell.h
//  Reuters
//
//  Created by Priya Talreja on 30/01/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *matchName;
@property (weak, nonatomic) IBOutlet UILabel *team1;
@property (weak, nonatomic) IBOutlet UILabel *team2;

@property (weak, nonatomic) IBOutlet UILabel *venue;

@property (weak, nonatomic) IBOutlet UIImageView *alertImg;

@property (weak, nonatomic) IBOutlet UIButton *alertBtn;


@end
