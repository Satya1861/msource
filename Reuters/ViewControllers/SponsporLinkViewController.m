//
//  SponsporLinkViewController.m
//  Reuters
//
//  Created by Priya Talreja on 03/02/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import "SponsporLinkViewController.h"

@interface SponsporLinkViewController ()
{
    MBProgressHUD *HUD;
}
@end

@implementation SponsporLinkViewController
@synthesize name,url,isInfo;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    networkAC = [NetworkAccessor shareNetworkAccessor];
    if (isInfo) {
        NSFileManager *fileManage =[NSFileManager defaultManager];
        NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        if (networkAC.internetConnectivity) {
            
            HUD = [[MBProgressHUD alloc] init];
            HUD.mode = MBProgressHUDModeIndeterminate;
            
            [self.view addSubview:HUD];
            HUD.delegate = self;
            
            [HUD show:YES];
            
            [networkAC getQuizRules:^(NSInteger status, NSDictionary *results) {
                if(status)
                {
                    NSString *fileName = @"quizRule";
                    NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
                    [results writeToFile:filePath atomically:YES];
                     [HUD removeFromSuperview];
                    [self parseData:results];
                    
                }
            }];

        }
        else
        {
            NSString *dataPath = [documentDirectory stringByAppendingPathComponent:@"quizRule"];
            
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
    else
    {
    if (networkAC.internetConnectivity) {
        
    HUD = [[MBProgressHUD alloc] init];
     HUD.mode = MBProgressHUDModeIndeterminate;
    
    [self.view addSubview:HUD];
    HUD.delegate = self;
    
    [HUD show:YES];

        
        
            NSMutableURLRequest * request;

            if (name) {
                self.sponsporName.text = [name uppercaseString];
            }
            else
            {
        
            }
    
            request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
            [self.webView loadRequest:request];
    }
    else
    {
        UIAlertView * alertView1 = [[UIAlertView alloc]initWithTitle:@"JPL Pune 2017" message:@"Seems you are not connected to internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alertView1 show];
        

    }
    
     [self performSelector:@selector(hide) withObject:NULL afterDelay:5.0];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    
    
}
-(void)parseData:(NSDictionary *)data
{
    NSArray *results = [data objectForKey:@"results"];
    if (results.count > 0) {
        NSDictionary *result = [results objectAtIndex:0];
        if ([result objectForKey:@"details"]) {
            
            if ([result objectForKey:@"title"]) {
                self.sponsporName.text = [result objectForKey:@"title"];
            }
            else
            {
                self.sponsporName.text = @"Quiz Rules and Regulations";
            }
            NSString *contactus = [result objectForKey:@"details"];
            NSMutableString *html = [NSMutableString stringWithString: @"<html><body><div>"];
            [html appendString:contactus];
            [html appendString:@"</div></body></html>"];
            [_webView loadHTMLString:html baseURL:nil];
        }
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HUD removeFromSuperview];
}

-(void)hide
{
     [HUD removeFromSuperview];
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
