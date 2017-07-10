//
//  PhotoCollectionViewController.h
//  Reuters
//
//  Created by Priya on 16/02/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JASidePanels/JASidePanelController.h>
#import "UIViewController+JASidePanel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "NetworkAccessor.h"
#import "DataAccessor.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
@interface PhotoCollectionViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,MBProgressHUDDelegate,MWPhotoBrowserDelegate>
{
    NetworkAccessor *networkAC;
    DataAccessor *dataAC;
    MBProgressHUD *HUD;
    AppDelegate *app;
    
    int i;
    
    IBOutlet UILabel *headerLabel;
    
    NSMutableArray *dataArr;
    NSMutableArray *photosArr;
    
    IBOutlet UICollectionView *photoCollectionView;
    
    IBOutlet UICollectionView *sponsorCollectionView;
    
    IBOutlet UIButton *nextBtn;
    IBOutlet UIImageView *nextImage;
    
    IBOutlet UIView *errorView;
    IBOutlet UIImageView *errImage;
    IBOutlet UILabel *errLabel;
}
@property BOOL isNextView;
@property BOOL isVideo;
@property NSString *photoObjectId;
- (IBAction)onClickBackBtn:(id)sender;
- (IBAction)onClickNextBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageBack;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photocellwidth;

@end
