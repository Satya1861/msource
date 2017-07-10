//
//  NetworkAccessor.m
//  DemoSharingApp
//
//  Created by Sonali on 27/01/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import "NetworkAccessor.h"
#import <AFNetworking/AFNetworking.h>
#import <Parse/Parse.h>
#import "Survey.h"
#import "Constants.h"

@implementation NetworkAccessor

id networkAccessor;

+(NetworkAccessor *)shareNetworkAccessor{
    
    if(networkAccessor == nil){
        
        networkAccessor = [[NetworkAccessor alloc] init];
        
    }
    return networkAccessor;
}

-(BOOL)internetConnectivity{
    
    bool connect = NO;
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
       
        
    } else {
        connect = YES;
        
    }
    return connect;
}
-(void)getResults:(void (^)(NSInteger, NSDictionary *))completion
{
    NSString *result = [restCloudUrl stringByAppendingString:resultsUrl];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:applicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:restAPIkey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setTimeoutInterval:40];
    
    [manager POST:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:@{@"isPast":@"YES"} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completion(1,responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        completion(0,nil);
    }];

}
-(void)getFolders:(void (^)(NSInteger, NSDictionary *))completion
{
    NSString *result = [restCloudUrl stringByAppendingString:folderUrl];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:applicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:restAPIkey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setTimeoutInterval:40];
    
    [manager POST:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completion(1,responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        completion(0,nil);
    }];

}

-(void)getStandings:(NSString *)url :(void (^)(NSInteger, NSDictionary *))completion
{
    NSString *result = [restCloudUrl stringByAppendingString:url];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:applicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:restAPIkey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setTimeoutInterval:40];
    
    [manager POST:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:@{@"isPast":@"YES"} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completion(1,responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        completion(0,nil);
    }];
}

-(void)getHelpDesk:(void (^)(NSInteger, NSDictionary *))completion
{
    NSString *result = [restServerUrl stringByAppendingString:helpDeskUrl];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:applicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:restAPIkey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setTimeoutInterval:40];
    
    [manager GET:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completion(1,responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        completion(0,nil);
    }];

}

-(void)getLandingPage:(void (^)(NSInteger, NSDictionary *))completion
{
    NSString *result = [restServerUrl stringByAppendingString:landingUrl];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:applicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:restAPIkey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setTimeoutInterval:40];
    
    [manager GET:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completion(1,responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        completion(0,nil);
    }];

}
-(void)getNotifications:(void (^)(NSInteger, NSDictionary *))completion
{
    NSString *fixture = [restServerUrl stringByAppendingString:NotificationUrl];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:applicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:restAPIkey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[fixture stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setTimeoutInterval:40];
    
    [manager GET:[fixture stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completion(1,responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        completion(0,nil);
    }];

}
-(void)getSchedule:(void (^)(NSInteger, NSDictionary *))completion
{
    

    
    NSString *fixture = [restServerUrl stringByAppendingString:fixturesURL];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:applicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:restAPIkey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[fixture stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setTimeoutInterval:40];
    
    [manager GET:[fixture stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completion(1,responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        completion(0,nil);
    }];
 
}
-(void)getTwitter:(void (^)(NSInteger, NSDictionary *))completion
{
    NSString *fixture = [restServerUrl stringByAppendingString:twitterUrl];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:applicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:restAPIkey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[fixture stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setTimeoutInterval:40];
    
    [manager GET:[fixture stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completion(1,responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        completion(0,nil);
    }];

}

-(void)getQuestions:(void (^)(NSInteger, NSDictionary *))completion
{
    
    DataAccessor *dataAC = [DataAccessor shareDataAccessor];
    AppUser * user = [dataAC loggedInUser];
    NSString *fixture = [restCloudUrl stringByAppendingString:questionsUrl];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:applicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:restAPIkey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[fixture stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setTimeoutInterval:40];
    
    [manager POST:[fixture stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:@{@"appUserId":user.objectId} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completion(1,responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        completion(0,nil);
    }];

}

-(void)getSpeaker:(void (^) (NSInteger,NSDictionary *)) completion
{
    
   
    NSString *fixture = [restServerUrl stringByAppendingString:teamURL];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:applicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:restAPIkey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[fixture stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setTimeoutInterval:40];
    
    [manager GET:[fixture stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completion(1,responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        completion(0,nil);
    }];

}
-(void)getZonalTeam:(void (^) (NSInteger,NSDictionary *)) completion
{
    
    
    NSString *fixture = [restServerUrl stringByAppendingString:zonalteamURL];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:applicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:restAPIkey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[fixture stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setTimeoutInterval:40];
    
    [manager GET:[fixture stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completion(1,responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        completion(0,nil);
    }];
    
}
-(void)getHostCity:(void (^)(NSInteger, NSDictionary *))completion
{
    NSString *fixture = [restServerUrl stringByAppendingString:aboutUsDataUrl];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:applicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:restAPIkey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[fixture stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setTimeoutInterval:40];
    
    [manager GET:[fixture stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completion(1,responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        completion(0,nil);
    }];
}

-(void)getFeedbackQuestion:(void (^)(NSInteger, NSArray *))completion
{
    PFQuery *query=[PFQuery queryWithClassName:@"FeedbackQuestion"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            
                       completion(1,objects);
        }
        else
        {
          
        }
    }];

}
-(void)getSummary:(NSString *)objId :(void (^)(NSInteger, NSDictionary *))completion
{
    NSString *grade = [summary stringByReplacingOccurrencesOfString:@"OBJECTID" withString:objId];
    
    NSString *gradeUrl = [restServerUrl stringByAppendingString:grade];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:applicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:restAPIkey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[gradeUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setTimeoutInterval:40];
    
    [manager GET:[gradeUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completion(1,responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        completion(0,nil);
    }];

}
-(void)submitAnswer:(NSDictionary *)postJson :(void (^)(NSInteger, NSDictionary *))completion
{
    NSString *result = [restCloudUrl stringByAppendingString:submitAnswerUrl];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:applicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:restAPIkey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setTimeoutInterval:40];
    
    [manager POST:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:postJson success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completion(1,responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        completion(0,nil);
    }];

}

-(void)submitReminder:(NSDictionary *)postJson :(void (^)(NSInteger, NSDictionary *))completion
{
    NSString *result = [restServerUrl stringByAppendingString:submitReminderUrl];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:applicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:restAPIkey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setTimeoutInterval:40];
    
    [manager POST:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:postJson success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completion(1,responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        completion(0,nil);
    }];
}
-(void)getMembers:(NSString *)objId :(void (^)(NSInteger, NSDictionary *))completion
{
    NSString *grade = [membersURL stringByReplacingOccurrencesOfString:@"OBJECTID" withString:objId];
    
    NSString *gradeUrl = [restServerUrl stringByAppendingString:grade];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:applicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:restAPIkey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[gradeUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setTimeoutInterval:40];
    
    [manager GET:[gradeUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completion(1,responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        completion(0,nil);
    }];

}

-(void)getReminderHistory:(NSString *)objId :(void (^)(NSInteger, NSDictionary *))completion
{
    DataAccessor *dataAC = [DataAccessor shareDataAccessor];
    AppUser * user = [dataAC loggedInUser];
    NSString *appUserObjectId = user.objectId;
    
    NSString *grade = [reminderHistoryUrl stringByReplacingOccurrencesOfString:@"OBJECTID" withString:objId];
    NSString *g1 = [grade stringByReplacingOccurrencesOfString:@"APPUSERID" withString:appUserObjectId];
    NSString *gradeUrl = [restServerUrl stringByAppendingString:g1];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:applicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:restAPIkey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[gradeUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setTimeoutInterval:40];
    
    [manager GET:[gradeUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completion(1,responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        completion(0,nil);
    }];

}
-(void)getSessions:(NSString *)objId :(void (^) (NSInteger,NSArray *)) completion{
    
    
    
    PFQuery *query=[PFQuery queryWithClassName:@"Sessions"];
    [query fromLocalDatastore];
    [query whereKey:@"scheduleType" equalTo:[PFObject objectWithoutDataWithClassName:@"Schedule" objectId:objId]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
          
            completion(1,objects);
        }
        else
        {
            
        }
    }];
   
}
-(void)getHostCityImages:(NSString *)objId :(void (^)(NSInteger, NSArray *))completion
{
    PFQuery *query=[PFQuery queryWithClassName:@"HostCityImage"];
    [query whereKey:@"hostCity" equalTo:[PFObject objectWithoutDataWithClassName:@"HostCity" objectId:objId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            
            completion(1,objects);
        }
        else
        {
           
        }
    }];
}


-(void)getSpeakers:(NSArray *)speakerArr :(void (^) (NSInteger,NSArray *)) completion
{
    PFQuery *query=[PFQuery queryWithClassName:@"Speaker"];
    [query whereKey:@"objectId" containedIn:speakerArr];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            
                    completion(1,objects);
        }
        else
        {
                    }
    }];
}

-(void)getDownloads:(void (^) (NSInteger,NSArray *)) completion
{
    
    PFQuery *query=[PFQuery queryWithClassName:@"Downloads"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            
                      completion(1,objects);
        }
        else
        {
                    }
    }];

}

-(void)getDownloadsForSchedule:(NSString *)scheduleId :(void (^) (NSInteger,NSArray*)) completion
{
    //SCHEDULEID
   
    PFQuery *query=[PFQuery queryWithClassName:@"Downloads"];
    [query whereKey:@"scheduleType" equalTo:[PFObject objectWithoutDataWithClassName:@"Schedule" objectId:scheduleId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
          
            completion(1,objects);
        }
        else
        {
            
        }
    }];}

-(void)getPhotos:(NSString *)objId :(void (^) (NSInteger,NSArray *)) completion
{
    
    PFQuery *query=[PFQuery queryWithClassName:@"Photos"];
    [query whereKey:@"photoFolderId" equalTo:[PFObject objectWithoutDataWithClassName:@"PhotoFolder" objectId:objId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            
           
            completion(1,objects);
        }
        else
        {
           
        }
    }];
}

-(void)checkIfUserExist:(NSString *)objId :(void (^)(NSInteger, NSArray *))completion
{
    PFQuery *query=[PFQuery queryWithClassName:@"AppUser"];
    [query whereKey:@"installationId" equalTo:[PFObject objectWithoutDataWithClassName:@"Installation" objectId:objId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            
            
            completion(1,objects);
        }
        else
        {
            
        }
    }];
}

-(void)getSponsors:(void (^) (NSInteger,NSArray *)) completion
{
    
    PFQuery *query=[PFQuery queryWithClassName:@"Sponsors"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            
         
            
            completion(1,objects);
        }
        else
        {
            
        }
    }];
}


-(void)getSurveys:(void (^) (NSInteger,NSArray *)) completion{
    
    
    PFQuery *query=[PFQuery queryWithClassName:@"Survey"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            
         
            completion(1,objects);
        }
        else
        {
           
        }
    }];

}

-(void)getSurveyQuestions:(NSString *)objId :(void (^) (NSInteger,NSArray *)) completion
{
 
    PFQuery *query=[PFQuery queryWithClassName:@"SurveyQuestion"];
    [query whereKey:@"surveyType" equalTo:[PFObject objectWithoutDataWithClassName:@"Survey" objectId:objId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
         
            completion(1,objects);
        }
        else
        {
        }
    }];
}

-(void)getQuiz:(void (^) (NSInteger,NSArray *)) completion
{
    PFQuery *query=[PFQuery queryWithClassName:@"Quiz"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            
            completion(1,objects);
        }
        else
        {
           
        }
    }];
}
-(void)getQuizRules:(void (^)(NSInteger, NSDictionary *))completion
{
    NSString *result = [restServerUrl stringByAppendingString:quizRulesUrl];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:applicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:restAPIkey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setTimeoutInterval:40];
    
    [manager GET:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completion(1,responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        completion(0,nil);
    }];

}
-(void)getQuizQuestions:(NSString *)objId :(void (^) (NSInteger,NSArray*)) completion
{
    
    PFQuery *query=[PFQuery queryWithClassName:@"QuizQuestion"];
    [query whereKey:@"quizType" equalTo:[PFObject objectWithoutDataWithClassName:@"Quiz" objectId:objId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
          
            completion(1,objects);
        }
        else
        {
            
        }
    }];

}


@end
