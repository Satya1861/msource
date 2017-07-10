//
//  SurveyQuestion.h
//  Reuters
//
//  Created by Sonali on 19/02/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Survey.h"

@interface SurveyQuestion : NSObject

@property (nonatomic, retain) NSString *objectId;
@property (nonatomic, retain) NSMutableArray *optionsArr;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSNumber *questionNum;
@property (nonatomic) NSString *image;
@property (nonatomic) NSString *surveyType;

@end
