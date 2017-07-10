//
//  PushNotificationViewController.h
//  Reuters
//
//  Created by Priya Talreja on 17/08/16.
//  Copyright © 2016 Scriptlanes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JASidePanels/JASidePanelController.h>
#import "UIViewController+JASidePanel.h"
#import "HostCityViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "NetworkAccessor.h"
#import "DataAccessor.h"

@interface PushNotificationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NetworkAccessor *networkAC;
    DataAccessor *dataAC;
    
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
