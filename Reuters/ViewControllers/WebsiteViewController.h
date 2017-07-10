//
//  WebsiteViewController.h
//  Reuters
//
//  Created by Priya Talreja on 02/09/16.
//  Copyright © 2016 Scriptlanes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JASidePanels/JASidePanelController.h>
#import "UIViewController+JASidePanel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "NetworkAccessor.h"
#import "DataAccessor.h"
@interface WebsiteViewController : UIViewController<MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
