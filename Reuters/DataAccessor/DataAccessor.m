//
//  DataAccessor.m
//  DemoSharingApp
//
//  Created by Priya on 27/01/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import "DataAccessor.h"


@implementation DataAccessor

id dataAccessor;

+(DataAccessor *)shareDataAccessor{
    
    if(dataAccessor == nil){
        
        dataAccessor = [[DataAccessor alloc] init];
        
    }
    return dataAccessor;
}



-(void)saveUserCredentials:(PFObject *)userDetails{
    
    
    
    AppUser *user = [[AppUser alloc] init];
    user.userName = userDetails[@"userName"];
    user.contactNo = userDetails[@"contactNo"];
    user.email = userDetails[@"email"];
    user.fullName=userDetails[@"fullName"];
    user.password = userDetails[@"password"];
  //  user.facebookLink=userDetails[@"facebookLink"];
    user.isPending = [userDetails[@"isPending"] boolValue];
    if([userDetails[@"objectId"] length] == 0)
    {
        PFQuery *query = [PFQuery queryWithClassName:@"AppUser"];
        if(userDetails[@"fullName"])
        {
        [query whereKey:@"fullName" equalTo:userDetails[@"fullName"]];
        NSArray *userArr = [query findObjects];
       
        PFObject *AppUser = [userArr objectAtIndex:0];
        user.objectId = AppUser.objectId;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
        [defaults setObject:data forKey:@"LoggedInCredentials"];
        
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else if (userDetails[@"email"])
        {
            [query whereKey:@"email" equalTo:userDetails[@"email"]];
            NSArray *userArr = [query findObjects];
           
            PFObject *AppUser = [userArr objectAtIndex:0];
            user.objectId = AppUser.objectId;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
            [defaults setObject:data forKey:@"LoggedInCredentials"];
            
           
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }else
    {
        user.objectId = userDetails[@"objectId"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
        
        [defaults setObject:data forKey:@"LoggedInCredentials"];
        
        
       
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)updateUserCredentials:(AppUser *)user{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
    [defaults setObject:data forKey:@"LoggedInCredentials"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CurrentUserUpdated" object:nil];
    
}

-(AppUser *)loggedInUser{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"LoggedInCredentials"] != nil) {
       
        NSData *data = [defaults valueForKey:@"LoggedInCredentials"];
        
        AppUser *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return user;
    }
    else
        return  nil;
}

- (Schedule *)getSchedule:(NSDictionary *)scheduleData
{
    
    
    Schedule *sc = [[Schedule alloc] init];
    
    
    if([scheduleData objectForKey:@"objectId"])
        sc.objectId = [scheduleData objectForKey:@"objectId"];
    
    

  
    if([scheduleData objectForKey:@"team1Id"])
        sc.team1Id = [scheduleData objectForKey:@"team1Id"];

    if([scheduleData objectForKey:@"team2Id"])
        sc.team2Id = [scheduleData objectForKey:@"team2Id"];
    
    if([scheduleData objectForKey:@"groupId"])
        sc.groupId = [scheduleData objectForKey:@"groupId"];
    
    if([scheduleData objectForKey:@"stadiumId"])
        sc.stadiumId = [scheduleData objectForKey:@"stadiumId"];
    
    
    NSDictionary *date = [scheduleData objectForKey:@"dateOfMatch"];
    NSString *dateOfMatch = [date objectForKey:@"iso"];
    
    sc.dateOfMatch=[self utcTimeToDate:dateOfMatch];

    
    
    
    if([scheduleData objectForKey:@"matchName"])
    {
        sc.matchName = [scheduleData objectForKey:@"matchName"];
        
    }
    
    sc.isPast = [[scheduleData objectForKey:@"isPast"] boolValue];
    


    return sc;
}

-(Results *)getResults:(NSDictionary *)resultsData
{
    Results *sc = [[Results alloc] init];
    
    
    if([resultsData objectForKey:@"objectId"])
        sc.objectId = [resultsData objectForKey:@"objectId"];
    
    if([resultsData objectForKey:@"team"])
        sc.team = [resultsData objectForKey:@"team"];
    
    if([resultsData objectForKey:@"stadiumName"])
        sc.stadiumName = [resultsData objectForKey:@"stadiumName"];
    
    if([resultsData objectForKey:@"matchName"])
        sc.matchName = [resultsData objectForKey:@"matchName"];
    
    
    if([resultsData objectForKey:@"fixtureId"])
        sc.fixtureId= [resultsData objectForKey:@"fixtureId"];
    
    if([resultsData objectForKey:@"msg"])
        sc.msg= [resultsData objectForKey:@"msg"];
    
    NSDictionary *date = [resultsData objectForKey:@"dateOfMatch"];
    NSString *dateOfMatch = [date objectForKey:@"iso"];
    
    sc.dateOfMatch=[self utcTimeToDate:dateOfMatch];
    
    
    if([resultsData objectForKey:@"isReportEntered"])
    {
    sc.isReportEntered = [[resultsData objectForKey:@"isReportEntered"] boolValue];
    }
    
    
    
    
    
    return sc;
  
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
-(NSString*)nurUhrzeigFromDate:(NSDate*)date
{
    NSDateFormatter *nurTag = [[NSDateFormatter alloc] init];
    // [nurTag setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"IST"]];
    [nurTag setDateFormat:@"HHmmss"];
    
    
    NSTimeInterval time=(5*60*60)+(30*60);
    NSDate *fDate=  [date dateByAddingTimeInterval:-time];
    return [nurTag stringFromDate:fDate];
}
- (NSDate *)formatStringToTime:(NSString *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *formattedDate;
    
    [dateFormatter setDateFormat:@"hh:mm"];
    
    formattedDate = [dateFormatter dateFromString:date];
    
    return formattedDate;
}
- (Session *)getSession:(PFObject *)sessionData
{
    [sessionData pinInBackground];

    Session *session = [[Session alloc] init];
    
    session.objectId = sessionData.objectId;
    
    if([sessionData objectForKey:@"name"])
        session.name = [sessionData objectForKey:@"name"];
    
    if([sessionData objectForKey:@"speaker"])
        session.speaker = [sessionData objectForKey:@"speaker"];
    
    NSDate *utcStartTime = [sessionData objectForKey:@"startTime"];
    NSTimeInterval time=(5*60*60)+(30*60);
    NSDate *fDate=  [utcStartTime dateByAddingTimeInterval:-time];
    
    session.startTime = fDate;
    NSDate *utcEndTime = [sessionData objectForKey:@"endTime"];
    
    NSTimeInterval time1=(5*60*60)+(30*60);
    NSDate *fDate1=  [utcEndTime dateByAddingTimeInterval:-time1];
    
    session.endTime = fDate1;
    
    PFObject *scheduleData = [sessionData objectForKey:@"scheduleType"];
    if(scheduleData)
    {
        Schedule *prog = [self getSchedule:scheduleData];
        session.scheduleType = prog;
    }
    
    return session;
}

- (Speaker *)getSpeaker:(NSDictionary *)speakerData
{
    Speaker *sp = [[Speaker alloc] init];
    
    if([speakerData objectForKey:@"objectId"])
        sp.objectId = [speakerData objectForKey:@"objectId"];
    
    
    if([speakerData objectForKey:@"owner"])
        sp.owner = [speakerData objectForKey:@"owner"];
    
    if([speakerData objectForKey:@"sponspor"])
        sp.sponspor = [speakerData objectForKey:@"sponspor"];
    
    if([speakerData objectForKey:@"longName"])
        sp.teamName = [speakerData objectForKey:@"longName"];
    
//    if([speakerData objectForKey:@"contactNo"])
//        sp.contactNo = [speakerData objectForKey:@"contactNo"];
    
    if([speakerData objectForKey:@"teamLogo"] && [speakerData objectForKey:@"teamLogo"])
    {
        NSDictionary *imgUrl=[speakerData objectForKey:@"teamLogo"];
        sp.teamLogo = [imgUrl objectForKey:@"url"];
    }
    if([speakerData objectForKey:@"sponsorImage"] && [speakerData objectForKey:@"sponsorImage"])
    {
        NSDictionary *imgUrl=[speakerData objectForKey:@"sponsorImage"];
        sp.sponsorImage = [imgUrl objectForKey:@"url"];
    }
    if([speakerData objectForKey:@"groupId"])
        sp.groupId = [speakerData objectForKey:@"groupId"];
    
    return sp;
}

-(Member *)getMember:(NSDictionary *)memberData
{
    Member *sp = [[Member alloc] init];
    
    sp.objectId = [memberData objectForKey:@"objectId"];
    
    if([memberData objectForKey:@"memberName"])
        sp.memberName = [memberData objectForKey:@"memberName"];
    
    if([memberData objectForKey:@"role"])
        sp.role = [memberData objectForKey:@"role"];
    
    if([memberData objectForKey:@"teamId"])
        sp.teamId = [memberData objectForKey:@"teamId"];
    
    //    if([speakerData objectForKey:@"contactNo"])
    //        sp.contactNo = [speakerData objectForKey:@"contactNo"];
    
    if([[memberData objectForKey:@"profilePic"]objectForKey:@"url"] && [[memberData objectForKey:@"profilePic"]objectForKey:@"url"])
    {
        sp.profilePic=[[memberData objectForKey:@"profilePic"]objectForKey:@"url"];
        
    }
    
    return sp;

}
-(HostCity *)getHostCity:(NSDictionary *)hostCityData
{
    HostCity *sp = [[HostCity alloc] init];
    if([hostCityData objectForKey:@"objectId"])
        sp.objectId = [hostCityData objectForKey:@"objectId"];
    
    if([hostCityData objectForKey:@"description"])
        sp.description = [hostCityData objectForKey:@"description"];
    
    if([hostCityData objectForKey:@"name"])
        sp.name = [hostCityData objectForKey:@"name"];
    
    if([hostCityData objectForKey:@"isActive"])
        sp.isActive = [[hostCityData objectForKey:@"isActive"]boolValue];
    
    
    return sp;

}
-(FeedbackQuestion *)getFeedbackQuestions:(PFObject *)feedbackData
{
    FeedbackQuestion *sp = [[FeedbackQuestion alloc] init];
   
    sp.objectId = feedbackData.objectId;
    
    
    if([feedbackData objectForKey:@"question"])
        sp.question = [feedbackData objectForKey:@"question"];
    
    return sp;
}

- (Download *)getDownload:(PFObject *)downloadData
{
    Download *dow = [[Download alloc] init];
    
    dow.objectId = downloadData.objectId;
    
    if([downloadData objectForKey:@"name"])
        dow.name = [downloadData objectForKey:@"name"];
    
    if([downloadData objectForKey:@"downloadFile"])
    {
        PFFile *fUrl=[downloadData objectForKey:@"downloadFile"];
        dow.fileUrl=fUrl.url;
    }
    
    if([downloadData objectForKey:@"scheduleType"])
    {
       PFObject *scheduleData = [downloadData objectForKey:@"scheduleType"];
       // NSString *sc = scheduleData.objectId;
        dow.scheduleType = scheduleData.objectId;
    }
    
    return dow;
}

- (Photos *)getPhoto:(PFObject *)photoData
{
    Photos *ph = [[Photos alloc] init];
   
    
    ph.objectId = photoData.objectId;
    
    if([photoData objectForKey:@"name"])
        ph.name = [photoData objectForKey:@"name"];
    
    if([photoData objectForKey:@"youtubeId"])
        ph.youtubeId = [photoData objectForKey:@"youtubeId"];
    
    if([photoData objectForKey:@"url"])
        ph.url = [photoData objectForKey:@"url"];
    
    if([photoData objectForKey:@"isImage"])
        ph.isImage = [[photoData objectForKey:@"isImage"]boolValue];
    
    if([photoData objectForKey:@"imageFile"])
        
    {
        PFFile *imageFile=[photoData objectForKey:@"imageFile"];
        ph.imageFile = imageFile.url;
    }
    
    
    
    
    
    return ph;
}
-(HostCityImage *)getHostCityPhoto:(PFObject *)hostCityImageData
{
    HostCityImage *ph = [[HostCityImage alloc] init];
    
    
    ph.objectId = hostCityImageData.objectId;
    
    if([hostCityImageData objectForKey:@"hostCity"])
        ph.hostCity = [hostCityImageData objectForKey:@"hostCity"];
    
    if([hostCityImageData objectForKey:@"image"])
        
    {
        PFFile *imageFile=[hostCityImageData objectForKey:@"image"];
        ph.image = imageFile.url;
    }
    
    
    return ph;

}

-(Survey *)getSurvey:(PFObject *)surveyData
{
    Survey *survey = [[Survey alloc] init];
    
    
    survey.objectId=surveyData.objectId;
    
    
    
    
    if([surveyData objectForKey:@"name"])
        survey.name = [surveyData objectForKey:@"name"];
    
    if([surveyData objectForKey:@"questions"])
        survey.questions = [surveyData objectForKey:@"questions"];
    
    NSDate *utcStartTime = [surveyData objectForKey:@"startDate"];
    NSDate *utcEndTime = [surveyData objectForKey:@"endDate"];
    
    if(utcStartTime)
        survey.startDate = utcStartTime;
    if(utcEndTime)
        survey.endDate = utcEndTime;

    
    NSArray *arr = [[NSArray alloc] init];
    arr = [surveyData objectForKey:@"completed"];
    AppUser * u = [self loggedInUser];
    if([arr containsObject:u.objectId])
        survey.done = YES;
    else
        survey.done = NO;
    
    return survey;
}





- (SurveyQuestion *)getSurveyQues:(PFObject *)surveyQuesData
{
    SurveyQuestion *ques = [[SurveyQuestion alloc] init];
    
    ques.optionsArr = [[NSMutableArray alloc] init];
    
    ques.objectId = surveyQuesData.objectId;
    
    if([surveyQuesData objectForKey:@"options"])
    {
        NSArray * arr = [surveyQuesData objectForKey:@"options"];
        [ques.optionsArr addObjectsFromArray:arr];
    }
    
    if([surveyQuesData objectForKey:@"number"])
        ques.questionNum = [surveyQuesData objectForKey:@"number"];
    
    if([surveyQuesData objectForKey:@"question"])
        ques.question = [surveyQuesData objectForKey:@"question"];
    
    if([surveyQuesData objectForKey:@"imageUrl"])
    {
        PFFile *imgUrl=[surveyQuesData objectForKey:@"imageUrl"];
        ques.image =imgUrl.url;
    }
    
  
    PFObject *surveyData1 = [surveyQuesData objectForKey:@"surveyType"];
   
    if(surveyData1)
    {
        
        ques.surveyType=surveyData1.objectId;
    }
    return ques;
}

- (Quiz *)getQuiz:(NSDictionary *)quizData
{
    Quiz *quiz = [[Quiz alloc] init];
    
    if([quizData objectForKey:@"objectId"])
        quiz.objectId = [quizData objectForKey:@"objectId"];
    
    if([quizData objectForKey:@"option1"])
        quiz.option1 = [quizData objectForKey:@"option1"];
    if([quizData objectForKey:@"option2"])
        quiz.option2 = [quizData objectForKey:@"option2"];
    if([quizData objectForKey:@"option3"])
        quiz.option3 = [quizData objectForKey:@"option3"];
    if([quizData objectForKey:@"option4"])
        quiz.option4 = [quizData objectForKey:@"option4"];
    
    if([quizData objectForKey:@"question"])
        quiz.question = [quizData objectForKey:@"question"];
    
    
    NSDictionary *date = [quizData objectForKey:@"dateOfQuestion"];
    NSString *dateOfMatch = [date objectForKey:@"iso"];
    
    quiz.dateOfQuestion=[self utcTimeToDate:dateOfMatch];
    
    
    

    return quiz;
}

- (QuizQuestion *)getQuizQues:(PFObject *)quizQuesData
{
    QuizQuestion *ques = [[QuizQuestion alloc] init];
    
    ques.optionsArr = [[NSMutableArray alloc] init];
    
    ques.objectId = quizQuesData.objectId;
    
    if([quizQuesData objectForKey:@"options"])
    {
        NSArray * arr = [quizQuesData objectForKey:@"options"];
        [ques.optionsArr addObjectsFromArray:arr];
    }
    
    if([quizQuesData objectForKey:@"number"])
        ques.questionNum = [quizQuesData objectForKey:@"number"];
    
    if([quizQuesData objectForKey:@"question"])
        ques.question = [quizQuesData objectForKey:@"question"];
    
    if([quizQuesData objectForKey:@"imageUrl"])
    {
        PFFile *imgUrl=[quizQuesData objectForKey:@"imageUrl"] ;
        ques.image =imgUrl.url;
    }
    
    
    if([quizQuesData objectForKey:@"answer"])
        ques.answer = [quizQuesData objectForKey:@"answer"];
    
   PFObject *quizData = [quizQuesData objectForKey:@"quizType"];
   if(quizData)
    {
        ques.quizType = quizData.objectId;
    }
    
    return ques;
}

@end
