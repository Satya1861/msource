//
//  TeamMembersViewController.h
//  Reuters
//
//  Created by Priya Talreja on 31/01/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkAccessor.h"
#import "DataAccessor.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppDelegate.h"
@interface TeamMembersViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    NetworkAccessor *networkAC;
    DataAccessor *dataAC;
    MBProgressHUD *HUD;
    NSMutableArray *dataArr;
    NSArray *dataArr1;
    NSMutableArray *sortedDays;
    NSMutableDictionary *sections;

}
@property (weak, nonatomic) IBOutlet UILabel *teamName;

@property (weak, nonatomic) IBOutlet UIImageView *teamLogo;

@property (weak, nonatomic) IBOutlet UIImageView *sponsporLogo;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSString *teamObj;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoLeadingSpace;


@end
