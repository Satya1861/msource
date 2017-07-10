//
//  LandingViewController.m
//  Reuters
//
//  Created by Priya Talreja on 03/02/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import "LandingViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PushNotificationViewController.h"
#import "WebsiteViewController.h"
@interface LandingViewController ()
{
    MBProgressHUD *HUD;
    NetworkAccessor *networkAC;
    DataAccessor *dataAC;
}
@end

@implementation LandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HUD = [[MBProgressHUD alloc] init];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.color = [UIColor clearColor];
    networkAC = [NetworkAccessor shareNetworkAccessor];
    dataAC = [DataAccessor shareDataAccessor];
    [self getData];

    // Do any additional setup after loading the view.
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
        
        [networkAC getLandingPage:^(NSInteger status, NSDictionary *results) {
            if(status)
            {
                [HUD removeFromSuperview];

                NSString *fileName = @"lp";
                NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
                [results writeToFile:filePath atomically:YES];
                [self parseData:results];
                
            }
        }];
    }else
    {
        NSString *dataPath = [documentDirectory stringByAppendingPathComponent:@"lp"];
        
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
    NSArray *results = [data objectForKey:@"results"];
    if (results.count > 0) {
        NSDictionary *result = [results objectAtIndex:0];
        if ([result objectForKey:@"landingImage"]) {
            NSDictionary *landingImage = [result objectForKey:@"landingImage"];
            if ([landingImage objectForKey:@"url"]) {
                [self.landingImage sd_setImageWithURL:[NSURL URLWithString:[landingImage objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"sponsor_de"]];
            }
            
        }
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)leftOpen:(id)sender {
    
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
