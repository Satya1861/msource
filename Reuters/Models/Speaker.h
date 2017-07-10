//
//  Speaker.h
//  Reuters
//
//  Created by Sonali on 02/02/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Group.h"
@interface Speaker : NSObject

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *longName;
@property (nonatomic, strong) NSString *sponspor;
@property (nonatomic, strong) NSString *sponsorImage;
@property (nonatomic, strong) NSString *owner;
@property (nonatomic, strong) NSDictionary *groupId;
@property (nonatomic, strong) NSString *teamLogo;
@property (nonatomic, strong) NSDate *contactNo;

- (NSComparisonResult)compareName:(Speaker *)otherSp;

@end
