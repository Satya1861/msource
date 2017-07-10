//
//  ResultDetailsViewController.m
//  Reuters
//
//  Created by Priya Talreja on 03/02/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import "ResultDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ResultDetailsViewController ()
{
    MBProgressHUD *HUD;
    NetworkAccessor *networkAC;
    DataAccessor *dataAC;
}
@end

@implementation ResultDetailsViewController
@synthesize fixture;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HUD = [[MBProgressHUD alloc] init];
     HUD.mode = MBProgressHUDModeIndeterminate;
    networkAC = [NetworkAccessor shareNetworkAccessor];
    dataAC = [DataAccessor shareDataAccessor];
    [self getData];
}
-(void)getData
{
    
    
    [self.view addSubview:HUD];
    HUD.delegate = self;
    
    [HUD show:YES];
    
    
    if([networkAC internetConnectivity])
    {
        
        [networkAC getSummary:fixture :^(NSInteger status, NSDictionary *results) {
            if(status)
            {
                
                [HUD removeFromSuperview];
               
                
                [self parseData:results];
                
            }
        }];
    }else
    {
                   [HUD removeFromSuperview];
            
            
            UIAlertView * alertView1 = [[UIAlertView alloc]initWithTitle:@"JPL Pune 2017" message:@"Seems you are not connected to internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alertView1 show];
            
        
        
        
        
        
        
    }
    
}


-(void)parseData:(NSDictionary *)data
{
    NSArray *results = [data objectForKey:@"results"];
    
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    
    [formatter1 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    formatter1.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    
    [formatter1 setDateFormat:@"MMMM dd,yyyy"];

    CGFloat height = [UIScreen mainScreen].bounds.size.height - 105;
    CGFloat calheight = 0.25 * height;
   if (results.count > 0) {
        NSDictionary *result = [results objectAtIndex:0];
       if ([result objectForKey:@"description"]) {
           NSString *desc=[result objectForKey:@"description"];
           NSMutableString *html = [NSMutableString stringWithString: @"<html><body style='margin:0px'>"];
           [html appendString:[NSString stringWithFormat:@"<img src =%@ width = 100&#37; ><div style='padding:5&#37;'>",[[result objectForKey:@"image"]objectForKey:@"url"]]];
                                     
           NSDictionary *fixtures=[result objectForKey:@"fixturesId"];
           if ([result objectForKey:@"title"])
           {
               [html appendString:[NSString stringWithFormat:@"<h1 style='font-family:Helvetica'>%@</h1>",[result objectForKey:@"title"]]];
               if ([fixtures objectForKey:@"team1Id"])
               {
                  
                   NSString *team1 = [[[fixtures objectForKey:@"team1Id"]objectForKey:@"longName"]stringByAppendingString:@" v "];
                   if ([fixtures objectForKey:@"team2Id"])
                   {
                       
                       
                       NSString *team2 = [[fixtures objectForKey:@"team2Id"]objectForKey:@"longName"];
                       NSString *teams=[team1 stringByAppendingString:team2];
                       
                       self.titleLabel.text=teams;
                       
                       
                       NSString *name =[fixtures objectForKey:@"matchName"];
                       
                       if ([[fixtures objectForKey:@"dateOfMatch"]objectForKey:@"iso"]) {
                           NSDate *dateOfMatch =[self utcTimeToDate:[[fixtures objectForKey:@"dateOfMatch"]objectForKey:@"iso"]];
                           NSString *date = [formatter1 stringFromDate:dateOfMatch];
                           NSString *final1 = [name stringByAppendingString:@", "];
                           
                           NSString *stadium = [[[fixtures objectForKey:@"stadiumId"]objectForKey:@"stadiumName"]stringByAppendingString:@", "];
                           
                           NSString *final = [[final1 stringByAppendingString:stadium]stringByAppendingString:date];
                           [html appendString:[NSString stringWithFormat:@"<small style='font-family:Helvetica;color:#555555'>%@</small>",final]];
                           
                       }
                       
                       
                       
                       
                   }
                   
               }
           
           }
           [html appendString:desc];
           
           [html appendString:@"</div></body></html>"];
           [_webView loadHTMLString:html baseURL:nil];
           
                      

           
       }
   }
    
    
    
}
- (NSDate *)utcTimeToDate:(NSString *)utcTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:utcTime];
    return dateFromString;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
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
