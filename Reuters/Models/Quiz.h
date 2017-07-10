//
//  Quiz.h
//  Reuters
//
//  Created by Sonali on 19/02/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quiz : NSObject

@property (nonatomic, retain) NSString *objectId;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSString *option1;
@property (nonatomic, retain) NSString *option2;
@property (nonatomic, retain) NSString *option3;
@property (nonatomic, retain) NSString *option4;
@property (nonatomic, strong) NSDate *dateOfQuestion;



@end
