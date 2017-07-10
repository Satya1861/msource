//
//  StandingsViewController.h
//  Reuters
//
//  Created by Priya Talreja on 02/02/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JASidePanels/JASidePanelController.h>
#import "UIViewController+JASidePanel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "NetworkAccessor.h"
#import "DataAccessor.h"

@interface StandingsViewController : UIViewController
{
    NetworkAccessor *networkAC;
    DataAccessor *dataAC;
    
    MBProgressHUD *HUD;

}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIView *segmentView;

@end
