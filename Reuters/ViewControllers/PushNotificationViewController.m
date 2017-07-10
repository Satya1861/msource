//
//  PushNotificationViewController.m
//  Reuters
//
//  Created by Priya Talreja on 17/08/16.
//  Copyright © 2016 Scriptlanes. All rights reserved.
//

#import "PushNotificationViewController.h"
#import "XCDYouTubeKit.h"
#import "XCDYouTubeVideoPlayerViewController.h"
@interface PushNotificationViewController ()
{
    NSMutableArray *alertss;
}
@end

@implementation PushNotificationViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    networkAC = [NetworkAccessor shareNetworkAccessor];
    dataAC = [DataAccessor shareDataAccessor];
    HUD = [[MBProgressHUD alloc] init];
     HUD.mode = MBProgressHUDModeIndeterminate;
    [self getData];
    
    
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
        
        [networkAC getNotifications:^(NSInteger status, NSDictionary *results) {
            if(status)
            {
                NSString *fileName = @"notifications";
                NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
                [results writeToFile:filePath atomically:YES];
                [self parseData:results];
                
            }
        }];
    }else
    {
        NSString *dataPath = [documentDirectory stringByAppendingPathComponent:@"notifications"];
        
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
        alertss=[[NSMutableArray alloc]initWithArray:results];
    }
    [self.tableView reloadData];
    [HUD removeFromSuperview];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (alertss) {
        return [alertss count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell1";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *dic=[alertss objectAtIndex:indexPath.row];
    
    UIImageView *img=(UIImageView *)[cell viewWithTag:1];
    img.layer.cornerRadius = 45/2;
    img.layer.masksToBounds = true;
    UILabel *question=(UILabel *)[cell viewWithTag:2];
    NSString *data=[dic objectForKey:@"msg"];
    question.text = data;
    
    CGRect frame1 = question.frame;
    
    float ht1 = [self heightForLabel:data :self.view.frame.size.width-100 andfont:[UIFont systemFontOfSize:17.0]];
    
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        if (data.length < 32) {
            ht1 = 21;
        }
        if (data.length > 32 && data.length < 65 ) {
            ht1 = 42;
        }
        if (data.length > 65) {
            ht1 = 63;
        }
        
    }
    else
    {
        if (data.length < 37) {
            ht1 = 21;
        }
        if (data.length > 37 && data.length < 74 ) {
            ht1 = 42;
        }
        if (data.length > 74) {
            ht1 = 63;
        }
    }
    
    frame1.size.height = ht1;
    [question setFrame:frame1];
    
    UILabel *time=(UILabel *)[cell viewWithTag:3];
    NSDate *date=[self utcTimeToDate:[dic objectForKey:@"createdAt"]];
    time.text=[self formatTime:date];
    
    
    
    
    return cell;
    
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=[alertss objectAtIndex:indexPath.row];
    NSString *data=[dic objectForKey:@"msg"];
    //  NSString *data=[alertss objectAtIndex:indexPath.row];
    //
    float ht;
    
    ht = [self heightForLabel:data :self.view.frame.size.width-100 andfont:[UIFont systemFontOfSize:17.0]];
    NSLog(@"%f",ht);
    
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        if (data.length < 32) {
            ht = 21;
        }
        if (data.length > 32 && data.length < 65 ) {
            ht = 42;
        }
        if (data.length > 65) {
            ht = 63;
        }
        
    }
    else
    {
        if (data.length < 37) {
            ht = 21;
        }
        if (data.length > 37 && data.length < 74 ) {
            ht = 42;
        }
        if (data.length > 74) {
            ht = 63;
        }
    }
    float ht3;
    ht3 = ht + 60;
    
    NSInteger finalCellHeight = ht3;
    
    return finalCellHeight;
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}
-(BOOL)shouldAutorotate
{
    return NO;
}

- (IBAction)openSide:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark - Data formatter methods


- (NSString *)formatTime:(NSDate *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd MMM yyyy, hh:mm a"];
    NSString *formattedTime = [dateFormatter stringFromDate:time];
    return formattedTime;
}


- (float)heightForLabel:(NSString *)text :(float)labelWidth andfont:(UIFont*)textFont
{
    CGSize constraint = CGSizeMake(labelWidth, 20000.0f);
    
    CGRect textRect = [text boundingRectWithSize:constraint
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:textFont}
                                         context:nil];
    
    CGSize size = textRect.size;
    
    CGFloat height = size.height;
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=[alertss objectAtIndex:indexPath.row];
    NSString *data=[dic objectForKey:@"msg"];
    NSString *linkData=[dic objectForKey:@"link"];
    
    if (linkData) {
        if ([linkData isEqualToString:@""] || [linkData isEqualToString:@" "]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"JPL Pune 2017" message:data delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
        }
        else
        {
            XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:linkData];
            // videoPlayerViewController.moviePlayer.backgroundPlaybackEnabled = true;
            
            // videoPlayerViewController.preferredVideoQualiti = self.lowQualitySwitch.on ? @[ @(XCDYouTubeVideoQualitySmall240), @(XCDYouTubeVideoQualityMedium360) ] : nil;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:videoPlayerViewController.moviePlayer];
            [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
        }
    }
    else
    {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification" message:data delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
}


#pragma mark - Notifications

- (void) moviePlayerPlaybackDidFinish:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:notification.object];
    MPMovieFinishReason finishReason = [notification.userInfo[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
    if (finishReason == MPMovieFinishReasonPlaybackError)
    {
        NSString *title = NSLocalizedString(@"Video Playback Error", @"Full screen video error alert - title");
        NSError *error = notification.userInfo[XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey];
        NSString *message = [NSString stringWithFormat:@"%@\n%@ (%@)", error.localizedDescription, error.domain, @(error.code)];
        NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Full screen video error alert - cancel button");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alertView show];
    }
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
