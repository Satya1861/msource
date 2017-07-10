//
//  MainViewController.m
//  Reuters
//
//  Created by Priya Talreja on 30/01/17.
//  Copyright © 2017 Scriptlanes. All rights reserved.
//

#import "MainViewController.h"
#import <EventKit/EventKit.h>
#import "MatchTableViewCell.h"
#import "Schedule.h"
#import "UIView+Toast.h"
#import "ResultDetailsViewController.h"
#import "PushNotificationViewController.h"
#import "WebsiteViewController.h"
@interface MainViewController ()
{
    NSDateFormatter *formatter;
    NSDateFormatter *dayFormat;
    NSDateFormatter *dateFormat;
    NSDateFormatter *monthFormat;
    NSMutableArray *datesOfMatch;
    int selectedDateIndex;
    BOOL isResults;

}



@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HUD = [[MBProgressHUD alloc] init];
     HUD.mode = MBProgressHUDModeIndeterminate;
    networkAC = [NetworkAccessor shareNetworkAccessor];
    dataAC = [DataAccessor shareDataAccessor];
    
    dataArr = [[NSMutableArray alloc] init];
    sortedDays = [[NSMutableArray alloc] init];
    sections = [[NSMutableDictionary alloc] init];
    
    sortedDays1 = [[NSMutableArray alloc] init];
    sections1 = [[NSMutableDictionary alloc] init];
    currentUser = [dataAC loggedInUser];

    formatter=[[NSDateFormatter alloc]init];
    
    
    monthFormat = [[NSDateFormatter alloc] init];
    
    [monthFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    monthFormat.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    
    [monthFormat setDateFormat:@"MMMM"];
    
    dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    dateFormat.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    
    [dateFormat setDateFormat:@"dd"];

    
    NSUserDefaults *defaults1=[NSUserDefaults standardUserDefaults];
    if ([defaults1 objectForKey:@"isResults"]) {
        isResults=[[defaults1 objectForKey:@"isResults"]boolValue];
    }
    [self updateAuthorizationStatusToAccessEventStore];
    self.decimg.hidden = true;
     self.incImg.hidden = true;
   // [self deleteReminderForToDoItem:@"T20"];
    if (isResults) {
        self.titleLabel.text = @"RESULTS";
        [self getResultsData];
    }
    else
    {
        self.titleLabel.text = @"FIXTURES";
        [self getData];
    }
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (EKEventStore *)eventStore {
    if (!_eventStore) {
        _eventStore = [[EKEventStore alloc] init];
    }
    return _eventStore;
}

-(void)getResultsData
{
    [self.view addSubview:HUD];
    HUD.delegate = self;
   
    [HUD show:YES];

    NSFileManager *fileManage =[NSFileManager defaultManager];
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    
    
    
    
    if([networkAC internetConnectivity])
    {
        
        [networkAC getResults:^(NSInteger status, NSDictionary *results) {
            if(status)
            {
                NSString *fileName = @"results";
                NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
                [results writeToFile:filePath atomically:YES];
                [self parseResultsData:results];
                
            }
        }];
    }else
    {
        NSString *dataPath = [documentDirectory stringByAppendingPathComponent:@"results"];
        
        if ([fileManage fileExistsAtPath:dataPath])
        {
            [HUD removeFromSuperview];
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:dataPath];
            [self parseResultsData:dict];
        }else
        {
            [HUD removeFromSuperview];
            
            
            UIAlertView * alertView1 = [[UIAlertView alloc]initWithTitle:@"JPL Pune 2017" message:@"Seems you are not connected to internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alertView1 show];
            
        }
        
        
        
        
        
    }

}

-(void)parseResultsData:(NSDictionary *)results
{
    [dataArr removeAllObjects];
    
    
    [sortedDays removeAllObjects];
    [sections removeAllObjects];
    
    [sortedDays1 removeAllObjects];
    [sections1 removeAllObjects];
    
     NSArray *result = [results objectForKey:@"result"];
    for(NSDictionary *dict in result)
    {
        Results *sc = [dataAC getResults:dict];
        [dataArr addObject:sc];

    }
    if (result.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"JPL Pune 2017"
                                                            message:@"No Results" delegate:nil
                                                  cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertView show];
    }
    else if (result.count >1)
    {
        self.decimg.hidden = false;
    }
    
    
    
    NSDateFormatter *formatter1;
    NSDateFormatter *formatter2;
    NSDateFormatter *formatter3;
    for (Schedule *sc in dataArr)
    {
        // Reduce event start date to date components (year, month, day)
        
        formatter1 = [[NSDateFormatter alloc] init];
        
        [formatter1 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        formatter1.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
        
        [formatter1 setDateFormat:@"EEEE,dd MMM yyyy"];
        formatter2 = [[NSDateFormatter alloc] init];
        
        [formatter2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        formatter2.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
        
        [formatter2 setDateFormat:@"MMMM"];
        
        formatter3 = [[NSDateFormatter alloc] init];
        
        [formatter3 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        formatter3.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
        
        [formatter3 setDateFormat:@"dd"];
        
        
        NSString *sectionTitle = [formatter1 stringFromDate:sc.dateOfMatch];
        
        NSDate *sectionDate = [formatter1 dateFromString:sectionTitle];
        
        // If we don't yet have an array to hold the events for this day, create one
        NSMutableArray *eventsOnThisDay = [sections objectForKey:sectionDate];
        
        
        if (eventsOnThisDay == nil) {
            eventsOnThisDay = [NSMutableArray array];
            // Use the reduced date as dictionary key to later retrieve the event list this day
            
            [sections setObject:eventsOnThisDay forKey:sectionDate];
        }
        
        
        
        // Add the event to the list for this day
        [eventsOnThisDay addObject:sc];
    }
    
    // Create a sorted list of days
    NSArray *unsortedDays = [sections allKeys];
    
    NSMutableArray *sD = [[NSMutableArray alloc] initWithArray:[unsortedDays sortedArrayUsingSelector:@selector(compare:)]] ;
    int ct = (int)sD.count;
    for (int i=ct-1; i>=0; i--) {
        NSDate *dates = [sD objectAtIndex:i];
        [sortedDays addObject:dates];
    }
   // sortedDays = [[NSMutableArray alloc] initWithArray:[unsortedDays sortedArrayUsingSelector:@selector(compare:)]] ;
    
    if ([sortedDays count]>0) {
        NSDate *dates=[sortedDays objectAtIndex:0];
        datesOfMatch = [[NSMutableArray alloc]initWithArray:sortedDays];
        
        self.month.text = [formatter2 stringFromDate:dates];
        self.date.text = [formatter3 stringFromDate:dates];
        selectedDateIndex = 0;
    }
    
    [self.tableView reloadData];
    [HUD removeFromSuperview];

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
        
        [networkAC getSchedule:^(NSInteger status, NSDictionary *results) {
            if(status)
            {
                [HUD removeFromSuperview];
                NSString *fileName = @"fixtures";
                NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
                [results writeToFile:filePath atomically:YES];
                [self parseData:results];
                
            }
        }];
    }else
    {
        
        [HUD removeFromSuperview];
        NSString *dataPath = [documentDirectory stringByAppendingPathComponent:@"fixtures"];
        
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

-(void)parseData : (NSDictionary *)results
{
    [dataArr removeAllObjects];
   
    
    [sortedDays removeAllObjects];
    [sections removeAllObjects];
    
    [sortedDays1 removeAllObjects];
    [sections1 removeAllObjects];
    
            NSArray *result = [results objectForKey:@"results"];
            if (result.count == 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"JPL Pune 2017"
                                                                    message:@"No Fixtures" delegate:nil
                                                          cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                    [alertView show];
 
            }
    else if(result.count > 1)
    {
         self.incImg.hidden = false;
    }
            for(NSDictionary *dict in result)
            {
                Schedule *sc = [dataAC getSchedule:dict];
                if (sc.isPast == NO) {
                    [dataArr addObject:sc];
                }
                
                
            }
            
            
            
    NSDateFormatter *formatter1;
    NSDateFormatter *formatter2;
    NSDateFormatter *formatter3;
            for (Schedule *sc in dataArr)
            {
                // Reduce event start date to date components (year, month, day)
                
                formatter1 = [[NSDateFormatter alloc] init];
                
                [formatter1 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                
                formatter1.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
                
                [formatter1 setDateFormat:@"EEEE,dd MMM yyyy"];
                formatter2 = [[NSDateFormatter alloc] init];
                
                [formatter2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                
                formatter2.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
                
                [formatter2 setDateFormat:@"MMMM"];
                
                formatter3 = [[NSDateFormatter alloc] init];
                
                [formatter3 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                
                formatter3.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
                
                [formatter3 setDateFormat:@"dd"];

                
                NSString *sectionTitle = [formatter1 stringFromDate:sc.dateOfMatch];
                
                NSDate *sectionDate = [formatter1 dateFromString:sectionTitle];
                
                // If we don't yet have an array to hold the events for this day, create one
                NSMutableArray *eventsOnThisDay = [sections objectForKey:sectionDate];
                
                
                if (eventsOnThisDay == nil) {
                    eventsOnThisDay = [NSMutableArray array];
                    // Use the reduced date as dictionary key to later retrieve the event list this day
                    
                    [sections setObject:eventsOnThisDay forKey:sectionDate];
                }
                
                
                NSArray *keys = [sections allKeys];
                                // Add the event to the list for this day
                [eventsOnThisDay addObject:sc];
            }
            
            // Create a sorted list of days
            NSArray *unsortedDays = [sections allKeys];
            sortedDays = [[NSMutableArray alloc] initWithArray:[unsortedDays sortedArrayUsingSelector:@selector(compare:)]] ;
            if ([sortedDays count]>0) {
                NSDate *dates=[sortedDays objectAtIndex:0];
                datesOfMatch = [[NSMutableArray alloc]initWithArray:sortedDays];
        
                self.month.text = [formatter2 stringFromDate:dates];
                self.date.text = [formatter3 stringFromDate:dates];
                selectedDateIndex = 0;
            }

            [self.tableView reloadData];
            [HUD removeFromSuperview];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if([sortedDays count] != 0)
    {
        NSDate *dateRepresentingThisDay;
        NSArray *eventsOnThisDay;
        if (selectedDateIndex > sortedDays.count) {
            dateRepresentingThisDay = [sortedDays objectAtIndex:sortedDays.count-1];
            eventsOnThisDay = [sections objectForKey:dateRepresentingThisDay];
            return [eventsOnThisDay count];
        }
        else if (selectedDateIndex < 0)
        {
            dateRepresentingThisDay = [sortedDays objectAtIndex:0];
            eventsOnThisDay = [sections objectForKey:dateRepresentingThisDay];
            return [eventsOnThisDay count];
            
        }
        else
        {
        dateRepresentingThisDay = [sortedDays objectAtIndex:selectedDateIndex];
        eventsOnThisDay = [sections objectForKey:dateRepresentingThisDay];
            return [eventsOnThisDay count];
        }
        
        
    }else
        return 0;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //  [tableView setSeparatorInset:UIEdgeInsetsZero];
    // [tableView setSeparatorStyle: UITableViewCellSeparatorStyleSingleLine];
    static NSString *CellIdentifier = @"matchCell";
    MatchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MatchTableViewCell" owner:self options:nil];
        cell = (MatchTableViewCell *)[nib objectAtIndex:0];
    }
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    
    [formatter1 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    formatter1.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    
    [formatter1 setDateFormat:@"MMM dd,yyyy"];

    NSDate *dateRepresentingThisDay;
    NSArray *eventsOnThisDay;
    if (selectedDateIndex > sortedDays.count) {
        dateRepresentingThisDay = [sortedDays objectAtIndex:sortedDays.count-1];
        eventsOnThisDay = [sections objectForKey:dateRepresentingThisDay];
        
    }
    else if (selectedDateIndex < 0)
    {
        dateRepresentingThisDay = [sortedDays objectAtIndex:0];
        eventsOnThisDay = [sections objectForKey:dateRepresentingThisDay];
        
        
    }
    else
    {
       dateRepresentingThisDay = [sortedDays objectAtIndex:selectedDateIndex];
        eventsOnThisDay = [sections objectForKey:dateRepresentingThisDay];
        
    }
    
    if (isResults) {
        
        
        cell.alertImg.hidden = YES;
        Results *res=[eventsOnThisDay objectAtIndex:indexPath.row];
        if (res.msg) {
            cell.venue.text=res.msg;
        }
        else
        {
            cell.venue.text=res.stadiumName;
        }
        
        NSString *date = [formatter1 stringFromDate:res.dateOfMatch];
        NSString *matchName =[res.matchName stringByAppendingString:@" - "];
        cell.matchName.text = [[matchName stringByAppendingString:date]uppercaseString];
        if (res.team) {
            if (res.team.count == 2) {
                for (int i=0; i<2; i++) {
                    NSDictionary *currTeam = [res.team objectAtIndex:i];
                    if ([currTeam objectForKey:@"teamName"] && [currTeam objectForKey:@"score"]) {
                        NSString *teamName=[[currTeam objectForKey:@"teamName"]stringByAppendingString:@"   "];
                        
                        NSNumber *scoreNumber = [currTeam objectForKey:@"score"];
                        NSString *score=[NSString stringWithFormat:@"%@",scoreNumber];
                    
                        
                        
                        NSString *finalStr;
                        NSString *temp = [teamName stringByAppendingString:score];
                        if([currTeam objectForKey:@"wickets"])
                        {
                            NSNumber *wicketNumber = [currTeam objectForKey:@"wickets"];
                        NSString *wickets=[NSString stringWithFormat:@"%@",wicketNumber];
                        NSString *t1=[temp stringByAppendingString:@"/"];
                            finalStr=[t1 stringByAppendingString:wickets];
                            
                            if ([currTeam objectForKey:@"overs"]) {
                                NSLog(@"%@",[currTeam objectForKey:@"overs"]);
                                NSNumber *oversNo =[currTeam objectForKey:@"overs"];
                                NSString *overs= [[NSString stringWithFormat:@"%.1f",[oversNo floatValue]]stringByAppendingString:@" Ovs"];
                                NSString *temp = [@" (" stringByAppendingString:overs];
                                NSString *temp1 = [temp stringByAppendingString:@")"];
                                finalStr = [finalStr stringByAppendingString:temp1];
                            }
                        }
                        else
                        {
                            finalStr = temp;
                        }
                        
                        
                        NSMutableAttributedString *strText = [[NSMutableAttributedString alloc] initWithString:finalStr];
                        NSArray *tempArr = [finalStr componentsSeparatedByString:@" "];
                        NSString *str;
                        if (tempArr.count>1) {
                            if (tempArr.count == 2) {
                                str=[tempArr objectAtIndex:0];
                            }
                            else
                            {
                                str=[[tempArr objectAtIndex:0] stringByAppendingString:[tempArr objectAtIndex:1]];
                            }
                            
                        [strText addAttribute:NSFontAttributeName
                                          value:[UIFont boldSystemFontOfSize:17.0]
                                            range:NSMakeRange(teamName.length, finalStr.length-teamName.length)];
                        }

                        if (i==0) {
                            cell.team1.attributedText=strText;
                        }
                        else
                        {
                            cell.team2.attributedText=strText;
                        }
                        
                    }
                }
                
            }
            

        }
        
        
    }
    else
    {
    Schedule *sc = [eventsOnThisDay objectAtIndex:indexPath.row];
    if ([sc.team1Id objectForKey:@"longName"]) {
        cell.team1.text=[[sc.team1Id objectForKey:@"longName"] uppercaseString];
    }
    if ([sc.team2Id objectForKey:@"longName"]) {
        cell.team2.text=[[sc.team2Id objectForKey:@"longName"]uppercaseString];
    }
    if ([sc.stadiumId objectForKey:@"stadiumName"]) {
        cell.venue.text=[sc.stadiumId objectForKey:@"stadiumName"];
    }
        cell.alertBtn.tag = indexPath.row;
    [cell.alertBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSString *date = [formatter1 stringFromDate:sc.dateOfMatch];
    NSString *matchName =[sc.matchName stringByAppendingString:@" - "];
    cell.matchName.text = [[matchName stringByAppendingString:date]uppercaseString];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    
    [formatter2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    formatter2.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    
    [formatter2 setDateFormat:@"hh:mm a"];
    
    NSString *time = [formatter2 stringFromDate:sc.dateOfMatch];
    
    if ([sc.stadiumId objectForKey:@"stadiumName"]) {
        if (time == nil) {
            cell.venue.text=[sc.stadiumId objectForKey:@"stadiumName"];
        }
        else
        {
            NSString *stadium = [[sc.stadiumId objectForKey:@"stadiumName"] stringByAppendingString:@" |"];
            NSString *timeOfmatch = [time stringByAppendingString:@""];
            cell.venue.text=[stadium stringByAppendingString:timeOfmatch];
        }
        
    }
    }

    return cell;
}



-(void)buttonClicked:(UIButton*)sender
{
    [self updateAuthorizationStatusToAccessEventStore];
    
    
    

    NSDate *dateRepresentingThisDay;
    NSArray *eventsOnThisDay;
    if (selectedDateIndex > sortedDays.count) {
        dateRepresentingThisDay = [sortedDays objectAtIndex:sortedDays.count-1];
        eventsOnThisDay = [sections objectForKey:dateRepresentingThisDay];
        
    }
    else if (selectedDateIndex < 0)
    {
        dateRepresentingThisDay = [sortedDays objectAtIndex:0];
        eventsOnThisDay = [sections objectForKey:dateRepresentingThisDay];
        
        
    }
    else
    {
        dateRepresentingThisDay = [sortedDays objectAtIndex:selectedDateIndex];
        eventsOnThisDay = [sections objectForKey:dateRepresentingThisDay];
        
    }

    if (!self.isAccessToEventStoreGranted)
        return;
    Schedule *sc = [eventsOnThisDay objectAtIndex:sender.tag];
    
    
    EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];
    reminder.title = sc.matchName;
    reminder.calendar=self.calendar;
    
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth|NSCalendarUnitHour|NSCalendarUnitMinute)fromDate:sc.dateOfMatch];
    NSInteger year  = [weekdayComponents year];
    NSInteger month = [weekdayComponents month];
    NSInteger day = [weekdayComponents day];
    NSInteger time=[weekdayComponents hour];
    NSInteger minutes = [weekdayComponents minute];
    NSDateComponents *timeZoneComps=[[NSDateComponents alloc] init];
    
    
        // NSInteger time=[weekdayComponents hour];
        [timeZoneComps setYear:year];
        [timeZoneComps setHour:time];
        [timeZoneComps setMinute:minutes];
        [timeZoneComps setSecond:00];
        [timeZoneComps setDay:day];
        [timeZoneComps setMonth:month];
        
    
    
    
    reminder.dueDateComponents = timeZoneComps;
    if([networkAC internetConnectivity])
    {
        
        [networkAC getReminderHistory:sc.objectId :^(NSInteger status, NSDictionary *results) {
            if(status)
            {
                NSError *error = nil;
                NSArray *result = [results objectForKey:@"results"];
                if (result.count == 0) {
                    EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:sc.dateOfMatch];
                    
                    [reminder addAlarm:alarm];
                    BOOL success = [self.eventStore saveReminder:reminder
                                                          commit:YES
                                                           error:&error];
                    if (!success) {
                        NSLog(@"Error saving reminder: %@", [error localizedDescription]);
                    }
                    else
                    {
                        [self addReminderHistory:sc.objectId];
                        [self.view makeToast:@"Reminder added successfully" duration:1.5 position:CSToastPositionBottom];
                    }

                }
                else
                {
                     [self.view makeToast:@"Reminder has been already added!" duration:1.5 position:CSToastPositionBottom];
                }
                
            }
        }];
    }

    
}

-(void)addReminderHistory:(NSString *)fixtureId
{
    AppUser *user =[dataAC loggedInUser];
    
    if (fixtureId && user.objectId) {
        NSDictionary *parameters =
        @{ @"appUserId": @{ @"__type": @"Pointer", @"className": @"AppUser", @"objectId": user.objectId},
           @"fixturesId": @{ @"__type": @"Pointer", @"className": @"Fixtures", @"objectId": fixtureId } };
        
        if(networkAC.internetConnectivity)
        {
            [networkAC submitReminder:parameters :^(NSInteger status, NSDictionary *dict) {
                if (status) {
                    
                }
            }];
        }
    }
    
}
- (EKCalendar *)calendar {
    if (!_calendar) {
        
        // 1
        NSArray *calendars = [self.eventStore calendarsForEntityType:EKEntityTypeReminder];
        
        // 2
        NSString *calendarTitle = @"JPL Pune 2017";
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", calendarTitle];
        
        NSArray *filtered = [calendars filteredArrayUsingPredicate:predicate];
        
        if ([filtered count]) {
            _calendar = [filtered firstObject];
        } else {
            
            // 3
            _calendar = [EKCalendar calendarForEntityType:EKEntityTypeReminder eventStore:self.eventStore];
            _calendar.title = @"JPL Pune 2017";
            _calendar.source = self.eventStore.defaultCalendarForNewReminders.source;
            
            // 4
            NSError *calendarErr = nil;
            BOOL calendarSuccess = [self.eventStore saveCalendar:_calendar commit:YES error:&calendarErr];
            if (!calendarSuccess) {
                // Handle error
            }
        }
        
        
    }
    return _calendar;
}
- (void)updateAuthorizationStatusToAccessEventStore {
    // 2
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    
    switch (authorizationStatus) {
            // 3
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted: {
            self.isAccessToEventStoreGranted = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Access Denied"
                                                                message:@"This app doesn't have access to your Reminders." delegate:nil
                                                      cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alertView show];
           // [self.tableView reloadData];
            break;
        }
            
            // 4
        case EKAuthorizationStatusAuthorized:
            self.isAccessToEventStoreGranted = YES;
            //    [self.tableView reloadData];
            break;
            
            // 5
        case EKAuthorizationStatusNotDetermined: {
            //__weak RWTableViewController *weakSelf = self;
            [self.eventStore requestAccessToEntityType:EKEntityTypeReminder
                                            completion:^(BOOL granted, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    //   weakSelf.isAccessToEventStoreGranted = granted;
                                                    // [weakSelf.tableView reloadData];
                                                });
                                            }];
            break;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 142;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isResults) {
        NSDate *dateRepresentingThisDay;
        NSArray *eventsOnThisDay;
        if (selectedDateIndex > sortedDays.count) {
            dateRepresentingThisDay = [sortedDays objectAtIndex:sortedDays.count-1];
            eventsOnThisDay = [sections objectForKey:dateRepresentingThisDay];
            
        }
        else if (selectedDateIndex < 0)
        {
            dateRepresentingThisDay = [sortedDays objectAtIndex:0];
            eventsOnThisDay = [sections objectForKey:dateRepresentingThisDay];
            
            
        }
        else
        {
            dateRepresentingThisDay = [sortedDays objectAtIndex:selectedDateIndex];
            eventsOnThisDay = [sections objectForKey:dateRepresentingThisDay];
            
        }
        Results *res=[eventsOnThisDay objectAtIndex:indexPath.row];
        if (res.isReportEntered == true) {
            ResultDetailsViewController *rd =[self.storyboard instantiateViewControllerWithIdentifier:@"ResultDetailsViewController"];
            rd.fixture = res.fixtureId;
            [self.navigationController pushViewController:rd animated:true];
        }
        else
        {
             [self.view makeToast:@"There is no report added!" duration:1.0 position:CSToastPositionBottom];
        }
        

    }
}
- (IBAction)menuClicked:(id)sender {
    [self.sidePanelController showLeftPanelAnimated:YES];
}
- (IBAction)decreaseDate:(id)sender {
    if (isResults) {
        selectedDateIndex = selectedDateIndex + 1;
        if (selectedDateIndex >= [datesOfMatch count]) {
            selectedDateIndex = selectedDateIndex - 1;
            self.decimg.hidden = true;
        }
        else
        {
            if (selectedDateIndex == [datesOfMatch count]-1) {
                self.decimg.hidden = true;
            }
            else
            {
                self.decimg.hidden = false;
            }
            self.incImg.hidden=false;
            
            self.month.text = [monthFormat stringFromDate:[datesOfMatch objectAtIndex:selectedDateIndex]];
            self.date.text = [dateFormat stringFromDate:[datesOfMatch objectAtIndex:selectedDateIndex]];
            [self.tableView reloadData];
        }
 
    }
    else
    {
        selectedDateIndex = selectedDateIndex - 1;
        if (selectedDateIndex < 0) {
            self.decimg.hidden = true;
            selectedDateIndex = selectedDateIndex + 1;
        }
        else
        {
            if (selectedDateIndex == 0) {
                self.decimg.hidden = true;
            }
            else
            {
                self.decimg.hidden = false;
            }
            self.incImg.hidden = false;
            
            
            self.month.text = [monthFormat stringFromDate:[datesOfMatch objectAtIndex:selectedDateIndex]];
            self.date.text = [dateFormat stringFromDate:[datesOfMatch objectAtIndex:selectedDateIndex]];
            [self.tableView reloadData];
        }

    }
    
}
- (IBAction)incDate:(id)sender {
    
    if (isResults) {
        selectedDateIndex = selectedDateIndex - 1;
        if (selectedDateIndex < 0) {
            self.incImg.hidden = true;
            selectedDateIndex = selectedDateIndex + 1;
        }
        else
        {
            if (selectedDateIndex == 0) {
                self.incImg.hidden = true;
            }
            else
            {
                self.incImg.hidden = false;
            }
            self.decimg.hidden = false;
            
            
            self.month.text = [monthFormat stringFromDate:[datesOfMatch objectAtIndex:selectedDateIndex]];
            self.date.text = [dateFormat stringFromDate:[datesOfMatch objectAtIndex:selectedDateIndex]];
            [self.tableView reloadData];
        }

    }
    else
    {
        selectedDateIndex = selectedDateIndex + 1;
        if (selectedDateIndex >= [datesOfMatch count]) {
            selectedDateIndex = selectedDateIndex - 1;
            self.incImg.hidden = true;
        }
        else
        {
            if (selectedDateIndex == [datesOfMatch count]-1) {
                self.incImg.hidden = true;
            }
            else
            {
                self.incImg.hidden = false;
            }
            self.decimg.hidden=false;
            
            self.month.text = [monthFormat stringFromDate:[datesOfMatch objectAtIndex:selectedDateIndex]];
            self.date.text = [dateFormat stringFromDate:[datesOfMatch objectAtIndex:selectedDateIndex]];
            [self.tableView reloadData];
        }

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
