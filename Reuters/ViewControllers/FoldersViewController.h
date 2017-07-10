//
//  FoldersViewController.h
//  Reuters
//
//  Created by Priya Talreja on 06/02/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JASidePanels/JASidePanelController.h>
#import "UIViewController+JASidePanel.h"
#import "NetworkAccessor.h"
#import "DataAccessor.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface FoldersViewController : UIViewController
{
    NetworkAccessor *networkAC;
    DataAccessor *dataAC;
    
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
