//
//  Download.h
//  Reuters
//
//  Created by Sonali on 10/02/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Schedule.h"

@interface Download : NSObject

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *fileUrl;
@property (nonatomic) NSString *scheduleType;


@end
