//
//  QuizViewController.h
//  Reuters
//
//  Created by Priya Talreja on 02/02/17.
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
@interface QuizViewController : UIViewController
{
     NSMutableArray *dataArr;
}
@property (weak, nonatomic) IBOutlet UIImageView *op4Img;
@property (weak, nonatomic) IBOutlet UILabel *op4;
@property (weak, nonatomic) IBOutlet UIImageView *op1Img;
@property (weak, nonatomic) IBOutlet UILabel *op1;
@property (weak, nonatomic) IBOutlet UIImageView *op3Img;
@property (weak, nonatomic) IBOutlet UILabel *op3;
@property (weak, nonatomic) IBOutlet UIImageView *op2Img;
@property (weak, nonatomic) IBOutlet UILabel *op2;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UILabel *question;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHt;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view4Ht;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1Ht;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2Ht;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view3Ht;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *op4Ht;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *op1Ht;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *op2Ht;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *op3Ht;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;


@end
