//
//  AppUser.m
//  DemoSharingApp
//
//  Created by Priya on 27/01/15.
//  Copyright (c) 2015 Scriptlanes. All rights reserved.
//

#import "AppUser.h"

@implementation AppUser

@synthesize facebookLink;
@synthesize objectId;
@synthesize userName;
@synthesize email;
@synthesize password;
@synthesize contactNo;
@synthesize isPending;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.objectId forKey:@"objectId"];
    [encoder encodeObject:self.fullName forKey:@"fullName"];
    [encoder encodeObject:self.userName forKey:@"userName"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.password forKey:@"password"];
    [encoder encodeObject:self.contactNo forKey:@"contactNo"];
    [encoder encodeObject:self.facebookLink forKey:@"facebookLink"];
    if(self.isPending)
        [encoder encodeObject:[NSNumber numberWithBool:YES] forKey:@"isPending"];
    else
        [encoder encodeObject:[NSNumber numberWithBool:NO] forKey:@"isPending"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if( self != nil )
    {
        self.objectId = [decoder decodeObjectForKey:@"objectId"];
        self.userName  = [decoder decodeObjectForKey:@"userName"];
         self.fullName  = [decoder decodeObjectForKey:@"fullName"];
        self.email  = [decoder decodeObjectForKey:@"email"];
        self.password  = [decoder decodeObjectForKey:@"password"];
        self.contactNo  = [decoder decodeObjectForKey:@"contactNo"];
        self.facebookLink  = [decoder decodeObjectForKey:@"facebookLink"];
        self.isPending = [[decoder decodeObjectForKey:@"isPending"] boolValue];
    }
    return self;
}

@end
