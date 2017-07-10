//
//  Schedule.h
//  DemoSharingApp
//
//  Created by Sonali on 23/01/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Schedule : NSObject

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *matchName;
@property (nonatomic, strong) NSDictionary *stadiumId;
@property (nonatomic, strong) NSDictionary *team1Id;
@property (nonatomic, strong) NSDictionary *team2Id;
@property (nonatomic, strong) NSDictionary *groupId;
@property (nonatomic, strong) NSDate *dateOfMatch;
@property (nonatomic) BOOL isPast;


@end
