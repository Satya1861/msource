//
//  VideosViewController.h
//  Reuters
//
//  Created by Priya Talreja on 06/02/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JASidePanels/JASidePanelController.h>
#import "UIViewController+JASidePanel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "NetworkAccessor.h"
#import "DataAccessor.h"

@interface VideosViewController : UIViewController
{
    NetworkAccessor *networkAC;
    DataAccessor *dataAC;
    MBProgressHUD *HUD;
}
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic,strong)NSString *videoId;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
