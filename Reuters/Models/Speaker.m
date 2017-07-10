//
//  Speaker.m
//  Reuters
//
//  Created by Sonali on 02/02/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import "Speaker.h"

@implementation Speaker

@synthesize objectId;
@synthesize teamName;
@synthesize sponspor;
@synthesize sponsorImage;
@synthesize teamLogo;
@synthesize contactNo;
@synthesize owner;
@synthesize groupId;

- (NSComparisonResult)compareName:(Speaker *)otherSp
{
    return [teamName compare:otherSp.teamName];
}

@end
