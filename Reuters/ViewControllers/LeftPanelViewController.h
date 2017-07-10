//
//  LeftPanelViewController.h
//  Reuters
//
//  Created by Priya on 30/01/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NetworkAccessor.h"
#import "HostCityViewController.h"
@interface LeftPanelViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    AppDelegate *app;
    NetworkAccessor *networkAC;
    NSArray *menuArr;
    NSArray *unSelImgs;
    NSArray *selImgs;
    
    IBOutlet UITableView *menuTableView;
}
@property(strong,nonatomic)HostCityViewController *hcVC;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingSpaceImg;

@end
