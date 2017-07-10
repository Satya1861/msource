//
//  NetworkAccessor.h
//  DemoSharingApp
//
//  Created by Priya on 27/01/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Reachability/Reachability.h>
#import <Parse/Parse.h>
#import "DataAccessor.h"

@interface NetworkAccessor : NSObject
{
    Reachability *reachability;
}



+(NetworkAccessor *)shareNetworkAccessor;

-(BOOL)internetConnectivity;

-(void)getNotifications:(void (^) (NSInteger,NSDictionary *)) completion;

-(void)getSchedule:(void (^) (NSInteger,NSDictionary *)) completion;

-(void)getResults:(void (^) (NSInteger,NSDictionary *)) completion;

-(void)getFolders:(void (^) (NSInteger,NSDictionary *)) completion;


-(void)getStandings:(NSString *)url :(void (^) (NSInteger,NSDictionary *)) completion;

-(void)getHelpDesk:(void (^) (NSInteger,NSDictionary *)) completion;

-(void)getLandingPage:(void (^) (NSInteger,NSDictionary *)) completion;

-(void)getHostCity:(void (^) (NSInteger,NSDictionary *)) completion;

-(void)getReminderHistory:(NSString *)objId :(void (^) (NSInteger,NSDictionary *)) completion;
-(void)getFeedbackQuestion:(void (^) (NSInteger,NSArray *)) completion;
-(void)getSpeaker:(void (^) (NSInteger,NSDictionary *)) completion;
-(void)submitAnswer:(NSDictionary *)postJson :(void (^) (NSInteger,NSDictionary *)) completion;
-(void)submitReminder:(NSDictionary *)postJson :(void (^) (NSInteger,NSDictionary *)) completion;
-(void)getZonalTeam:(void (^) (NSInteger,NSDictionary *)) completion;
-(void)getMembers:(NSString *)objId :(void (^) (NSInteger,NSDictionary *)) completion;
-(void)getSummary:(NSString *)objId :(void (^) (NSInteger,NSDictionary *)) completion;
-(void)getSpeakers:(NSArray *)speakerArr :(void (^) (NSInteger,NSArray *)) completion;
-(void)getSessions:(NSString *)objId :(void (^) (NSInteger,NSArray *)) completion;
-(void)getHostCityImages:(NSString *)objId :(void (^) (NSInteger,NSArray *)) completion;
-(void)getDownloads:(void (^) (NSInteger,NSArray *)) completion;
-(void)getDownloadsForSchedule:(NSString *)scheduleId :(void (^) (NSInteger,NSArray *)) completion;
-(void)getTwitter:(void (^) (NSInteger,NSDictionary *)) completion;
-(void)getQuestions:(void (^) (NSInteger,NSDictionary *)) completion;
-(void)getPhotos:(NSString *)objId :(void (^) (NSInteger,NSArray *)) completion;
-(void)checkIfUserExist:(NSString *)objId :(void (^) (NSInteger,NSArray *)) completion;
-(void)getSurveys:(void (^) (NSInteger,NSArray *)) completion;
-(void)getSurveyQuestions:(NSString *)objId :(void (^) (NSInteger,NSArray *)) completion;
-(void)getQuiz:(void (^) (NSInteger,NSArray *)) completion;
-(void)getQuizRules:(void (^) (NSInteger,NSDictionary *)) completion;
-(void)getQuizQuestions:(NSString *)objId :(void (^) (NSInteger,NSArray *)) completion;
-(void)getSponsors:(void (^) (NSInteger,NSArray *)) completion;

@end
