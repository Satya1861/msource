//
//  StandingsViewController.m
//  Reuters
//
//  Created by Priya Talreja on 02/02/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import "StandingsViewController.h"
#import "PushNotificationViewController.h"
#import "WebsiteViewController.h"
#import "HMSegmentedControl.h"
#import "Constants.h"
@interface StandingsViewController ()
{
    HMSegmentedControl *segmentedControl1;
    long selectedSegment;
}
@end

@implementation StandingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    networkAC = [NetworkAccessor shareNetworkAccessor];
    dataAC = [DataAccessor shareDataAccessor];
    HUD = [[MBProgressHUD alloc] init];
    selectedSegment =0 ;
     HUD.mode = MBProgressHUDModeIndeterminate;
   
    [self setSegmentControlView];
    [self getData];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)swipeRecognizer:(UISwipeGestureRecognizer *)sender {
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if (segmentedControl1.selectedSegmentIndex==0)
        {
            segmentedControl1.selectedSegmentIndex=1;
            [self segmentedControlChangedValue:segmentedControl1];
            
        }
    }
    else
    {
         if (segmentedControl1.selectedSegmentIndex==1)
        {
            segmentedControl1.selectedSegmentIndex=0;
            [self segmentedControlChangedValue:segmentedControl1];
            
        }
        
    }
    
    
    
}

-(void)setSegmentControlView
{
    segmentedControl1 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"PUNE LEAGUE", @"ZONAL LEAGUE"]];
    //  segmentedControl3.sectionTitles.
    [segmentedControl1 setFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 45)];
    [segmentedControl1 setIndexChangeBlock:^(NSInteger index) {
        // NSLog(@"Selected index %ld (via block)", (long)index);
        
    }];
    
    segmentedControl1.selectionIndicatorHeight = 3.0f;
    segmentedControl1.backgroundColor = [UIColor colorWithRed:(41/255.0) green:(21/255.0) blue:(110/255.0) alpha:1];
    segmentedControl1.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:0.4]};
    segmentedControl1.selectionIndicatorColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
    segmentedControl1.selectedTitleTextAttributes=@{NSForegroundColorAttributeName : [UIColor whiteColor]};
    segmentedControl1.selectedSegmentIndex = 0;
    segmentedControl1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl1.shouldAnimateUserSelection = NO;
    segmentedControl1.tag = 1;
    [segmentedControl1 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.segmentView addSubview:segmentedControl1];
    
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    selectedSegment=(long)segmentedControl.selectedSegmentIndex;
  //  self.webView.hidden = true;
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    [self getData];
    
}

-(void)getData
{
    NSFileManager *fileManage =[NSFileManager defaultManager];
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    
    [self.view addSubview:HUD];
    HUD.delegate = self;
    
    [HUD show:YES];
    
    
    if([networkAC internetConnectivity])
    {
        NSString *standing;
        if (selectedSegment == 0) {
            standing = standingsUrl;
        }
        else
        {
            standing = zonalStandingsUrl;
        }
        
        [networkAC getStandings:standing :^(NSInteger status, NSDictionary *results) {
            if(status)
            {
                [HUD removeFromSuperview];
                if (selectedSegment == 0) {
                    NSString *fileName = @"standings";
                    NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
                    [results writeToFile:filePath atomically:YES];
                }
                else
                {
                    NSString *fileName = @"zstandings";
                    NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
                    [results writeToFile:filePath atomically:YES];
                }
                
                [self parseData:results];
                
            }
        }];
    }else
    {
        NSString *dataPath;
        if (selectedSegment == 0) {
            dataPath = [documentDirectory stringByAppendingPathComponent:@"standings"];
        }
        else
        {
            dataPath = [documentDirectory stringByAppendingPathComponent:@"zstandings"];
        }
        
        if ([fileManage fileExistsAtPath:dataPath])
        {
            [HUD removeFromSuperview];
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:dataPath];
            [self parseData:dict];
        }else
        {
            [HUD removeFromSuperview];
            
            
            UIAlertView * alertView1 = [[UIAlertView alloc]initWithTitle:@"JPL Pune 2017" message:@"Seems you are not connected to internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alertView1 show];
            
        }
        
        
        
        
        
    }

}

-(void)parseData:(NSDictionary *)data
{
    NSString *standings = [data objectForKey:@"result"];
   // NSString *style = @"<style> table { width:94%;font-size:12px;	 margin:20px auto; border-collapse: collapse; } table, th, td { text-align:center; border: 1px solid #A9A9A9; } td{padding:3px;}th{padding:5px; background-color: rgb(229,66,53); color:white; } table:nth-child(2n+2) th{ background-color: rgb(243,145,20); } table:nth-child(3n+3) th{ background-color: rgb(46,141,216); } table:nth-child(4n+4) th{ background-color: rgb(35,165,86); } </style>";
    NSMutableString *html = [NSMutableString stringWithString: @"<html><body><div>"];
    [html appendString:standings];
   // [html appendString:style];
     [html appendString:@"</div></body></html>"];
    [_webView loadHTMLString:html baseURL:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openLeftClicked:(id)sender {
     [self.sidePanelController showLeftPanelAnimated:YES];
}

- (IBAction)openTwitter:(id)sender {
    WebsiteViewController *vv =[self.storyboard instantiateViewControllerWithIdentifier:@"WebsiteViewController"];
    [self.navigationController pushViewController:vv animated:true];
    
    
    
}

- (IBAction)openNotifciations:(id)sender {
    
    PushNotificationViewController *vv =[self.storyboard instantiateViewControllerWithIdentifier:@"PushNotificationViewController"];
    [self.navigationController pushViewController:vv animated:true];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
