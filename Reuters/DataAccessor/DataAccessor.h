//
//  DataAccessor.h
//  DemoSharingApp
//
//  Created by Sonali on 27/01/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "AppUser.h"
#import "Schedule.h"
#import "Results.h"
#import "Speaker.h"
#import "Download.h"
#import "Photos.h"
#import "Session.h"
#import "Survey.h"
#import "SurveyQuestion.h"
#import "Quiz.h"
#import "QuizQuestion.h"
#import "Member.h"
#import "HostCity.h"
#import "HostCityImage.h"
#import "FeedbackQuestion.h"
@interface DataAccessor : NSObject
{
    NSMutableArray *results;
}

+ (DataAccessor *)shareDataAccessor;

- (AppUser *)loggedInUser;

- (void)saveUserCredentials:(PFObject *)userDetails;
- (void)updateUserCredentials:(AppUser *)user;
-(Results *)getResults:(NSDictionary *)resultsData;
- (Schedule *)getSchedule:(NSDictionary *)scheduleData;
- (Session *)getSession:(PFObject *)sessionData;
- (Speaker *)getSpeaker:(NSDictionary *)speakerData;
- (Member *)getMember:(NSDictionary *)memberData;
- (HostCity *)getHostCity:(NSDictionary *)hostCityData;
- (FeedbackQuestion *)getFeedbackQuestions:(PFObject *)feedbackData;
- (Download *)getDownload:(PFObject *)downloadData;
- (Photos *)getPhoto:(PFObject *)photoData;
- (HostCityImage *)getHostCityPhoto:(PFObject *)hostCityImageData;
- (Survey *)getSurvey:(PFObject *)surveyData;
- (SurveyQuestion *)getSurveyQues:(PFObject *)surveyQuesData;
- (Quiz *)getQuiz:(NSDictionary *)quizData;
- (QuizQuestion *)getQuizQues:(PFObject *)quizQuesData;

@end
