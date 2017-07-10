//
//  LandingViewController.h
//  Reuters
//
//  Created by Priya Talreja on 03/02/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JASidePanels/JASidePanelController.h>
#import "UIViewController+JASidePanel.h"
#import "NetworkAccessor.h"
#import "DataAccessor.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface LandingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *landingImage;

@end
