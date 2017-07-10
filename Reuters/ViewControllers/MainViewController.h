//
//  MainViewController.h
//  Reuters
//
//  Created by Priya Talreja on 30/01/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JASidePanels/JASidePanelController.h>
#import "UIViewController+JASidePanel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "NetworkAccessor.h"
#import "DataAccessor.h"
#import "AppUser.h"
#import "AppDelegate.h"
#import <EventKit/EventKit.h>
@interface MainViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
    AppDelegate *app;
    NetworkAccessor *networkAC;
    DataAccessor *dataAC;
    
    MBProgressHUD *HUD;
    
    NSTimer *timer;
    
    AppUser *currentUser;
    NSMutableArray *sortedDays;
    NSMutableDictionary *sections;
    
    NSMutableArray *sortedDays1;
    NSMutableDictionary *sections1;

    
    NSMutableArray *dataArr;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) EKEventStore *eventStore;
@property (nonatomic) BOOL isAccessToEventStoreGranted;
@property (strong, nonatomic) EKCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIImageView *decimg;
@property (weak, nonatomic) IBOutlet UIImageView *incImg;

@property (weak, nonatomic) IBOutlet UILabel *month;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
