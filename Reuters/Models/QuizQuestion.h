//
//  QuizQuestion.h
//  Reuters
//
//  Created by Sonali on 19/02/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Quiz.h"

@interface QuizQuestion : NSObject

@property (nonatomic, retain) NSString *objectId;
@property (nonatomic, retain) NSMutableArray *optionsArr;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSString *answer;
@property (nonatomic, retain) NSNumber *questionNum;
@property (nonatomic) NSString *image;
@property (nonatomic) NSString *quizType;

@end
