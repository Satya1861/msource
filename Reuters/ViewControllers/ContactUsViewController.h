//
//  ContactUsViewController.h
//  Reuters
//
//  Created by Priya Talreja on 02/09/16.
//  Copyright © 2016 Scriptlanes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JASidePanels/JASidePanelController.h>
#import "UIViewController+JASidePanel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AppDelegate.h"
#import "NetworkAccessor.h"
#import "DataAccessor.h"

@interface ContactUsViewController : UIViewController <MFMailComposeViewControllerDelegate,MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UILabel *websiteLink;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumber;
@property (strong, nonatomic) IBOutlet UILabel *y1;
@property (strong, nonatomic) IBOutlet UILabel *y2;
@property (strong, nonatomic) IBOutlet UILabel *y3;
@property (strong, nonatomic) IBOutlet UILabel *y4;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
