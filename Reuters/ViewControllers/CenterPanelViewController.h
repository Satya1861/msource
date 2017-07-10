//
//  CenterPanelViewController.h
//  Reuters
//
//  Created by Sonali on 30/01/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JASidePanels/JASidePanelController.h>
#import "UIViewController+JASidePanel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "NetworkAccessor.h"
#import "DataAccessor.h"
#import "AppUser.h"
#import "AppDelegate.h"
#import "HostCityViewController.h"
@interface CenterPanelViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,MBProgressHUDDelegate, UITextFieldDelegate>
{
    AppDelegate *app;
    NetworkAccessor *networkAC;
    DataAccessor *dataAC;
    
    MBProgressHUD *HUD;
    
    NSTimer *timer;
    
    AppUser *currentUser;
    
    
    NSMutableArray *dataArr;
    NSMutableArray *tab1Arr;
    NSMutableArray *tab2Arr;
   
    NSMutableArray *fileNameArray;
   
    NSMutableArray *sortedDays;
    NSMutableDictionary *sections;
    
    NSMutableArray *sortedDays1;
    NSMutableDictionary *sections1;
    
    NSArray *allSpeakersArr;
    
    BOOL isFirstTab;
    
    NSString * contentTypeName,* alertfileName,* alertfilePath;
    
    Download *selDownload;
    NSString *selDownloadPath;
    
    IBOutlet UIImageView *topImg;
    IBOutlet UIImageView *arrowImage;
    IBOutlet UITableView *eventTableView;
    IBOutlet UITableView *downloadTableView;
    IBOutlet UITableView *quesSpeaker;
    IBOutlet UILabel *raiseLabel;
    
    IBOutlet UILabel *titleLabel;
    
    IBOutlet UIButton *searchBtn;
    IBOutlet UITextField *searchText;
    IBOutlet UIImageView *searchImg;
    
    IBOutlet UIView *buttonView;
    IBOutlet UIImageView *sel1Img;
    IBOutlet UIImageView *deSel1Img;
    IBOutlet UIButton *btn1;
    IBOutlet UIImageView *sel2Img;
    IBOutlet UIImageView *deSel2Img;
    IBOutlet UIButton *btn2;
    
    IBOutlet UIView *errorView;
    IBOutlet UIImageView *errImage;
    IBOutlet UILabel *errLabel;
}
@property (strong, nonatomic) IBOutlet UIView *scheduleView;
@property (strong, nonatomic) IBOutlet UIImageView *schImage;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIImageView *menuImg;
@property (weak, nonatomic) IBOutlet UIImageView *sponsporImg;

@property BOOL isNextView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *eventTableViewTop;
@property (strong, nonatomic) IBOutlet UILabel *day1Label;
@property (strong, nonatomic) IBOutlet UILabel *day2Label;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *day1Width;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *day2Width;
@property(strong,nonatomic)HostCityViewController *hcVC;
- (IBAction)onClickMenuBtn:(id)sender;
- (IBAction)onClickSearch:(id)sender;
- (IBAction)onClickTabBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *segmentView;

@end
