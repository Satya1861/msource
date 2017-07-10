//
//  SponsporLinkViewController.h
//  Reuters
//
//  Created by Priya Talreja on 03/02/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "NetworkAccessor.h"
@interface SponsporLinkViewController : UIViewController
{
    NetworkAccessor *networkAC;
}
@property (weak, nonatomic) IBOutlet UILabel *sponsporName;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic)BOOL isInfo;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *url;
@end
