//
//  RegistrationViewController.h
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
#import <JASidePanels/JASidePanelController.h>
#import "UIViewController+JASidePanel.h"

@interface RegistrationViewController : UIViewController<UITextFieldDelegate>
{
    NetworkAccessor *networkAC;
    DataAccessor *dataAC;
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UITextField *fullName;
@property (weak, nonatomic) IBOutlet UITextField *emailId;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumber;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *activeTextField;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
