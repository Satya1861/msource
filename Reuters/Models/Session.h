//
//  Session.h
//  Reuters
//
//  Created by Sonali on 19/02/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Schedule.h"

@interface Session : NSObject

@property (nonatomic, retain) NSString *objectId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic) Schedule *scheduleType;
@property (nonatomic, retain) NSString *speaker;
@property (nonatomic) NSDate *startTime;
@property (nonatomic) NSDate *endTime;
@property (nonatomic, strong) NSString *speakerName;
@end
