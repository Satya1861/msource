//
//  CenterPanelViewController.m
//  Reuters
//
//  Created by Priya on 30/01/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import "CenterPanelViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "PushNotificationViewController.h"
#import "WebsiteViewController.h"
#import "DownloadViewController.h"
#import "MoviePlayerViewController.h"

#import "UIView+Toast.h"
#import "TeamMembersViewController.h"
#import "SLCircularProgressView.h"
#import "SHPieChartView.h"
#import "HMSegmentedControl.h"
@interface CenterPanelViewController ()
{
    NSInteger dayClicked;
    BOOL isTeamMembers;
    HMSegmentedControl *segmentedControl1;
    long selectedSegment;
}
@end

@implementation CenterPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedSegment = 0;
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.isNextView = NO;
    
    networkAC = [NetworkAccessor shareNetworkAccessor];
    dataAC = [DataAccessor shareDataAccessor];
    
    dataArr = [[NSMutableArray alloc] init];
    tab1Arr = [[NSMutableArray alloc] init];
    tab2Arr = [[NSMutableArray alloc] init];
    
    fileNameArray = [[NSMutableArray alloc] init];
    
    sortedDays = [[NSMutableArray alloc] init];
    sections = [[NSMutableDictionary alloc] init];
    
    sortedDays1 = [[NSMutableArray alloc] init];
    sections1 = [[NSMutableDictionary alloc] init];
    
    allSpeakersArr = [[NSArray alloc] init];
    
    selDownload = [[Download alloc] init];
    
    currentUser = [dataAC loggedInUser];
    
    
    
    topImg.hidden=NO;
    self.day1Width.constant=[UIScreen mainScreen].bounds.size.width/2;
    self.day2Width.constant=[UIScreen mainScreen].bounds.size.width/2;
    [self.scheduleView updateConstraintsIfNeeded];
    searchText.hidden = YES;
    [searchText addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
    self.backImage.hidden=true;
    self.menuImg.hidden = false;
    
    [timer invalidate];
    timer = nil;
    dayClicked=0;
    switch (app.selIndex) {
        case 1:
        {
            self.eventTableViewTop.constant=180;
            self.scheduleView.hidden= NO;
            titleLabel.text = @"SCHEDULE";
            quesSpeaker.hidden = YES;
            eventTableView.hidden = NO;
            raiseLabel.hidden = YES;
            searchBtn.hidden = YES;
            searchImg.hidden = YES;
            downloadTableView.hidden = YES;
            buttonView.hidden = YES;
        }
            break;
        case 4:
        {
            
           errorView.hidden = NO;
            self.eventTableViewTop.constant=90;
            self.scheduleView.hidden= YES;
            titleLabel.text = @"TEAMS";
            quesSpeaker.hidden = YES;
            raiseLabel.hidden = YES;
            eventTableView.hidden = NO;
            searchBtn.hidden = NO;
            searchImg.hidden = NO;
            downloadTableView.hidden = YES;
            buttonView.hidden = YES;
        }
            break;
            
            
        default:
            break;
    }
    [self setSegmentControlView];
    [self getData];
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
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    [self getData];
   // [eventTableView reloadData];
    
}

-(void)getData
{
    HUD = [[MBProgressHUD alloc] init];
     HUD.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:HUD];
    HUD.delegate = self;
   
    [HUD show:YES];
    
    switch (app.selIndex) {
       
        case 4:
        {
            if (selectedSegment == 1) {
                NSFileManager *fileManage =[NSFileManager defaultManager];
                NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                if([networkAC internetConnectivity])
                {
                    [networkAC getZonalTeam:^(NSInteger status, NSDictionary *results) {
                        if(status)
                        {
                             [HUD removeFromSuperview];
                            NSString *fileName = @"ZonalTeam";
                            NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
                            [results writeToFile:filePath atomically:YES];
                            [self parseData:results];
                        }
                    }];
                }else
                {
                    NSString *dataPath = [documentDirectory stringByAppendingPathComponent:@"ZonalTeam"];
                    
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
                        if(app.selIndex == 5)
                            [quesSpeaker reloadData];
                        else
                            [eventTableView reloadData];
                    }
                }
            }
            else
            {
                NSFileManager *fileManage =[NSFileManager defaultManager];
                NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                if([networkAC internetConnectivity])
                {
                    [networkAC getSpeaker:^(NSInteger status, NSDictionary *results) {
                        if(status)
                        {
                            NSString *fileName = @"Speaker";
                            NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
                            [results writeToFile:filePath atomically:YES];
                            [self parseData:results];
                        }
                    }];
                }else
                {
                    NSString *dataPath = [documentDirectory stringByAppendingPathComponent:@"Speaker"];
                    
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
                        if(app.selIndex == 5)
                            [quesSpeaker reloadData];
                        else
                            [eventTableView reloadData];
                    }
                }
            }
           
            break;
        }
            
            
        default:
            break;
    }
}

-(void)parseData : (NSDictionary *)results
{
    [dataArr removeAllObjects];
    [tab1Arr removeAllObjects];
    [tab2Arr removeAllObjects];
    
    [sortedDays removeAllObjects];
    [sections removeAllObjects];
    
    [sortedDays1 removeAllObjects];
    [sections1 removeAllObjects];
    
    switch (app.selIndex) {
        
            
        case 4:
        {
            NSArray *result = [results objectForKey:@"results"];
            for(NSDictionary *dict in result)
            {
                Speaker *speaker = [dataAC getSpeaker:dict];
                [dataArr addObject:speaker];
            }
            
            if (dataArr.count == 0) {
                if (selectedSegment == 1) {
                    [self.view makeToast:@"There are no zonal teams added" duration:1.5 position:CSToastPositionBottom];
                    [eventTableView reloadData];
                }
            }
            else
            {
            for (Speaker *sp in dataArr)
            {
                
                NSDictionary *group = sp.groupId;
                
                NSString *alphabet = [group objectForKey:@"name"];
                
                // If we don't yet have an array to hold the events for this day, create one
                NSMutableArray *speakerWithAlphabet = [sections objectForKey:alphabet];
                if (speakerWithAlphabet == nil) {
                    speakerWithAlphabet = [NSMutableArray array];
                    // Use the reduced date as dictionary key to later retrieve the event list this day
                    [sections setObject:speakerWithAlphabet forKey:alphabet];
                }
                
                // Add the event to the list for this day
                [speakerWithAlphabet addObject:sp];
            }
            
            // Create a sorted list of days
            NSArray *unsortedDays = [sections allKeys];
            sortedDays = [[NSMutableArray alloc] initWithArray:[unsortedDays sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]] ;
            
            if(app.selIndex == 5)
                [quesSpeaker reloadData];
            else
                [eventTableView reloadData];
            [HUD removeFromSuperview];
            
            allSpeakersArr = [dataArr mutableCopy];
            }
            break;
        }
            
            
        
        default:
            break;
    }
    
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.view layoutIfNeeded];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    searchImg.image = [UIImage imageNamed:@"search-icon.png"];
    searchText.hidden = YES;
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
    _hcVC=[self.storyboard instantiateViewControllerWithIdentifier:@"HostCityViewController"];
    [_hcVC.imageAutomaticSlide stop];
    
    if(self.isNextView)
    {
        switch (app.selIndex) {
            case 4:
            case 5:
            {
                self.isNextView = NO;
                [self getData];
                [downloadTableView reloadData];
                if([dataArr count] == 0)
                {
                    
                    errorView.hidden = NO;
                }else
                {
                     
                    if(isFirstTab)
                    {
                        if([tab1Arr count] == 0)
                        {
                            [timer invalidate];
                            timer = nil;
                        }else
                            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reloadSurveys) userInfo:nil repeats:YES];
                    }
                }
                [HUD removeFromSuperview];
            }
                break;
            default:
                break;
        }
    }else
    {
         
    }
}

-(void)viewDidAppear:(BOOL)animated
{[[UIDevice currentDevice] setValue:
  [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                             forKey:@"orientation"];
    
    
    if(self.isNextView)
    {
        self.isNextView = NO;
        HUD = [[MBProgressHUD alloc] init];
         HUD.mode = MBProgressHUDModeIndeterminate;
        [self.view addSubview:HUD];
        HUD.delegate = self;
       
        [HUD show:YES];
        if([dataArr count] == 0)
        {
            
            errorView.hidden = NO;
            //  errLabel.text = @"Seems you are not connected to internet";
        }else
        {
             
            switch (app.selIndex) {
                case 1:
                
                case 5:
                case 4:
                {
                    if(app.selIndex == 4)
                        [quesSpeaker reloadData];
                    else
                        [eventTableView reloadData];
                    [HUD removeFromSuperview];
                }
                    break;
                case 6:
                {
                    [downloadTableView reloadData];
                    [HUD removeFromSuperview];
                }
                    break;
                default:
                    break;
            }
        }
    }else
    {
         
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [timer invalidate];
    timer = nil;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //     Get the new view controller using [segue destinationViewController].
    //     Pass the selected object to the new view controller.
    
    self.isNextView = YES;
    if([[segue identifier] isEqualToString:@"scheduleDetails"])
    {
        NSIndexPath *indexPath = [eventTableView indexPathForSelectedRow];
        NSDate *dateRepresentingThisDay = [sortedDays objectAtIndex:dayClicked];
        NSArray *eventsOnThisDay = [sections objectForKey:dateRepresentingThisDay];
        
    }
    
    if([[segue identifier] isEqualToString:@"speakerDetails"])
    {
        NSIndexPath *indexPath = [eventTableView indexPathForSelectedRow];
        NSString *alphabet = [sortedDays objectAtIndex:indexPath.section];
        NSArray *speakerWithAlphabet = [sections objectForKey:alphabet];
        //        SpeakerDetailViewController *vc = segue.destinationViewController;
        //        vc.selSpeaker = [speakerWithAlphabet objectAtIndex:indexPath.row];
    }
    
    if([[segue identifier] isEqualToString:@"downloadFile"])
    {
        DownloadViewController *vc = segue.destinationViewController;
        vc.dFile = selDownload;
        vc.path = selDownloadPath;
    }
    
    if([[segue identifier] isEqualToString:@"moviePlayer"])
    {
        MoviePlayerViewController *mv = segue.destinationViewController;
        mv.path = selDownloadPath;
    }
    
    if([[segue identifier] isEqualToString:@"speakerListToQuestion"])
    {
        NSIndexPath *indexPath = [quesSpeaker indexPathForSelectedRow];
        NSString *alphabet = [sortedDays objectAtIndex:indexPath.section];
        NSArray *speakerWithAlphabet = [sections objectForKey:alphabet];
            }
    
    }

#pragma mark - UITextField

-(void)textFieldDidChange:(UITextField *)textField {
    
    NSArray *temp;
    [dataArr removeAllObjects];
    [sortedDays removeAllObjects];
    [sections removeAllObjects];
    
    if([searchText.text isEqualToString:@""])
    {
        [dataArr addObjectsFromArray:allSpeakersArr];
    }else
    {
        temp = [[NSArray alloc] initWithArray:allSpeakersArr];
        
        for (Speaker *sp in temp) {
            
            NSRange r = [sp.teamName rangeOfString:searchText.text options:NSCaseInsensitiveSearch];
            if(r.location != NSNotFound)
            {
                [dataArr addObject:sp];
            }
        }
    }
    
    if([dataArr count] == 0)
    {
        [dataArr addObjectsFromArray:allSpeakersArr];
        for (Speaker *sp in dataArr)
        {
            NSDictionary *group = sp.groupId;
            
            NSString *alphabet = [group objectForKey:@"name"];
            // If we don't yet have an array to hold the events for this day, create one
            NSMutableArray *speakerWithAlphabet = [sections objectForKey:alphabet];
            if (speakerWithAlphabet == nil) {
                speakerWithAlphabet = [NSMutableArray array];
                // Use the reduced date as dictionary key to later retrieve the event list this day
                [sections setObject:speakerWithAlphabet forKey:alphabet];
            }
            
            // Add the event to the list for this day
            [speakerWithAlphabet addObject:sp];
        }
        
        // Create a sorted list of days
        NSArray *unsortedDays = [sections allKeys];
        sortedDays = [[NSMutableArray alloc] initWithArray:[unsortedDays sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]] ;
        
        
        [eventTableView reloadData];
    }else
    {
         
        for (Speaker *sp in dataArr)
        {
            NSDictionary *group = sp.groupId;
            
            NSString *alphabet = [group objectForKey:@"name"];
            // If we don't yet have an array to hold the events for this day, create one
            NSMutableArray *speakerWithAlphabet = [sections objectForKey:alphabet];
            if (speakerWithAlphabet == nil) {
                speakerWithAlphabet = [NSMutableArray array];
                // Use the reduced date as dictionary key to later retrieve the event list this day
                [sections setObject:speakerWithAlphabet forKey:alphabet];
            }
            
            // Add the event to the list for this day
            [speakerWithAlphabet addObject:sp];
        }
        
        // Create a sorted list of days
        NSArray *unsortedDays = [sections allKeys];
        sortedDays = [[NSMutableArray alloc] initWithArray:[unsortedDays sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]] ;
        
        
            [eventTableView reloadData];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (NSDate *)formatStringToTime:(NSString *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *formattedDate;
    
    [dateFormatter setDateFormat:@"hh:mm"];
    
    formattedDate = [dateFormatter dateFromString:date];
    
    return formattedDate;
}

#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    switch (app.selIndex) {
      
            
       
        case 4:
        {
            
            cell = [eventTableView dequeueReusableCellWithIdentifier:@"prototype3"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            
            NSString *alphabet = [sortedDays objectAtIndex:indexPath.section];
            NSArray *speakerWithAlphabet = [sections objectForKey:alphabet];
            Speaker *sp = [speakerWithAlphabet objectAtIndex:indexPath.row];
            
            UIImageView *profileImg = (UIImageView *)[cell viewWithTag:1];
            
            profileImg.layer.cornerRadius = 35.5f;
            profileImg.layer.masksToBounds = YES;
            
            [profileImg sd_setImageWithURL:[NSURL URLWithString:sp.teamLogo] placeholderImage:[UIImage imageNamed:@"team_default"]];
            
            UILabel *label1 = (UILabel *)[cell viewWithTag:2];
            
           CGRect frame1 = label1.frame;
//            
//            float ht1 = [self heightForLabel:sp.teamName :frame1.size.width-10.0 andfont:[UIFont boldSystemFontOfSize:17.0]];
//            
//            float diff1 = 0;
//            if(ht1 > 22.0)
//                diff1 = ht1 - frame1.size.height;
//            
//            frame1.size.height = ht1;
//            
//            label1.numberOfLines = (int)ht1;
//            
//            [label1 setFrame:frame1];
            
            label1.text = sp.teamName;
            
            
            UILabel *label2 = (UILabel *)[cell viewWithTag:3];
            
            CGRect frame2 = label2.frame;
            
            float ht2 = [self heightForLabel:sp.sponspor :frame2.size.width-10.0 andfont:[UIFont systemFontOfSize:19.0]];
            
            float diff2 = 0;
            if(ht2 > 22.0)
                diff2 = ht2 - frame2.size.height;
            
                frame2.size.height = ht2;
//            
//            frame2.origin.y += frame2.origin.y + diff1;
//            
//            label2.numberOfLines = (int)ht2;
            
            [label2 setFrame:frame2];
            
            label2.text = sp.sponspor;
            
            
            
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (app.selIndex) {
        case 1:
        {
            break;
        }
        case 6:
        {
            break;
        }
            
        
        case 4:
        {
            NSString *alphabet = [sortedDays objectAtIndex:indexPath.section];
            NSArray *speakerWithAlphabet = [sections objectForKey:alphabet];
            Speaker *sp = [speakerWithAlphabet objectAtIndex:indexPath.row];
            
            float ht1 = [self heightForLabel:sp.teamName :tableView.frame.size.width-110.0 andfont:[UIFont boldSystemFontOfSize:17.0]];
            
            float ht2 = [self heightForLabel:sp.sponspor :tableView.frame.size.width-110.0 andfont:[UIFont systemFontOfSize:19.0]];
            
            float ht3 = [self heightForLabel:@"" :tableView.frame.size.width-100.0 andfont:[UIFont systemFontOfSize:19.0]];
            
            CGFloat finalHeight;
            
            if(ht1 > 22.0)
            {
                if(ht2 > 22.0)
                {
                    if(ht3 > 22.0)
                        finalHeight = 90 + ht1 + ht2 + ht3 - 66.0;
                    else
                        finalHeight = 90 + ht1 + ht2 - 44.0;
                }else
                {
                    if(ht3 > 22.0)
                        finalHeight = 90 + ht1 + ht3 - 44.0;
                    else
                        finalHeight = 90 + ht1 - 22.0;
                }
                
            }else
            {
                if(ht2 > 22.0)
                {
                    if(ht3 > 22.0)
                        finalHeight = 90 + ht2 + ht3 - 44.0;
                    else
                        finalHeight = 90 + ht2 - 22.0;
                }else
                {
                    if(ht3 > 22.0)
                        finalHeight = 90 + ht3 - 22.0;
                    else
                        finalHeight = 90;
                }
            }
            
            
            
            return 82;
        }
            break;
        default:
            return 0;
            break;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.isNextView)
    {
        return 0;
    }else
    {
        switch (app.selIndex) {
         
           
            
            case 4:
            {
                
                
                if([sortedDays count] != 0)
                {
                    
                    NSString *alphabet = [sortedDays objectAtIndex:section];
                    NSArray *speakerWithAlphabet = [sections objectForKey:alphabet];
                    
                    return [speakerWithAlphabet count];
                }else
                    return 0;
                
            }
                break;
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.isNextView)
    {
        return 0;
    }else
    {
        switch (app.selIndex) {
            case 1:
            {
                if (sortedDays) {
                    return 1;
                    break;
                }
                
            }
            case 6:
            {
                
                return [sortedDays count];
                break;
            }
            
            case 4:
            {
                
                return [sortedDays count];
            }
                break;
             
            default:
            {
                return 1;
            }
                break;
        }
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (app.selIndex) {
        case 1:
        {
            //scheduleDetails
            [self performSegueWithIdentifier:@"scheduleDetails" sender:self];
        }
            break;
        case 4:
        {
            NSString *alphabet = [sortedDays objectAtIndex:indexPath.section];
            NSArray *speakerWithAlphabet = [sections objectForKey:alphabet];
            Speaker *sp = [speakerWithAlphabet objectAtIndex:indexPath.row];
            TeamMembersViewController *tvc=[self.storyboard instantiateViewControllerWithIdentifier:@"TeamMembersViewController"];
            tvc.teamObj = sp.objectId;
            [self.navigationController pushViewController:tvc animated:true];
            //speakerDetails
            //  [self performSegueWithIdentifier:@"listSpeakers" sender:self];
            // [self performSegueWithIdentifier:@"speakerDetails" sender:self];
        }
            break;
            
                  
            
            
        default:
            break;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    switch (app.selIndex) {
        case 1:
        {
            
        }
        case 6:
        {
            NSDate *dateRepresentingThisDay = [sortedDays objectAtIndex:section];
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            [formatter1 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            formatter1.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
            
            [formatter1 setDateFormat:@"EEEE,dd MMM yyyy"];
            
            NSArray *str =  [[formatter1 stringFromDate:dateRepresentingThisDay] componentsSeparatedByString:@","];
            NSString *sectionHeader = [NSString stringWithFormat:@"%@, %@",[[str objectAtIndex:0]uppercaseString],[str objectAtIndex:1]];
            
            return sectionHeader;
        }
            break;
       
        case 4:
        {
            NSString *str=@"Group ";
            NSString *alphabet = [str stringByAppendingString:[sortedDays objectAtIndex:section]];
            
            return alphabet;
        }
            break;
            //        case 4:
            //        case 5:
            //        {
            //            if(isFirstTab)
            //            {
            //                if([sortedDays count] != 0 && [sortedDays count] > section)
            //                {
            //                NSDate *dateRepresentingThisDay = [sortedDays objectAtIndex:section];
            //                NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            //                [formatter1 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            //                formatter1.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
            //
            //                [formatter1 setDateFormat:@"EEEE,dd MMM yyyy"];
            //
            //                NSArray *str =  [[formatter1 stringFromDate:dateRepresentingThisDay] componentsSeparatedByString:@","];
            //                NSString *sectionHeader = [NSString stringWithFormat:@"%@, %@",[[str objectAtIndex:0]uppercaseString],[str objectAtIndex:1]];
            //               // [sectionHeader]
            //                return sectionHeader;
            //                }else
            //                    return nil;
            //            }else
            //            {
            //                if([sortedDays1 count] != 0)
            //                {
            //                NSDate *dateRepresentingThisDay = [sortedDays1 objectAtIndex:section];
            //                NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            //                [formatter1 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            //                formatter1.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
            //
            //                [formatter1 setDateFormat:@"EEEE,dd MMM yyyy"];
            //
            //                NSArray *str =  [[formatter1 stringFromDate:dateRepresentingThisDay] componentsSeparatedByString:@","];
            //                NSString *sectionHeader = [NSString stringWithFormat:@"%@, %@",[[str objectAtIndex:0]uppercaseString],[str objectAtIndex:1]];
            //
            //                return sectionHeader;
            //                }else
            //                    return nil;
            //            }
            //        }
            //            break;
        default:
        {
            return nil;
        }
            break;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (app.selIndex) {
        case 1:
        {
        }
        case 6:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"prototype2"];
            if (cell == nil)
            {
                cell = [[UITableViewCell   alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"prototype2"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            
            UILabel *label1 = (UILabel *)[cell viewWithTag:1];
            
            NSDate *dateRepresentingThisDay = [sortedDays objectAtIndex:section];
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            [formatter1 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            formatter1.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
            
            [formatter1 setDateFormat:@"EEEE,dd MMM yyyy"];
            
            NSArray *strArr =  [[formatter1 stringFromDate:dateRepresentingThisDay] componentsSeparatedByString:@","];
            
            NSString *str = [NSString stringWithFormat:@"%@, %@",[[strArr objectAtIndex:0]uppercaseString],[strArr objectAtIndex:1]];
            
            label1.text = str;
            
            return cell;
        }
            break;
        case 4:
        case 5:
        {
            UITableViewCell *cell = [eventTableView dequeueReusableCellWithIdentifier:@"prototype2"];
            if (cell == nil)
            {
                cell = [[UITableViewCell   alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"prototype2"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            
            UILabel *label1 = (UILabel *)[cell viewWithTag:1];
            
            NSString *str=@"Group ";
            NSString *alphabet = [str stringByAppendingString:[sortedDays objectAtIndex:section]];
            
            label1.text = alphabet;
            
            return cell;
        }
            break;
            //        case 4:
            //        case 5:
            //        {
            //            if(isFirstTab)
            //            {
            //                if([sortedDays count] != 0 && [sortedDays count] > section)
            //                {
            //                UITableViewCell *cell = [eventTableView dequeueReusableCellWithIdentifier:@"prototype2"];
            //                if (cell == nil)
            //                {
            //                    cell = [[UITableViewCell   alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"prototype2"];
            //                }
            //                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //                cell.contentView.backgroundColor = [UIColor clearColor];
            //                cell.backgroundColor = [UIColor clearColor];
            //
            //                UILabel *label1 = (UILabel *)[cell viewWithTag:1];
            //
            //                NSDate *dateRepresentingThisDay = [sortedDays objectAtIndex:section];
            //                NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            //                [formatter1 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            //                formatter1.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
            //
            //                [formatter1 setDateFormat:@"EEEE,dd MMM yyyy"];
            //
            //                NSArray *strArr =  [[formatter1 stringFromDate:dateRepresentingThisDay] componentsSeparatedByString:@","];
            //
            //                NSString *str = [NSString stringWithFormat:@"%@, %@",[[strArr objectAtIndex:0]uppercaseString],[strArr objectAtIndex:1]];
            //                  //  [label1.font fontWithSize:8.0];
            //                    [label1 setFont:[UIFont systemFontOfSize:13.0]];
            //                label1.text = str;
            //
            //                return cell;
            //                }else
            //                    return nil;
            //            }else
            //            {
            //                if([sortedDays1 count] != 0)
            //                {
            //                UITableViewCell *cell = [eventTableView dequeueReusableCellWithIdentifier:@"prototype2"];
            //                if (cell == nil)
            //                {
            //                    cell = [[UITableViewCell   alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"prototype2"];
            //                }
            //                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //                cell.contentView.backgroundColor = [UIColor clearColor];
            //                cell.backgroundColor = [UIColor clearColor];
            //
            //                UILabel *label1 = (UILabel *)[cell viewWithTag:1];
            //
            //                NSDate *dateRepresentingThisDay = [sortedDays1 objectAtIndex:section];
            //                NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            //                [formatter1 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            //                formatter1.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
            //
            //                [formatter1 setDateFormat:@"EEEE,dd MMM yyyy"];
            //
            //                NSArray *strArr =  [[formatter1 stringFromDate:dateRepresentingThisDay] componentsSeparatedByString:@","];
            //
            //                NSString *str = [NSString stringWithFormat:@"%@, %@",[[strArr objectAtIndex:0]uppercaseString],[strArr objectAtIndex:1]];
            //                    [label1 setFont:[UIFont systemFontOfSize:13.0]];
            //                label1.text = str;
            //
            //                return cell;
            //                }else
            //                    return nil;
            //            }
            //        }
            //            break;
        default:
        {
            return nil;
        }
            
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (app.selIndex) {
        case 1:
        {
            return 0;
        }
            //        case 4:
            //        case 5:
            //        {
            //            //return 25;
            //        }
        case 6:
        {
            return 30;
        }
            break;
        
        case 4:
        {
            return 32;
        }
            break;
        default:
            return 10;
            break;
            
    }
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

#pragma mark - onClickEvents

- (void)onClickCellBtn:(id)sender
{
    
    
    
    
    
}

- (IBAction)onClickMenuBtn:(id)sender
{
    [timer invalidate];
    timer = nil;
    [self.sidePanelController showLeftPanelAnimated:YES];
}

- (IBAction)onClickSearch:(id)sender
{
    searchText.text = @"";
    if(searchText.hidden)
    {
        searchText.hidden = NO;
        searchImg.image = [UIImage imageNamed:@"cancel.png"];
    }else
    {
        searchText.text = @"";
        searchImg.image = [UIImage imageNamed:@"search-icon.png"];
        [self textFieldDidChange:searchText];
        searchText.hidden = YES;
    }
}

- (IBAction)onClickTabBtn:(id)sender
{
   }

#pragma mark - Reload Survey

-(void)updateTimingForSurvey:(Survey *)sc :(UILabel*)label4 :(SHPieChartView *)concentricPieChart :(UIImageView*)coverImg :(int)totalMins{
    
  }

-(void)updateTiming:(Quiz *)quiz :(UILabel*)label4 :(SHPieChartView *)concentricPieChart :(UIImageView*)coverImg :(int)totalMins{
    
  
}

- (NSDateComponents *)timeRemainingString:(NSDate *)targetDate {
    
    NSDate* sourceDate = [NSDate date];
    
    if (sourceDate == targetDate) {
        return nil;
    } else {
        NSDateComponents *components    = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitDay   | NSCalendarUnitHour  |NSCalendarUnitMinute| NSCalendarUnitSecond) fromDate:sourceDate toDate:targetDate options:0];
        
        if([components hour] <=0 && [components day] <=0
           &&[components minute] <=0 && [components second] <=0)
        {
            return nil;
        }else
        {
            return components;
        }
        
    }
}

-(void)reloadSurveys
{
    [downloadTableView reloadData];
    
}

#pragma mark - Download Event


-(void)downloads:(Download *)obj
{
    __block BOOL inDisable;
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    
    NSFileManager *fileManage =[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray * typeArray = [obj.fileUrl componentsSeparatedByString:@"."];
    NSString* contentType;
    if ([[typeArray lastObject] isEqualToString:@"ppt"]) {
        contentType = @"ppt";
    }
    else if ([[typeArray lastObject] isEqualToString:@"xls"])
    {
        contentType = @"xls";
    }
    else if ([[typeArray lastObject] isEqualToString:@"doc"])
    {
        contentType = @"doc";
    }
    else if ([[typeArray lastObject] isEqualToString:@"pptx"])
    {
        contentType = @"pptx";
    }
    else
        contentType = [typeArray lastObject];
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",obj.objectId,contentType];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    if ([fileManage fileExistsAtPath:filePath])
    {
        
        
        if([contentType isEqualToString:@"mov"]|| [contentType isEqualToString:@"mp4"]|| [contentType isEqualToString:@"avi"])
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:fileName];
            
            [self playMovie:dataPath];
        }
        else{
            selDownload = obj;
            selDownloadPath = filePath;
            [self performSegueWithIdentifier:@"downloadFile" sender:self];
        }
    }
    else
    {
        
        BOOL inDownloading = YES;
        
        if (inDownloading)
        {
            UIAlertView * alertView1 = [[UIAlertView alloc]initWithTitle:@"JPL Pune 2017" message:@"The file is downloading.Please Wait." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            alertView1.tag = 2;
            [self.view addSubview:alertView1];
            [alertView1 show];
            //    [fileNameArray addObject:filePath];
            
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[obj.fileUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                 {
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         inDisable = [data writeToFile:filePath atomically:YES];
                         // [fileNameArray removeObject:filePath];
                         if (inDisable)
                         {
                             if (contentTypeName != nil) {
                                 contentTypeName = nil;
                             }
                             if (alertfileName != nil) {
                                 alertfileName = nil;
                             }
                             if (alertfilePath != nil) {
                                 alertfilePath = nil;
                             }
                             
                             contentTypeName = [NSString stringWithString:contentType];
                             alertfilePath = [NSString stringWithString:filePath];
                             alertfileName = [NSString stringWithString:fileName];
                             
                             NSString * message = [NSString stringWithFormat:@"%@ has been downloaded",obj.name];
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 {
                                     
                                     [tab1Arr removeObject:obj];
                                     [tab2Arr insertObject:obj atIndex:0];
                                     if([tab1Arr count] == 0)
                                     {
                                         isFirstTab = NO;
                                         deSel1Img.hidden = YES;
                                         deSel2Img.hidden = NO;
                                         btn2.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
                                         [btn2 setTitleColor:[UIColor colorWithRed:0/255.0 green:54/255.0 blue:99/255.0 alpha:1] forState:UIControlStateNormal];
                                         btn1.titleLabel.font = [UIFont systemFontOfSize:18.0];
                                         [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                     }
                                 }
                                 [downloadTableView reloadData];
                                 UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"JPL Pune 2017" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                 [self.view addSubview:alertView];
                                 alertView.tag = 1;
                                 [alertView show];
                             });
                             
                         }
                     });
                 }];
            });
        }
    }
}
- (IBAction)openSide:(id)sender {
    [timer invalidate];
    timer = nil;
    [self.sidePanelController showLeftPanelAnimated:YES];
}
- (IBAction)day1Clicked:(id)sender {
    dayClicked=0;
    self.day1Label.layer.cornerRadius=10;
    self.day1Label.layer.borderWidth=1.0f;
    self.day1Label.layer.borderColor=[UIColor whiteColor].CGColor;
    self.day1Label.layer.masksToBounds=YES;
    self.day1Label.textColor=[UIColor blackColor];
    self.day2Label.layer.borderWidth=1.0f;
    self.day2Label.layer.cornerRadius=10;
    self.day2Label.layer.borderColor=[UIColor whiteColor].CGColor;
    self.day2Label.layer.masksToBounds=YES;
    self.day2Label.textColor=[UIColor whiteColor];
    self.day2Label.backgroundColor=[UIColor clearColor];
    self.day1Label.backgroundColor=[UIColor whiteColor];
    [eventTableView reloadData];
    
    
    
}
- (IBAction)day2Clicked:(id)sender {
    dayClicked=1;
    self.day1Label.layer.cornerRadius=10;
    self.day1Label.layer.borderWidth=1.0f;
    self.day1Label.layer.borderColor=[UIColor whiteColor].CGColor;
    self.day1Label.textColor=[UIColor whiteColor];
    self.day1Label.layer.masksToBounds=YES;
    self.day1Label.backgroundColor=[UIColor clearColor];
    
    
    self.day2Label.textColor=[UIColor blackColor];
    self.day2Label.layer.borderWidth=1.0f;
    self.day2Label.layer.cornerRadius=10;
    self.day2Label.layer.borderColor=[UIColor whiteColor].CGColor;
    self.day2Label.layer.masksToBounds=YES;
    self.day2Label.backgroundColor=[UIColor whiteColor];
    [eventTableView reloadData];
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIDeviceOrientationPortrait;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [alertView resignFirstResponder];
            });
        }
    }
    else if (alertView.tag == 2)
    {
        if (buttonIndex == 0)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [alertView resignFirstResponder];
            });
        }
    }
}

-(void)playMovie:(NSString *)path
{
    dispatch_async(dispatch_get_main_queue(), ^{
        selDownloadPath = path;
        [self performSegueWithIdentifier:@"moviePlayer" sender:self];
    });
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    [self.navigationController popViewControllerAnimated:YES];
    if ([player respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
    }
}
- (IBAction)openTwitter:(id)sender {
    WebsiteViewController *vv =[self.storyboard instantiateViewControllerWithIdentifier:@"WebsiteViewController"];
    [self.navigationController pushViewController:vv animated:true];
    
    
    
}

- (IBAction)openNotifciations:(id)sender {
    
    PushNotificationViewController *vv =[self.storyboard instantiateViewControllerWithIdentifier:@"PushNotificationViewController"];
    [self.navigationController pushViewController:vv animated:true];
}
@end
