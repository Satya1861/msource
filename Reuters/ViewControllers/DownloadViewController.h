//
//  DownloadViewController.h
//  Reuters
//
//  Created by Priya on 12/02/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Download.h"
#import "AppDelegate.h"
@interface DownloadViewController : UIViewController<UIWebViewDelegate,UIDocumentInteractionControllerDelegate>
{
    IBOutlet UILabel *headerLabel;
    IBOutlet UIWebView *downloadwebView;
}

@property (nonatomic, strong) NSString *path;
@property (nonatomic) Download *dFile;
- (IBAction)onClickBackBtn:(id)sender;

@end
