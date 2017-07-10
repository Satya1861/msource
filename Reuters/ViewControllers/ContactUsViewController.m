//
//  ContactUsViewController.m
//  Reuters
//
//  Created by Priya Talreja on 02/09/16.
//  Copyright © 2016 Scriptlanes. All rights reserved.
//

#import "ContactUsViewController.h"
#import "PushNotificationViewController.h"
#import "WebsiteViewController.h"
@interface ContactUsViewController ()
{
    MBProgressHUD *HUD;
    NetworkAccessor *networkAC;
    DataAccessor *dataAC;
}
@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    HUD = [[MBProgressHUD alloc] init];
     HUD.mode = MBProgressHUDModeIndeterminate;
    networkAC = [NetworkAccessor shareNetworkAccessor];
    dataAC = [DataAccessor shareDataAccessor];
    [self getData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getData
{
    [self.view addSubview:HUD];
    HUD.delegate = self;
    
    [HUD show:YES];
    NSFileManager *fileManage =[NSFileManager defaultManager];
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    
    
    
    
    if([networkAC internetConnectivity])
    {
        
        [networkAC getHelpDesk:^(NSInteger status, NSDictionary *results) {
            if(status)
            {
                [HUD removeFromSuperview];
                NSString *fileName = @"help";
                NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
                [results writeToFile:filePath atomically:YES];
                [self parseData:results];
                
            }
        }];
    }else
    {
        NSString *dataPath = [documentDirectory stringByAppendingPathComponent:@"help"];
        
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
        if ([result objectForKey:@"details"]) {
            NSString *contactus = [result objectForKey:@"details"];
            NSMutableString *html = [NSMutableString stringWithString: @"<html><body><div>"];
            [html appendString:contactus];
            [html appendString:@"</div></body></html>"];
            [_webView loadHTMLString:html baseURL:nil];
        }
    }
    
    
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    
    [self.view addSubview:HUD];
    HUD.delegate = self;
    
    [HUD show:YES];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HUD removeFromSuperview];
}


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}
-(BOOL)shouldAutorotate
{
    return NO;
}
- (IBAction)phtapped:(id)sender {
    NSString *phonenumber=[@"telprompt://" stringByAppendingString:@"02026052654"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phonenumber]];
}
- (IBAction)leftOpen:(id)sender {
     [self.sidePanelController showLeftPanelAnimated:YES];
}
- (IBAction)y1Clicked:(id)sender {
    NSString *phonenumber=[@"telprompt://" stringByAppendingString:self.y1.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phonenumber]];
}
- (IBAction)y2Clicked:(id)sender {
    NSString *phonenumber=[@"telprompt://" stringByAppendingString:self.y2.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phonenumber]];
}
- (IBAction)y3Clicked:(id)sender {
    NSString *phonenumber=[@"telprompt://" stringByAppendingString:self.y3.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phonenumber]];
}

- (IBAction)y4Clicked:(id)sender {
    NSString *phonenumber=[@"telprompt://" stringByAppendingString:self.y4.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phonenumber]];
}

- (IBAction)t1:(id)sender {
    NSString *phonenumber=[@"telprompt://" stringByAppendingString:@"01143126262"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phonenumber]];
}

- (IBAction)t2:(id)sender {
    NSString *phonenumber=[@"telprompt://" stringByAppendingString:@"01143126200"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phonenumber]];
}

- (IBAction)emailClicked:(id)sender {
    if ([MFMailComposeViewController canSendMail] == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"This device is not able to send mail,please sign in with your mail" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController * picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            
            
            NSMutableArray *clientEmailIds=[[NSMutableArray alloc]init];
            [clientEmailIds addObject:@"info@credai.org"];
            [picker setToRecipients:clientEmailIds];
            
        
            [self presentViewController:picker animated:YES completion:NULL];
        
    }

}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
   
    [self dismissViewControllerAnimated:YES completion:NULL];
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
