//
//  HostCityViewController.h
//  Reuters
//
//  Created by Priya Talreja on 17/08/16.
//  Copyright © 2016 Scriptlanes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KASlideShow.h"
#import <JASidePanels/JASidePanelController.h>
#import "UIViewController+JASidePanel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "NetworkAccessor.h"
#import "DataAccessor.h"
#import "AppUser.h"
#import "AppDelegate.h"
#import "HostCity.h"
#import "HostCityImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface HostCityViewController : UIViewController<KASlideShowDataSource, KASlideShowDelegate,MBProgressHUDDelegate>
{
    AppDelegate *app;
    NetworkAccessor *networkAC;
    DataAccessor *dataAC;
    NSMutableArray *dataArr;
    MBProgressHUD *HUD;
    NSMutableDictionary *hostCityDesc;
    NSMutableArray *photosArr;
  }
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;
@property (strong, nonatomic) IBOutlet UILabel *desc;
@property (strong, nonatomic) IBOutlet KASlideShow *imageAutomaticSlide;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *hostCity;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
